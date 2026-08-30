use std::time::Duration;
use crossbeam_channel::Sender;
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
        loop {
            let iface = get_cmd_output("sh", &["-c", "ip route show default 2>/dev/null | awk '/default/ {print $5; exit}'"]);
            let iface = if iface.is_empty() { "?".to_string() } else { iface };

            let local_ip = if iface != "?" {
                let out = get_cmd_output("sh", &["-c", &format!("ip -4 addr show {} 2>/dev/null | awk '/inet / {{print $2}}' | cut -d/ -f1", iface)]);
                if out.is_empty() { "?".to_string() } else { out }
            } else {
                "?".to_string()
            };

            let pub_ip = match reqwest::blocking::Client::builder().timeout(Duration::from_secs(2)).build() {
                Ok(client) => {
                    match client.get("https://icanhazip.com").send() {
                        Ok(res) => res.text().unwrap_or_default().trim().to_string(),
                        Err(_) => "--".to_string(),
                    }
                }
                Err(_) => "--".to_string(),
            };

            let estab = get_cmd_output("sh", &["-c", "ss -tp state established 2>/dev/null | grep -c ESTAB"]);
            let estab = if estab.is_empty() { "0".to_string() } else { estab };

            let status = NetworkStatus {
                iface,
                local_ip,
                pub_ip,
                estab,
            };

            let _ = tx.send(status);
            ctx.request_repaint();

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
