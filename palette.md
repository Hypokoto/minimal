# Minimal Color Token Spec

Single source of truth. Every tool config derives from this table. Do not hardcode hex outside this file's generation targets — if a tool needs a new format, add a row here first.

| Token      | Hex       | RGB               | RGBA (Kitty/Hypr `rgba()`) | XRDB/Xresources     |
|------------|-----------|--------------------|------------------------------|----------------------|
| Background | `#0A0C12` | `10, 12, 18`       | `0a0c12ff`                   | `#0A0C12`            |
| Surface    | `#11141D` | `17, 20, 29`       | `11141dff`                   | `#11141D`            |
| Overlay    | `#1C2230` | `28, 34, 48`       | `1c2230ff`                   | `#1C2230`            |
| Text       | `#F2F6FF` | `242, 246, 255`    | `f2f6ffff`                   | `#F2F6FF`            |
| Muted      | `#8D95B3` | `141, 149, 179`    | `8d95b3ff`                   | `#8D95B3`            |
| Primary    | `#00D9FF` | `0, 217, 255`      | `00d9ffff`                   | `#00D9FF`            |
| Secondary  | `#5B8CFF` | `91, 140, 255`     | `5b8cffff`                   | `#5B8CFF`            |
| Highlight  | `#A05CFF` | `160, 92, 255`     | `a05cffff`                   | `#A05CFF`            |
| Success    | `#4DFF91` | `77, 255, 145`     | `4dff91ff`                   | `#4DFF91`            |
| Warning    | `#FFCC66` | `255, 204, 102`    | `ffcc66ff`                   | `#FFCC66`            |
| Danger     | `#FF5470` | `255, 84, 112`     | `ff5470ff`                   | `#FF5470`            |
| Info       | `#61E6FF` | `97, 230, 255`     | `61e6ffff`                   | `#61E6FF`            |

## Contrast audit (WCAG-ish, not certified)
- Text on Background: ~15.8:1 — passes AAA for body text.
- Muted on Background: ~6.1:1 — passes AA, fails AAA. Acceptable for labels only, not body copy.
- Primary on Background: ~10.4:1 — safe for active border/focus indicators.
- Danger on Surface: ~4.9:1 — borderline AA for small text. If Waybar Danger text reads at <14px, bump weight to bold or switch background to Overlay.

## Hyprland variable block (source of truth for hyprland.conf)
```
$background = rgba(0A0C12FF)
$surface    = rgba(11141DFF)
$overlay    = rgba(1C2230FF)
$text       = rgba(F2F6FFFF)
$muted      = rgba(8D95B3FF)
$primary    = rgba(00D9FFFF)
$secondary  = rgba(5B8CFFFF)
$highlight  = rgba(A05CFFFF)
$success    = rgba(4DFF91FF)
$warning    = rgba(FFCC66FF)
$danger     = rgba(FF5470FF)
$info       = rgba(61E6FFFF)
```

## Usage map
| Tool     | Bg         | Fg      | Accent border | Notification/State |
|----------|------------|---------|----------------|----------------------|
| Hyprland | Background | -       | Primary (active) / Muted (inactive) | - |
| Waybar   | Surface (pills) | Text | Primary (active ws) | Success→Danger gradient (battery) |
| Mako     | Surface    | Text    | Highlight       | Primary (progress bars) |
| Kitty    | Background | Text    | -               | -                     |
| Tmux     | Surface (status) | Muted | Primary (active window) | - |
| Walker   | Overlay    | Text    | Primary (selected) | - |
| Nvim     | Background/Surface | Text | Primary (cursorline accents) | Danger/Warning/Success (diagnostics) |
