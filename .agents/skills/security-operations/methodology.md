# SecOps Methodology

1. **Authorization is Absolute**: Never assume scope.
2. **Do No Harm**: Understand the impact of every command before execution.
3. **Defense in Depth**: Hardening is contextual. (e.g., Do not blindly disable IPv6 without verifying it doesn't break required network configurations; do not blindly disable BPF without verifying container/monitoring requirements).
4. **Assume Compromise**: Use telemetry and logging to actively hunt threats.
