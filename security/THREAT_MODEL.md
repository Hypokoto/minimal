# Threat Model: Minimal OS Shell

This document defines the realistic threat model for this Hyprland-based desktop environment. It explicitly defines what threats the architecture attempts to mitigate and what threats are considered out-of-scope.

## In-Scope Threats (Actively Mitigated)
1. **Accidental Background Bloat**: A major risk to desktop performance and security is the slow accumulation of persistent polling daemons (e.g., system monitors, network applets).
   - *Mitigation*: Strict Process Budget (`PROCESS_BUDGET.md`), event-driven architecture, and CI regression checks.
2. **Predictable State/Temp File Attacks**: Scripts using predictable paths (e.g., `/tmp/file.$$`) allow local attackers to overwrite critical data via symlinks.
   - *Mitigation*: Native `mktemp` usage, and `XDG_RUNTIME_DIR` for user-specific volatile state.
3. **UI-driven Command Injection**: Untrusted or malformed strings returned by UI elements (like Rofi or Waybar) executing arbitrary shell commands.
   - *Mitigation*: Strict regex validation on inputs (e.g., MAC addresses) before passing them to execution contexts. Hardcoded fixed commands instead of `eval` or dynamic construction.
4. **Supply Chain Alteration**: Third-party package repositories silently becoming defaults and pushing malicious updates.
   - *Mitigation*: Official Arch repositories and the AUR are the only default sources. External repos (like Chaotic-AUR) require explicit, documented CLI opt-in flags during installation.
5. **Unnoticed Security Degradation**: The firewall silently failing or systemd services crashing in the background without user knowledge.
   - *Mitigation*: Event-driven and low-frequency Waybar security status abstractions that proactively alert the user on state degradation.

## Out-of-Scope Threats (Not Addressed by the Shell)
1. **Kernel-Level Exploits & Zero-Days**: This shell architecture relies on the underlying OS (Arch Linux) for kernel security.
2. **Browser Exploits & Sandbox Escapes**: If the browser is compromised, this desktop environment does not contain mandatory access controls (like SELinux/AppArmor) to sandbox the browser process itself.
3. **Physical Access Attacks**: If an attacker has unencrypted, physical access to the device or evil maid capabilities, the software configuration cannot prevent compromise. (Rely on LUKS Full Disk Encryption).
4. **Malicious AUR Packages**: While the supply chain is bounded, the user is still responsible for auditing AUR packages before installation. The installer automates the fetch but does not magically sandbox bad code.
