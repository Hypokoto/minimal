# shellcheck shell=bash
# ==============================================================================
# Minimal zsh/sec.zsh — Security & Networking Aliases
# Rust-first tooling for networking, offsec, defsec, and binary analysis.
#
# Philosophy: every binary alias is wrapped in command -v so the shell never
# breaks if a tool is uninstalled or absent.
#
# Tool map:
#   rustscan   → fast all-port sweep → nmap hand-off
#   feroxbuster → recursive web content discovery (fuzzing)
#   sniffnet   → real-time network traffic monitor (TUI/GUI)
#   netscanner → ARP LAN host discovery (TUI)
#   hexyl      → colored hex viewer for binary/malware analysis
#   xh         → friendly HTTP client (Rust, already installed)
#   cargo-audit → RustSec CVE scanner for Cargo.lock files
# ==============================================================================

# --- Network Recon (RustScan) ---
if command -v rustscan >/dev/null 2>&1; then
    alias scan='rustscan -a'                                    # quick: all ports
    alias scanf='rustscan -a --ulimit 5000 -- -sV -sC'         # full: version + scripts
    alias scan6='rustscan -a --ulimit 5000 --range 1-65535'    # explicit full range
fi

# --- LAN Discovery ---
if command -v netscanner >/dev/null 2>&1; then
    alias lscan='sudo netscanner'   # ARP-based LAN host discovery
fi

# --- DNS (doggo already installed, add ergonomic aliases) ---
if command -v doggo >/dev/null 2>&1; then
    alias dig='doggo'
    alias diga='doggo --type A'
    alias digmx='doggo --type MX'
    alias digns='doggo --type NS'
    alias digtxt='doggo --type TXT'
    alias digall='doggo --type ANY'
fi

# --- HTTP Client (xh — already installed) ---
if command -v xh >/dev/null 2>&1; then
    alias http='xh'
    alias https='xh --https'
    alias hget='xh GET'
    alias hpost='xh POST'
    alias hhead='xh HEAD'
    alias hj='xh --json'        # force JSON body
fi

# --- Web Content Discovery (feroxbuster) ---
if command -v feroxbuster >/dev/null 2>&1; then
    alias fuzz='feroxbuster -u'
    alias fuzzq='feroxbuster -u --quiet'
    # Shorthand with common wordlist (adjust path if seclists installed elsewhere)
    alias fuzz-common='feroxbuster -u --wordlist /usr/share/wordlists/dirb/common.txt'
fi

# --- Network Traffic Monitoring ---
if command -v sniffnet >/dev/null 2>&1; then
    alias sniff='sudo sniffnet'     # full TUI/GUI traffic monitor
fi

if command -v bandwhich >/dev/null 2>&1; then
    alias bw='sudo bandwhich'       # bandwidth by process/connection
fi

if command -v nethogs >/dev/null 2>&1; then
    alias nethog='sudo nethogs'
fi

# --- Network Diagnostics ---
if command -v trippy >/dev/null 2>&1; then
    alias trace='sudo trip'         # TUI traceroute (trippy)
fi

if command -v iperf3 >/dev/null 2>&1; then
    alias bwtest='iperf3 -c'        # throughput test (client mode)
    alias bwserv='iperf3 -s'        # throughput test (server mode)
fi

# --- Hex / Binary Analysis ---
if command -v hexyl >/dev/null 2>&1; then
    alias hex='hexyl'
    alias hexn='hexyl --length'     # hexyl --length N <file>
fi

# --- Cargo Security Audit & System Hardening ---
if command -v cargo-audit >/dev/null 2>&1; then
    alias audit='cargo audit'
fi

alias harden='bash ~/minimal/security/apply-hardening.sh'

# --- Port & Socket Inspection ---
alias listening='ss -tlnp'                  # TCP listening ports
alias udplisten='ss -ulnp'                  # UDP listening ports
alias estab='ss -tp state established'      # established TCP connections
alias fwrules='sudo iptables -L -n -v'      # iptables rules
alias pfwd='sudo iptables -t nat -L -n -v'  # NAT / port-forward rules
alias arp='ip neigh show'                   # ARP cache
alias routes='ip route show'                # routing table
alias iface='ip -c addr show'               # interfaces (colored)

# --- Nmap Shorthand ---
if command -v nmap >/dev/null 2>&1; then
    alias nmapq='nmap -sV -T4'              # quick version scan
    alias nmapfull='nmap -sV -sC -p- -T4'  # full port + default scripts
    alias nmapudp='sudo nmap -sU -T4'      # UDP scan
    alias nmapvuln='nmap --script vuln'    # run vuln NSE scripts
    alias nmapstealth='sudo nmap -sS -T2'  # SYN stealth scan
fi

# ==============================================================================
# Shell Functions
# ==============================================================================

# TLS certificate inspector
# Usage: sslinfo <host> [port=443]
sslinfo() {
    local host="${1:?usage: sslinfo <host> [port]}"
    local port="${2:-443}"
    echo | openssl s_client \
        -connect "${host}:${port}" \
        -servername "${host}" 2>/dev/null \
        | openssl x509 -noout -text \
        | grep -E "Subject:|Issuer:|Not Before|Not After|DNS:"
}

# HTTP response headers inspector
# Usage: headers <url>
headers() {
    local url="${1:?usage: headers <url>}"
    if command -v xh >/dev/null 2>&1; then
        xh HEAD "$url"
    else
        curl -sI "$url"
    fi
}

# Expand a CIDR range into individual IPs
# Usage: cidr 192.168.1.0/24
cidr() {
    local range="${1:?usage: cidr <CIDR>}"
    if command -v nmap >/dev/null 2>&1; then
        nmap -sL -n "$range" | awk '/Nmap scan report/{print $5}'
    else
        python3 -c "
import ipaddress
for ip in ipaddress.ip_network('${range}', strict=False):
    print(str(ip))
"
    fi
}

# Whois + reverse-DNS combo for an IP
# Usage: ipinfo 1.1.1.1
ipinfo() {
    local ip="${1:?usage: ipinfo <ip>}"
    echo "=== Reverse DNS ==="
    host "$ip" 2>/dev/null || echo "no PTR record"
    echo ""
    echo "=== Whois ==="
    whois "$ip" 2>/dev/null | grep -E "^(NetName|OrgName|Country|CIDR|inetnum|netname|descr|country):" | head -20
}
