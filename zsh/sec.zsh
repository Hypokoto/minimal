# shellcheck shell=bash
# ==============================================================================
# Minimal zsh/sec.zsh — Security & Networking Aliases
# Rust-first tooling for defensive security, networking, and auditing.
#
# Philosophy: every binary alias is wrapped in command -v so the shell never
# breaks if a tool is uninstalled or absent.
#
# Tool map:
#   sniffnet   → real-time network traffic monitor (TUI/GUI)
#   xh         → friendly HTTP client (Rust)
#   cargo-audit → RustSec CVE scanner for Cargo.lock files
# ==============================================================================

# --- DNS (doggo) ---
if command -v doggo >/dev/null 2>&1; then
    alias dig='doggo'
    alias diga='doggo --type A'
    alias digmx='doggo --type MX'
    alias digns='doggo --type NS'
    alias digtxt='doggo --type TXT'
    alias digall='doggo --type ANY'
fi

# --- HTTP Client (xh) ---
if command -v xh >/dev/null 2>&1; then
    alias http='xh'
    alias https='xh --https'
    alias hget='xh GET'
    alias hpost='xh POST'
    alias hhead='xh HEAD'
    alias hj='xh --json'        # force JSON body
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

# --- Security Audit & System Hardening ---
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
    python3 -c "
import ipaddress
for ip in ipaddress.ip_network('${range}', strict=False):
    print(str(ip))
"
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
