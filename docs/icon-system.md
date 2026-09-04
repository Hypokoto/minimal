# Minimal Custom SVG Icon System & Visual Grammar

## 1. Overview
Minimal is an original, theme-aware SVG icon family designed specifically for the Minimal Arch Linux desktop running Hyprland and Quickshell.

## 2. Icon Specification & Geometry
- **Canvas Size:** `24px × 24px`
- **Primary Safe Area:** `20px × 20px` (bounded within `2px` margins)
- **Stroke Width:** `1.75px` (constant thickness across scales)
- **Line Cap:** `round`
- **Line Join:** `round`
- **Theme Color Binding:** `currentColor` for symbolic icons (`actions`, `status`, `devices`, `places`, `emblems`, `mimetypes`).
- **Brand Colors:** Multi-color SVGs reserved explicitly for application brand icons (`apps`).

## 3. Directory Structure
```text
icons/
├── src/
│   ├── actions/
│   ├── apps/
│   ├── devices/
│   ├── emblems/
│   ├── mimetypes/
│   ├── places/
│   └── status/
└── dist/
    └── Minimal/
        ├── index.theme
        └── scalable/
            ├── actions/
            ├── apps/
            ├── devices/
            ├── emblems/
            ├── mimetypes/
            ├── places/
            └── status/
```

## 4. Semantic Role Mapping
Icons dynamically consume semantic theme roles from `minimalctl`:

| Role | Semantic Token | Theme Mapping |
|---|---|---|
| `default` | `text` | Primary foreground text color |
| `active` | `primary` | Active accent color |
| `muted` | `muted` | Secondary muted text |
| `disabled` | `disabled` | Subdued disabled text |
| `success` | `success` | Green operational status |
| `warning` | `warning` | Amber warning status |
| `error` | `danger` | Red error status |
| `info` | `info` | Sky cyan informational status |

## 5. Quickshell Integration (`MinimalIcon.qml`)
Quickshell components consume icons through the reusable `MinimalIcon` component:

```qml
MinimalIcon {
    name: "network-wifi"
    role: "active"
    size: 20
}
```

## 6. System Installation & Toolkit Binding
- **Installation Path:** `~/.local/share/icons/Minimal`
- **GTK Settings:** `gtk-icon-theme-name=Minimal` in `~/.config/gtk-3.0/settings.ini` and `~/.config/gtk-4.0/settings.ini`
- **Qt Settings:** `icon_theme=Minimal` in `~/.config/qt6ct/qt6ct.conf` and `~/.config/qt5ct/qt5ct.conf`
