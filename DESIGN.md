# Design System: Minimal Hyprland OS

## 1. Visual Theme & Atmosphere
A restrained, gallery-airy interface with confident asymmetric layouts and fluid spring-physics motion. The atmosphere is clinical yet warm — a distraction-free cockpit optimized for operating efficiency. It refuses generic "cyberpunk" or "AI SaaS" tropes in favor of timeless structural clarity, deep spatial consistency, and meticulous typography.

## 2. Color Palette & Roles
*(Note: Sourced directly from `palette.md` rules. Never invent new colors).*
- **Canvas / Base Surface** — Primary background for the entire OS (Kitty bg, Hyprland bg, Waybar base). Deep and neutral.
- **Foreground / Text** — High-contrast primary text, sharply legible.
- **Accent** — Used extremely sparingly for focused/active states only (e.g. active workspace, current battery). No purple/neon glow.
- **Borders** — Minimal translucent structural lines (e.g. 1px solid or faint shadow) separating components without overwhelming them.

## 3. Typography Rules
- **Display / UI:** Track-tight, controlled scale. Hierarchy is driven by weight and opacity (dimming), not just massive size variations.
- **Terminal / Mono:** Used explicitly for high-density readouts (RAM, clock, shell).
- **Banned:** `Inter` and generic system fonts for stylized UI contexts. Emojis must be cleanly rendered or avoided if jarring.

## 4. Component Stylings
* **Waybar (Status Bar):** 28px ultra-slim height. Tactile spacing. No pill-shaped bloated containers. Clear separation of network, battery, and clock.
* **Rofi Menus:** Asymmetric layouts based on context. Clipboard opens right-aligned, Calendar opens top-center under the clock, Launcher centered. Flat surfaces, diffused whisper shadows.
* **Windows:** Sharp layout math (no random gaps). Blur and drop shadow apply exclusively to create Z-axis hierarchy for floating elements.

## 5. Layout Principles
Grid-first window management (Hyprland Dwindle/Master). Elements never overlap chaotically; each panel (Rofi, Waybar, Notifications) has a distinct, non-competing spatial zone. Margins and gaps are symmetrical and mathematically proportional (base-4 or base-8 scaling). 

## 6. Motion & Interaction (Apple-Design & Emil Kowalski Principles)
* **Fluid Animation (Interruptible):** Window openings and layout resizes must use smooth, critically-damped spring-like easing. No linear transitions.
* **Apple Fluid Easing:** Replace standard `expo-out` with a tighter, `0.2, 1.0, 0.2, 1.0` or equivalent cubic-bezier that mimics a fast, non-bouncy physical spring.
* **Feedback:** Direct manipulation. Opening a menu should feel instant. 
* **State Changes:** Hardware-accelerated transforms and opacities only. No frame drops.

## 7. Anti-Patterns (Banned)
- No emojis arbitrarily used as UI icons (unless specifically rendered in a controlled font).
- No pure black (`#000000`).
- No neon glows, drop-shadow blooming, or AI-SaaS gradients.
- No massive padding that creates "Fisher-Price" UI.
- No bouncing animations or infinite loading spinners unless functionally tied to a real process.
