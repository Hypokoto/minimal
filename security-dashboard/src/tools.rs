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
}

pub fn get_tools() -> Vec<ToolDefinition> {
    vec![
        ToolDefinition {
            name: "Port Scan".to_string(),
            program: "rustscan".to_string(),
            required_args: vec![
                ArgType::String { label: "Target".to_string(), default: "127.0.0.1".to_string() }
            ],
            build_args: |inputs| vec!["-a".to_string(), inputs[0].clone()],
        },
        ToolDefinition {
            name: "Nmap Quick".to_string(),
            program: "nmap".to_string(),
            required_args: vec![
                ArgType::String { label: "Target".to_string(), default: "127.0.0.1".to_string() }
            ],
            build_args: |inputs| vec!["-F".to_string(), inputs[0].clone()],
        },
        ToolDefinition {
            name: "Nmap Full".to_string(),
            program: "nmap".to_string(),
            required_args: vec![
                ArgType::String { label: "Target".to_string(), default: "127.0.0.1".to_string() }
            ],
            build_args: |inputs| vec!["-A".to_string(), inputs[0].clone()],
        },
        ToolDefinition {
            name: "UDP Scan".to_string(),
            program: "sudo".to_string(),
            required_args: vec![
                ArgType::String { label: "Target".to_string(), default: "127.0.0.1".to_string() }
            ],
            build_args: |inputs| vec!["nmap".to_string(), "-sU".to_string(), inputs[0].clone()],
        },
        ToolDefinition {
            name: "Trace Route".to_string(),
            program: "sudo".to_string(),
            required_args: vec![
                ArgType::String { label: "Target".to_string(), default: "8.8.8.8".to_string() }
            ],
            // 'trip' is trippy, which requires a terminal, but maybe we can just use standard traceroute here
            // since the user wants stdout output. Standard traceroute prints lines. Trippy does not.
            // Wait, we can use `traceroute` or `mtr -r -c 1`. The script used `trip`.
            // Let's use standard `traceroute` or `mtr --report` so it outputs text!
            build_args: |inputs| vec!["traceroute".to_string(), inputs[0].clone()],
        },
        ToolDefinition {
            name: "LAN Scan".to_string(),
            program: "sudo".to_string(),
            required_args: vec![],
            build_args: |_| vec!["netscanner".to_string()],
        },
        ToolDefinition {
            name: "Web Fuzz".to_string(),
            program: "feroxbuster".to_string(),
            required_args: vec![
                ArgType::String { label: "URL".to_string(), default: "http://localhost".to_string() }
            ],
            build_args: |inputs| vec!["-u".to_string(), inputs[0].clone()],
        },
        ToolDefinition {
            name: "HTTP Client".to_string(),
            program: "xh".to_string(),
            required_args: vec![
                ArgType::String { label: "URL".to_string(), default: "https://httpbin.org/get".to_string() }
            ],
            build_args: |inputs| vec![inputs[0].clone()],
        },
        ToolDefinition {
            name: "Speedtest".to_string(),
            program: "speedtest-cli".to_string(),
            required_args: vec![],
            build_args: |_| vec![],
        },
        ToolDefinition {
            name: "Cargo Audit".to_string(),
            program: "cargo".to_string(),
            required_args: vec![],
            build_args: |_| vec!["audit".to_string()],
        },
        ToolDefinition {
            name: "Bandwidth Test".to_string(),
            program: "iperf3".to_string(),
            required_args: vec![
                ArgType::String { label: "Server".to_string(), default: "ping.online.net".to_string() }
            ],
            build_args: |inputs| vec!["-c".to_string(), inputs[0].clone()],
        }
    ]
}
