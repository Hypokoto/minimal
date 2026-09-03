# Desktop Process Budget

This document defines the strict process baseline for the Minimal OS Shell. Any persistent process that is not explicitly authorized here is considered a violation of the process budget and should be removed or converted to an on-demand/event-driven architecture.

## Required Persistent Processes (Core Desktop)
These processes are fundamentally required to maintain the graphical session and core system functionality.
- **Hyprland** (Compositor / Window Manager)
- **Waybar** (System Status Surface)
- **Mako** (Notification Daemon)
- **hypridle** (Idle/Session Management)
- **awww-daemon** (Wallpaper Management - native integration)
- **polkit-gnome-authentication-agent-1** (Privilege Authorization)

## Conditional Persistent Services (Event-Driven)
These processes are allowed to persist, but they must consume **negligible/zero CPU at idle**, blocking purely on events.
- **swayosd-server**: Required to render graphical OSDs instantly upon media key presses.
- **cliphist (wl-paste)**: Required for clipboard history (`wl-paste --type text --watch` and `--type image --watch`).
- **minimal-battery-monitor.service**: A lightweight `systemd --user` service that blocks on `upower -m` events to manage low-battery states. (Fails gracefully and exits if `upower` is not installed).

## Strictly On-Demand Only
These tools are explicitly forbidden from running continuously as daemons.
- **Rofi** (Launcher, Clipboard, Menus)
- **yazi** (File Manager)
- **btop** (System Monitor)
- **Security Audit Scripts** (Run manually or via slow cron)
- **Network Management** (Handled via Rofi/nmcli, `nm-applet` is banned)
- **Screenshot Utilities** (`grim`, `slurp`)

## Banned Machinery
The following architectural patterns and tools are explicitly rejected:
- **Conky** (Violates polling restrictions and overlaps Quickshell functionality).
- **Infinite Bash `while` polling loops** (Must use D-Bus/udev events).
- **Heavyweight Frameworks** (AGS, Eww - unless justified by a capability Hyprland/Quickshell absolutely cannot provide).
