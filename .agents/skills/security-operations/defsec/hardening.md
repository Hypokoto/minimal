# DefSec: Hardening

### The Hardening Lifecycle
Control -> Does system need this? -> No (Disable) / Yes (Restrict/Monitor) -> Verify -> Record

### Arch Linux Specifics
- **Kernel Parameters**: Evaluate `sysctl`. Do not blindly apply. (e.g., `kernel.unprivileged_bpf_disabled=1` is good, but breaks unprivileged eBPF tracing).
- **Network Blacklists**: Blacklist obscure protocols (DCCP, SCTP, RDS, TIPC) in `/etc/modprobe.d/` if unused.
- **Service Minimization**: Disable unused systemd services.
