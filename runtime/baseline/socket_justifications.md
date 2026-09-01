# Listening Socket Invariants & Justifications

Every listening socket on the host must be accounted for with an explicit owner, binding interface, and security assessment.

| Local Address | Port | Process / Owner | Binding Scope | Security Assessment / Justification |
|---|---|---|---|---|
| `127.0.0.1` / `[::1]` | 631 | `cupsd` | Loopback Only | Local print scheduler. Isolated to localhost; zero external exposure. |
| `0.0.0.0` / `[::1]` | 22 | `sshd` | All Interfaces | Remote SSH administration. Protected by `nftables` firewall drop policy. |
| `127.0.0.1` | 35335, 35799 | `agy` | Loopback Only | Agent IPC control socket. Isolated to localhost. |
| `127.0.0.1` | 11434 | `ollama` | Loopback Only | Local AI LLM API server. Isolated to localhost. |
| `127.0.0.1` | 36023 | `python` | Loopback Only | Transient local development server. Isolated to localhost. |

## Socket Rule
Unbound external listening ports (e.g. `0.0.0.0:<port>`) without an active firewall or justification are classified as security violations.
