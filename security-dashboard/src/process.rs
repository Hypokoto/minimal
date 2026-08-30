use std::process::{Command, Stdio};
use std::io::{BufRead, BufReader};
use std::sync::mpsc::Sender;
use eframe::egui::Context;
use std::thread;
use std::time::Duration;

#[derive(Clone, Debug)]
pub enum ProcessEvent {
    Stdout(String),
    Stderr(String),
    Exit(Option<i32>),
    Error(String),
}

pub struct ProcessManager {
    pub tx: Sender<ProcessEvent>,
    pub ctx: Context,
    abort_tx: Option<Sender<()>>,
}

impl ProcessManager {
    pub fn new(tx: Sender<ProcessEvent>, ctx: Context) -> Self {
        Self {
            tx,
            ctx,
            abort_tx: None,
        }
    }

    pub fn spawn(&mut self, program: String, args: Vec<String>) {
        let (abort_tx, abort_rx) = std::sync::mpsc::channel();
        self.abort_tx = Some(abort_tx);
        
        let tx = self.tx.clone();
        let ctx = self.ctx.clone();

        thread::spawn(move || {
            let mut cmd = Command::new(&program);
            cmd.args(&args);
            if let Ok(home) = std::env::var("HOME") {
                cmd.current_dir(format!("{}/minimal/security-dashboard", home));
            }
            cmd.stdout(Stdio::piped());
            cmd.stderr(Stdio::piped());

            let mut child = match cmd.spawn() {
                Ok(c) => c,
                Err(e) => {
                    let _ = tx.send(ProcessEvent::Error(format!("Failed to spawn {}: {}", program, e)));
                    ctx.request_repaint();
                    return;
                }
            };

            let stdout = child.stdout.take().unwrap();
            let stderr = child.stderr.take().unwrap();

            let tx_out = tx.clone();
            let ctx_out = ctx.clone();
            thread::spawn(move || {
                let reader = BufReader::new(stdout);
                for l in reader.lines().map_while(Result::ok) {
                    let _ = tx_out.send(ProcessEvent::Stdout(l));
                    ctx_out.request_repaint();
                }
            });

            let tx_err = tx.clone();
            let ctx_err = ctx.clone();
            thread::spawn(move || {
                let reader = BufReader::new(stderr);
                for l in reader.lines().map_while(Result::ok) {
                    let _ = tx_err.send(ProcessEvent::Stderr(l));
                    ctx_err.request_repaint();
                }
            });

            loop {
                if abort_rx.try_recv().is_ok() {
                    let _ = child.kill();
                    let _ = child.wait();
                    let _ = tx.send(ProcessEvent::Error("Process terminated by user".to_string()));
                    break;
                }

                match child.try_wait() {
                    Ok(Some(status)) => {
                        let _ = tx.send(ProcessEvent::Exit(status.code()));
                        break;
                    }
                    Ok(None) => thread::sleep(Duration::from_millis(50)),
                    Err(e) => {
                        let _ = tx.send(ProcessEvent::Error(format!("Wait error: {}", e)));
                        break;
                    }
                }
            }
            ctx.request_repaint();
        });
    }

    pub fn stop(&mut self) {
        if let Some(abort) = self.abort_tx.take() {
            let _ = abort.send(());
        }
    }
}
