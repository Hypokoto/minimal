use std::process::Stdio;
use tokio::io::{AsyncBufReadExt, BufReader};
use tokio::process::Command;
// removed
use crossbeam_channel::Sender;
use eframe::egui::Context;

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
    abort_tx: Option<tokio::sync::oneshot::Sender<()>>,
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
        let (abort_tx, mut abort_rx) = tokio::sync::oneshot::channel();
        self.abort_tx = Some(abort_tx);
        
        let tx = self.tx.clone();
        let ctx = self.ctx.clone();

        tokio::spawn(async move {
            let mut cmd = Command::new(&program);
            cmd.args(&args);
            cmd.stdout(Stdio::piped());
            cmd.stderr(Stdio::piped());
            cmd.kill_on_drop(true);

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
            let out_task = tokio::spawn(async move {
                let mut reader = BufReader::new(stdout).lines();
                while let Ok(Some(line)) = reader.next_line().await {
                    let _ = tx_out.send(ProcessEvent::Stdout(line));
                    ctx_out.request_repaint();
                }
            });

            let tx_err = tx.clone();
            let ctx_err = ctx.clone();
            let err_task = tokio::spawn(async move {
                let mut reader = BufReader::new(stderr).lines();
                while let Ok(Some(line)) = reader.next_line().await {
                    let _ = tx_err.send(ProcessEvent::Stderr(line));
                    ctx_err.request_repaint();
                }
            });

            tokio::select! {
                _ = &mut abort_rx => {
                    let _ = child.kill().await;
                    let _ = tx.send(ProcessEvent::Error("Process terminated by user".to_string()));
                }
                status = child.wait() => {
                    match status {
                        Ok(exit_status) => {
                            let _ = tx.send(ProcessEvent::Exit(exit_status.code()));
                        }
                        Err(e) => {
                            let _ = tx.send(ProcessEvent::Error(format!("Wait error: {}", e)));
                        }
                    }
                }
            }

            // Wait for streams to finish
            let _ = out_task.await;
            let _ = err_task.await;
            
            ctx.request_repaint();
        });
    }

    pub fn stop(&mut self) {
        if let Some(abort) = self.abort_tx.take() {
            let _ = abort.send(());
        }
    }
}
