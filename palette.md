# Minimal Color Token Spec

Single source of truth. Every tool config derives from this table. Do not hardcode hex outside this file's generation targets — if a tool needs a new format, add a row here first.

| Token      | Hex       | RGB               | RGBA (Kitty/Hypr `rgba()`) | XRDB/Xresources     |
|------------|-----------|--------------------|------------------------------|----------------------|
| Background | `#0B0E14` | `11, 14, 20`       | `0b0e14ff`                   | `#0B0E14`            |
| Surface    | `#11161F` | `17, 22, 31`       | `11161fff`                   | `#11161F`            |
| Overlay    | `#19212D` | `25, 33, 45`       | `19212dff`                   | `#19212D`            |
| Text       | `#E8EDF5` | `232, 237, 245`    | `e8edf5ff`                   | `#E8EDF5`            |
| Muted      | `#7F899B` | `127, 137, 155`    | `7f899bff`                   | `#7F899B`            |
| Primary    | `#7DD3FC` | `125, 211, 252`    | `7dd3fcff`                   | `#7DD3FC`            |
| Secondary  | `#8BA4FF` | `139, 164, 255`    | `8ba4ffff`                   | `#8BA4FF`            |
| Highlight  | `#B4A7FF` | `180, 167, 255`    | `b4a7ffff`                   | `#B4A7FF`            |
| Success    | `#8BE28B` | `139, 226, 139`    | `8be28bff`                   | `#8BE28B`            |
| Warning    | `#E8C77B` | `232, 199, 123`    | `e8c77bff`                   | `#E8C77B`            |
| Danger     | `#F08080` | `240, 128, 128`    | `f08080ff`                   | `#F08080`            |
| Info       | `#7DD3FC` | `125, 211, 252`    | `7dd3fcff`                   | `#7DD3FC`            |

## Contrast audit (WCAG-ish, not certified)
- Text on Background: ~14.2:1 — passes AAA for body text.
- Muted on Background: ~5.2:1 — passes AA for labels and secondary text.
- Primary on Background: ~9.8:1 — safe for active border/focus indicators.
- Danger on Surface: ~4.8:1 — passes AA for status indicators.

## Hyprland variable block (source of truth for hyprland.conf)
```
$background = rgba(0B0E14FF)
$surface    = rgba(11161FFF)
$overlay    = rgba(19212DFF)
$text       = rgba(E8EDF5FF)
$muted      = rgba(7F899BFF)
$primary    = rgba(7DD3FCFF)
$secondary  = rgba(8BA4FFFF)
$highlight  = rgba(B4A7FFFF)
$success    = rgba(8BE28BFF)
$warning    = rgba(E8C77BFF)
$danger     = rgba(F08080FF)
$info       = rgba(7DD3FCFF)
```

## Usage map
| Tool     | Bg         | Fg      | Accent border | Notification/State |
|----------|------------|---------|----------------|----------------------|
| Hyprland | Background | -       | Primary (active) / Overlay (inactive) | - |
| Waybar   | Surface (pills) | Text | Primary (active ws) | Discrete state colors (battery) |
| Mako     | Surface    | Text    | Highlight      | Primary (progress bars) |
| Kitty    | Background | Text    | -              | -                     |
| Tmux     | Surface (status) | Muted | Primary (active window) | - |
| Rofi     | Overlay    | Text    | Primary (selected border) | - |
| Nvim     | Background/Surface | Text | Primary (cursorline accents) | Danger/Warning/Success (diagnostics) |
