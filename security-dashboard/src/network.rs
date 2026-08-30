use std::time::Duration;
use std::sync::mpsc::Sender;
use eframe::egui::Context;

#[derive(Clone, Default, Debug)]
pub struct NetworkStatus {
    pub iface: String,
    pub local_ip: String,
    pub pub_ip: String,
    pub estab: String,
}

pub fn spawn_network_monitor(tx: Sender<NetworkStatus>, ctx: Context) {
    std::thread::spawn(move || {
        let mut loop_count = 0;
        let mut cached_pub_ip = "--".to_string();

        loop {
            let iface = get_cmd_output("sh", &["-c", "ip route show default 2>/dev/null | awk '/default/ {print $5; exit}'"]);
            let iface = if iface.is_empty() { "?".to_string() } else { iface };

            let local_ip = if iface != "?" {
                let out = get_cmd_output("sh", &["-c", &format!("ip -4 addr show {} 2>/dev/null | awk '/inet / {{print $2}}' | cut -d/ -f1", iface)]);
                if out.is_empty() { "?".to_string() } else { out }
            } else {
                "?".to_string()
            };

            if loop_count % 12 == 0 || cached_pub_ip == "--" {
                let out = get_cmd_output("curl", &["-s", "--max-time", "2", "https://icanhazip.com"]);
                if !out.is_empty() {
                    cached_pub_ip = out;
                }
            }

            let estab = get_cmd_output("sh", &["-c", "ss -tp state established 2>/dev/null | grep -c ESTAB"]);
            let estab = if estab.is_empty() { "0".to_string() } else { estab };

            let status = NetworkStatus {
                iface,
                local_ip,
                pub_ip: cached_pub_ip.clone(),
                estab,
            };

            let _ = tx.send(status);
            ctx.request_repaint();

            loop_count += 1;
            std::thread::sleep(Duration::from_secs(5));
        }
    });
}

fn get_cmd_output(cmd: &str, args: &[&str]) -> String {
    if let Ok(out) = std::process::Command::new(cmd).args(args).output() {
        if out.status.success() {
            return String::from_utf8_lossy(&out.stdout).trim().to_string();
        }
    }
    String::new()
}
