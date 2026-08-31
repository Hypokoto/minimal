# OffSec: Enumeration

- **Port Scanning**: `rustscan -a <IP>`, `nmap -sS -p- <IP>`.
- Note: TCP SYN Scans (`-sS`) are fast but NOT stealthy against modern IDS/IPS.
- **Service Fingerprinting**: Identify exact version numbers and configurations.
