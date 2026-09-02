# Design System: Minimal Hyprland OS

## 1. Visual Theme & Atmosphere
A restrained, gallery-airy interface with confident asymmetric layouts and fluid spring-physics motion. The atmosphere is clinical yet warm — a distraction-free cockpit optimized for operating efficiency. It refuses generic "cyberpunk" or "AI SaaS" tropes in favor of timeless structural clarity, deep spatial consistency, and meticulous typography.

## 2. Color Palette & Roles
*(Note: Sourced directly from `palette.md` rules. Never invent new colors).*
- **Canvas / Base Surface** — Primary background for the entire OS (Kitty bg, Hyprland bg, Waybar base). Deep and neutral.
- **Foreground / Text** — High-contrast primary text, sharply legible.
- **Accent** — Used extremely sparingly for focused/active states only (e.g. active workspace, current battery). No purple/neon glow.
- **Borders** — Minimal translucent structural lines (e.g. 1px solid or faint shadow) separating components without overwhelming them.

## 3. Typography Architecture & Hierarchy
- **System / UI Contexts:** Proportional humanist font stack (`Adwaita Sans`, `Inter`, `Noto Sans`) for Waybar bar UI, Mako notification cards, and system popups. Weight 500 default; contrast and hierarchy are driven by opacity dimming (`text` `#E8EDF5` vs `muted` `#7F899B`), not arbitrary size spikes.
- **Data Readouts & Terminal:** `AdwaitaMono Nerd Font` reserved explicitly for technical data streams (`#clock`, `#cpu`, `#memory`, `#battery` readouts), shell output, and terminal interfaces.
- **Banned:** Generic un-tuned system fonts. Emojis must be cleanly rendered or avoided if jarring.

## 4. Component Stylings
* **Waybar (Status Bar):** 3-Pill Bento Grid design (28px height, 6px top margin). Clear separation of workspace/window state (Left pill), clock (Center pill), and metrics/security (Right pill). Window title is rendered as quiet muted text (`font-weight: 400`, `color: @muted`).
* **Conditional Gaps:** Gaps and rounded window borders dynamically activate alongside Waybar (`SUPER+B`), allowing seamless toggling between a padded Bento layout (10px gaps, 12px rounding) and a distraction-free, zero-gap focus mode.
* **Rofi Menus:** Asymmetric layouts based on context. Spotlight launcher is centered (720px width, 14px rounding) with a 180px mode-switcher side panel. Clipboard opens right-aligned (`location: east`), calendar top-center under clock.
* **Notifications (Mako):** Translucent bento pills (340px width, 12px rounding, `padding=16,18`, `Adwaita Sans 10` body). Progress bar uses `progress-color=source #7DD3FC`. OSD scripts use fixed notification IDs (`-r 91110` / `-r 91111`) for zero-latency replacement.
* **Terminal (Kitty):** Translucent background (`background_opacity 0.92`, `dynamic_background_opacity yes`) with 12px window padding.
* **File Manager (Yazi):** Strict 1:1 palette token alignment across manager, selection, hovered states, and modal dialogs (`palette.md`).

## 5. Layout Principles
Grid-first window management (Hyprland Dwindle/Master). Elements never overlap chaotically; each panel (Rofi, Waybar, Notifications) has a distinct, non-competing spatial zone. Margins and gaps are symmetrical and mathematically proportional (base-4 or base-8 scaling). 

## 6. Motion & Interaction (Apple-Design Easing & Easing Principles)
* **Fluid Animation (Interruptible):** Window openings and layout resizes use smooth `apple_fluid` cubic-bezier easing (`{ { 0.05, 0.9 }, { 0.1, 1.0 } }`).
* **Slide vs Pop Easing:** Window transitions use `style = "slide"` easing to mimic fluid macOS sheet/window movement rather than destructive scale-up pop-ins.
* **Feedback:** Direct manipulation. Opening a menu feels instant (speed 5-6).
* **State Changes:** Hardware-accelerated transforms and opacities only. No frame drops.

## 7. Anti-Patterns (Banned)
- No emojis arbitrarily used as UI icons (unless specifically rendered in a controlled font).
- No pure black (`#000000`).
- No neon glows, drop-shadow blooming, or AI-SaaS gradients.
- No massive padding that creates "Fisher-Price" UI.
- No bouncing animations or infinite loading spinners unless functionally tied to a real process.

## 8. Translucency & Layering Policy
- **Background Opacity:** 92% (`0.92`) on Kitty and Waybar pills, allowing wallpaper blur (`size = 4, passes = 2, vibrancy = 0.17`) to show subtle ambient depth without compromising text legibility.
- **Rofi / Popups:** Translucent surface overlay (`surface-trans: #11161FF2`) with 1px solid `@overlay` border (`#19212D`).
- **Opaque Content:** File viewports, editor lines, and code text remain at full opacity to avoid visual fatigue during prolonged work sessions.

## 9. Spatial Grid Scale
- **Base Grid:** Base-4 / Base-8 metric system:
  - `4px` — Micro gaps, internal icon margins
  - `8px` — Inner padding, input field borders
  - `10px` / `12px` — Component radii (`12px` cards/windows, `14px` Spotlight launcher), container padding
  - `16px` — Card container padding, modal gaps
  - `20px` — Rofi launcher outer margins

