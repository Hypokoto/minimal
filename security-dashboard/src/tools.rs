use std::process::Command;

#[derive(Clone, Debug)]
pub enum ArgType {
    String { label: String, default: String },
    Select { label: String, options: Vec<String>, default: String },
}

#[derive(Clone, Debug)]
pub struct ToolDefinition {
    pub name: String,
    pub program: String,
    pub required_args: Vec<ArgType>,
    pub build_args: fn(&[String]) -> Vec<String>,
    pub is_available: bool,
}

fn check_available(prog: &str) -> bool {
    Command::new("which").arg(prog).output().map(|o| o.status.success()).unwrap_or(false)
}

pub fn get_tools() -> Vec<ToolDefinition> {
    vec![
        ToolDefinition {
            name: "Port Scan".to_string(),
            program: "rustscan".to_string(),
            required_args: vec![
                ArgType::String { label: "Target".to_string(), default: "127.0.0.1".to_string() }
            ],
            build_args: |inputs| vec!["-a".to_string(), "--".to_string(), inputs[0].clone()],
            is_available: check_available("rustscan"),
        },
        ToolDefinition {
            name: "Nmap Quick".to_string(),
            program: "nmap".to_string(),
            required_args: vec![
                ArgType::String { label: "Target".to_string(), default: "127.0.0.1".to_string() }
            ],
            build_args: |inputs| vec!["-F".to_string(), "--".to_string(), inputs[0].clone()],
            is_available: check_available("nmap"),
        },
        ToolDefinition {
            name: "Nmap Full".to_string(),
            program: "nmap".to_string(),
            required_args: vec![
                ArgType::String { label: "Target".to_string(), default: "127.0.0.1".to_string() }
            ],
            build_args: |inputs| vec!["-A".to_string(), "--".to_string(), inputs[0].clone()],
            is_available: check_available("nmap"),
        },
        ToolDefinition {
            name: "UDP Scan".to_string(),
            program: "nmap".to_string(),
            required_args: vec![
                ArgType::String { label: "Target".to_string(), default: "127.0.0.1".to_string() }
            ],
            build_args: |inputs| vec!["-sU".to_string(), "--".to_string(), inputs[0].clone()],
            is_available: check_available("nmap"),
        },
        ToolDefinition {
            name: "Trace Route".to_string(),
            program: "traceroute".to_string(),
            required_args: vec![
                ArgType::String { label: "Target".to_string(), default: "8.8.8.8".to_string() }
            ],
            build_args: |inputs| vec!["--".to_string(), inputs[0].clone()],
            is_available: check_available("traceroute"),
        },
        ToolDefinition {
            name: "LAN Scan".to_string(),
            program: "netscanner".to_string(),
            required_args: vec![],
            build_args: |_| vec![],
            is_available: check_available("netscanner"),
        },
        ToolDefinition {
            name: "Web Fuzz".to_string(),
            program: "feroxbuster".to_string(),
            required_args: vec![
                ArgType::String { label: "URL".to_string(), default: "http://localhost".to_string() }
            ],
            build_args: |inputs| vec!["-u".to_string(), "--".to_string(), inputs[0].clone()],
            is_available: check_available("feroxbuster"),
        },
        ToolDefinition {
            name: "HTTP Client".to_string(),
            program: "xh".to_string(),
            required_args: vec![
                ArgType::String { label: "URL".to_string(), default: "https://httpbin.org/get".to_string() }
            ],
            build_args: |inputs| vec!["--".to_string(), inputs[0].clone()],
            is_available: check_available("xh"),
        },
        ToolDefinition {
            name: "Speedtest".to_string(),
            program: "speedtest-cli".to_string(),
            required_args: vec![],
            build_args: |_| vec![],
            is_available: check_available("speedtest-cli"),
        },
        ToolDefinition {
            name: "Cargo Audit".to_string(),
            program: "cargo".to_string(),
            required_args: vec![],
            build_args: |_| vec!["audit".to_string()],
            is_available: check_available("cargo"),
        },
        ToolDefinition {
            name: "Bandwidth Test".to_string(),
            program: "iperf3".to_string(),
            required_args: vec![
                ArgType::String { label: "Server".to_string(), default: "ping.online.net".to_string() }
            ],
            build_args: |inputs| vec!["-c".to_string(), "--".to_string(), inputs[0].clone()],
            is_available: check_available("iperf3"),
        }
    ]
}
