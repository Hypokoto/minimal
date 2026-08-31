# DefSec: Verification

Always test hardening changes:
- If IPv6 is disabled, check if DNS resolution or local routing breaks.
- If unprivileged BPF is disabled, verify that intended monitoring tools still work.
