#!/usr/bin/env python3
"""
generate-minimal-icons.py
Generates the complete Minimal SVG icon family across actions, status, devices, places, mimetypes, emblems, and apps.
All symbolic icons use 24x24 viewBox, currentColor stroke/fill, round caps/joins.
App icons use brand palettes and clean geometric shapes.
"""

import os
import shutil

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC_DIR = os.path.join(REPO_ROOT, "icons", "src")
DIST_DIR = os.path.join(REPO_ROOT, "icons", "dist", "Minimal")
DIST_SCALABLE = os.path.join(DIST_DIR, "scalable")

CATEGORIES = ["actions", "apps", "devices", "emblems", "mimetypes", "places", "status"]

def ensure_dirs():
    for cat in CATEGORIES:
        os.makedirs(os.path.join(SRC_DIR, cat), exist_ok=True)
        os.makedirs(os.path.join(DIST_SCALABLE, cat), exist_ok=True)

def write_svg(category, name, svg_content):
    src_path = os.path.join(SRC_DIR, category, f"{name}.svg")
    dist_path = os.path.join(DIST_SCALABLE, category, f"{name}.svg")
    
    clean_content = svg_content.strip() + "\n"
    
    with open(src_path, "w", encoding="utf-8") as f:
        f.write(clean_content)
    with open(dist_path, "w", encoding="utf-8") as f:
        f.write(clean_content)

# --- SYMBOLIC SVG TEMPLATES (24x24, 20x20 safe area, stroke=1.75, round caps/joins) ---
def wrap_stroke(path_d):
    return f'''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round">
  {path_d}
</svg>'''

def wrap_fill(path_d):
    return f'''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
  {path_d}
</svg>'''

ICONS = {
    "actions": {
        "add": wrap_stroke('<path d="M12 5v14M5 12h14"/>'),
        "plus": wrap_stroke('<path d="M12 5v14M5 12h14"/>'),
        "remove": wrap_stroke('<path d="M5 12h14"/>'),
        "minus": wrap_stroke('<path d="M5 12h14"/>'),
        "close": wrap_stroke('<path d="M18 6L6 18M6 6l12 12"/>'),
        "cancel": wrap_stroke('<circle cx="12" cy="12" r="9"/><path d="M15 9l-6 6M9 9l6 6"/>'),
        "check": wrap_stroke('<path d="M20 6L9 17l-5-5"/>'),
        "search": wrap_stroke('<circle cx="11" cy="11" r="7"/><path d="M21 21l-4.35-4.35"/>'),
        "settings": wrap_stroke('<circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/>'),
        "menu": wrap_stroke('<path d="M3 12h18M3 6h18M3 18h18"/>'),
        "more": wrap_stroke('<circle cx="12" cy="12" r="1.25" fill="currentColor"/><circle cx="5" cy="12" r="1.25" fill="currentColor"/><circle cx="19" cy="12" r="1.25" fill="currentColor"/>'),
        "edit": wrap_stroke('<path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>'),
        "save": wrap_stroke('<path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/>'),
        "save-as": wrap_stroke('<path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><path d="M17 21v-8H7v8"/><path d="M7 3v5h8"/><line x1="12" y1="17" x2="12" y2="13"/>'),
        "open": wrap_stroke('<path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2v1"/><path d="M2 10h20l-2 9H4l-2-9z"/>'),
        "new": wrap_stroke('<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="12" y1="18" x2="12" y2="12"/><line x1="9" y1="15" x2="15" y2="15"/>'),
        "copy": wrap_stroke('<rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/>'),
        "cut": wrap_stroke('<circle cx="6" cy="6" r="3"/><circle cx="6" cy="18" r="3"/><line x1="20" y1="4" x2="8.12" y2="15.88"/><line x1="14.47" y1="14.47" x2="20" y2="20"/><line x1="8.12" y1="8.12" x2="12" y2="12"/>'),
        "paste": wrap_stroke('<path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/><rect x="8" y="2" width="8" height="4" rx="1" ry="1"/>'),
        "duplicate": wrap_stroke('<rect x="8" y="8" width="12" height="12" rx="2"/><rect x="4" y="4" width="12" height="12" rx="2"/>'),
        "delete": wrap_stroke('<polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>'),
        "trash": wrap_stroke('<polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/>'),
        "download": wrap_stroke('<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3"/>'),
        "upload": wrap_stroke('<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M17 8l-5-5-5 5M12 3v12"/>'),
        "refresh": wrap_stroke('<path d="M23 4v6h-6M1 20v-6h6"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/>'),
        "reload": wrap_stroke('<path d="M23 4v6h-6M1 20v-6h6"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/>'),
        "undo": wrap_stroke('<path d="M3 7v6h6"/><path d="M21 17a9 9 0 0 0-9-9 9 9 0 0 0-6 2.3L3 13"/>'),
        "redo": wrap_stroke('<path d="M21 7v6h-6"/><path d="M3 17a9 9 0 0 1 9-9 9 9 0 0 1 6 2.3l3 2.7"/>'),
        "play": wrap_stroke('<polygon points="5 3 19 12 5 21 5 3"/>'),
        "pause": wrap_stroke('<rect x="6" y="4" width="4" height="16"/><rect x="14" y="4" width="4" height="16"/>'),
        "stop": wrap_stroke('<rect x="5" y="5" width="14" height="14" rx="1"/>'),
        "previous": wrap_stroke('<polygon points="19 20 9 12 19 4 19 20"/><line x1="5" y1="19" x2="5" y2="5"/>'),
        "next": wrap_stroke('<polygon points="5 4 15 12 5 20 5 4"/><line x1="19" y1="5" x2="19" y2="19"/>'),
        "back": wrap_stroke('<path d="M19 12H5M12 19l-7-7 7-7"/>'),
        "forward": wrap_stroke('<path d="M5 12h14M12 5l7 7-7 7"/>'),
        "lock": wrap_stroke('<rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>'),
        "unlock": wrap_stroke('<rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 9.9-1"/>'),
        "power": wrap_stroke('<path d="M18.36 6.64a9 9 0 1 1-12.73 0M12 2v10"/>'),
        "maximize": wrap_stroke('<rect x="3" y="3" width="18" height="18" rx="2"/>'),
        "minimize": wrap_stroke('<line x1="5" y1="12" x2="19" y2="12"/>'),
        "restore": wrap_stroke('<rect x="8" y="8" width="13" height="13" rx="2"/><path d="M5 16V5a2 2 0 0 1 2-2h11"/>'),
        "fullscreen": wrap_stroke('<path d="M8 3H5a2 2 0 0 0-2 2v3m18 0V5a2 2 0 0 0-2-2h-3m0 18h3a2 2 0 0 0 2-2v-3M3 16v3a2 2 0 0 0 2 2h3"/>'),
        "fullscreen-exit": wrap_stroke('<path d="M4 14h6v6M20 10h-6V4M14 20v-6h6M10 4v6H4"/>'),
        "window-close": wrap_stroke('<path d="M18 6L6 18M6 6l12 12"/>'),
        "window-new": wrap_stroke('<rect x="3" y="3" width="18" height="18" rx="2"/><path d="M12 8v8M8 12h8"/>'),
        "arrow-up": wrap_stroke('<path d="M12 19V5M5 12l7-7 7 7"/>'),
        "arrow-down": wrap_stroke('<path d="M12 5v14M19 12l-7 7-7-7"/>'),
        "arrow-left": wrap_stroke('<path d="M19 12H5M12 19l-7-7 7-7"/>'),
        "arrow-right": wrap_stroke('<path d="M5 12h14M12 5l7 7-7 7"/>'),
        "chevron-up": wrap_stroke('<polyline points="18 15 12 9 6 15"/>'),
        "chevron-down": wrap_stroke('<polyline points="6 9 12 15 18 9"/>'),
        "chevron-left": wrap_stroke('<polyline points="15 18 9 12 15 6"/>'),
        "chevron-right": wrap_stroke('<polyline points="9 18 15 12 9 6"/>'),
        "go-home": wrap_stroke('<path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/>'),
        "go-up": wrap_stroke('<path d="M12 19V5M5 12l7-7 7 7"/>'),
        "go-down": wrap_stroke('<path d="M12 5v14M19 12l-7 7-7-7"/>'),
        "share": wrap_stroke('<circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/>'),
        "link": wrap_stroke('<path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/>'),
        "unlink": wrap_stroke('<path d="M18.36 5.64a5 5 0 0 1 0 7.07l-1.72 1.71"/><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/><line x1="2" y1="2" x2="22" y2="22"/>'),
        "view": wrap_stroke('<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>'),
        "view-hidden": wrap_stroke('<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/>'),
        "filter": wrap_stroke('<polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"/>'),
        "sort": wrap_stroke('<path d="M11 5h10M11 9h7M11 13h4M3 17l4 4 4-4M7 3v18"/>'),
        "sync": wrap_stroke('<path d="M21.5 2v6h-6M2.5 22v-6h6"/><path d="M2 11.5a10 10 0 0 1 18.8-4.3L21.5 8M22 12.5a10 10 0 0 1-18.8 4.2L2.5 16"/>'),
        "sync-active": wrap_stroke('<path d="M21.5 2v6h-6M2.5 22v-6h6"/><path d="M2 11.5a10 10 0 0 1 18.8-4.3L21.5 8M22 12.5a10 10 0 0 1-18.8 4.2L2.5 16"/>'),
        "sync-error": wrap_stroke('<path d="M21.5 2v6h-6M2.5 22v-6h6"/><path d="M2 11.5a10 10 0 0 1 18.8-4.3L21.5 8M22 12.5a10 10 0 0 1-18.8 4.2L2.5 16"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>'),
        "update": wrap_stroke('<path d="M21.5 2v6h-6M2.5 22v-6h6"/><path d="M2 11.5a10 10 0 0 1 18.8-4.3L21.5 8M22 12.5a10 10 0 0 1-18.8 4.2L2.5 16"/>'),
        "update-available": wrap_stroke('<circle cx="12" cy="12" r="9"/><path d="M12 8v4l3 3"/>'),
        "system-search": wrap_stroke('<circle cx="11" cy="11" r="7"/><path d="M21 21l-4.35-4.35"/>'),
        "edit-clear": wrap_stroke('<path d="M18 6L6 18M6 6l12 12"/>'),
    },
    "status": {
        "battery": wrap_stroke('<rect x="1" y="6" width="18" height="12" rx="2"/><line x1="23" y1="10" x2="23" y2="14"/>'),
        "battery-full": wrap_stroke('<rect x="1" y="6" width="18" height="12" rx="2"/><line x1="23" y1="10" x2="23" y2="14"/><rect x="3" y="8" width="14" height="8" rx="1" fill="currentColor"/>'),
        "battery-good": wrap_stroke('<rect x="1" y="6" width="18" height="12" rx="2"/><line x1="23" y1="10" x2="23" y2="14"/><rect x="3" y="8" width="10" height="8" rx="1" fill="currentColor"/>'),
        "battery-medium": wrap_stroke('<rect x="1" y="6" width="18" height="12" rx="2"/><line x1="23" y1="10" x2="23" y2="14"/><rect x="3" y="8" width="7" height="8" rx="1" fill="currentColor"/>'),
        "battery-low": wrap_stroke('<rect x="1" y="6" width="18" height="12" rx="2"/><line x1="23" y1="10" x2="23" y2="14"/><rect x="3" y="8" width="4" height="8" rx="1" fill="currentColor"/>'),
        "battery-empty": wrap_stroke('<rect x="1" y="6" width="18" height="12" rx="2"/><line x1="23" y1="10" x2="23" y2="14"/>'),
        "battery-charging": wrap_stroke('<rect x="1" y="6" width="18" height="12" rx="2"/><line x1="23" y1="10" x2="23" y2="14"/><path d="M11 9l-3 4h4l-2 4"/>'),
        "battery-unknown": wrap_stroke('<rect x="1" y="6" width="18" height="12" rx="2"/><line x1="23" y1="10" x2="23" y2="14"/><path d="M10 9a2 2 0 0 1 4 0c0 2-3 3-3 3"/><line x1="11" y1="15" x2="11.01" y2="15"/>'),
        "network": wrap_stroke('<path d="M5 12.55a11 11 0 0 1 14.08 0M1.42 9a16 16 0 0 1 21.16 0M8.53 16.11a6 6 0 0 1 6.95 0M12 20h.01"/>'),
        "network-wifi": wrap_stroke('<path d="M5 12.55a11 11 0 0 1 14.08 0M1.42 9a16 16 0 0 1 21.16 0M8.53 16.11a6 6 0 0 1 6.95 0M12 20h.01"/>'),
        "network-wifi-full": wrap_stroke('<path d="M5 12.55a11 11 0 0 1 14.08 0M1.42 9a16 16 0 0 1 21.16 0M8.53 16.11a6 6 0 0 1 6.95 0M12 20h.01"/>'),
        "network-wifi-medium": wrap_stroke('<path d="M5 12.55a11 11 0 0 1 14.08 0M8.53 16.11a6 6 0 0 1 6.95 0M12 20h.01"/>'),
        "network-wifi-low": wrap_stroke('<path d="M8.53 16.11a6 6 0 0 1 6.95 0M12 20h.01"/>'),
        "network-wifi-none": wrap_stroke('<circle cx="12" cy="20" r="1" fill="currentColor"/>'),
        "network-wired": wrap_stroke('<rect x="2" y="2" width="20" height="8" rx="2"/><path d="M6 10v4M18 10v4M12 10v10M2 20h20"/>'),
        "ethernet": wrap_stroke('<rect x="2" y="2" width="20" height="8" rx="2"/><path d="M6 10v4M18 10v4M12 10v10M2 20h20"/>'),
        "network-disconnected": wrap_stroke('<path d="M1 1l22 22M16.72 11.06A10.94 10.94 0 0 1 19 12.55M5 12.55a10.94 10.94 0 0 1 5.17-2.39"/>'),
        "router": wrap_stroke('<rect x="2" y="14" width="20" height="7" rx="2"/><line x1="6" y1="14" x2="6" y2="7"/><line x1="18" y1="14" x2="18" y2="7"/><circle cx="6" cy="18" r="1" fill="currentColor"/><circle cx="10" cy="18" r="1" fill="currentColor"/>'),
        "server": wrap_stroke('<rect x="2" y="2" width="20" height="8" rx="2"/><rect x="2" y="14" width="20" height="8" rx="2"/><line x1="6" y1="6" x2="6.01" y2="6"/><line x1="6" y1="18" x2="6.01" y2="18"/>'),
        "vpn": wrap_stroke('<rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/><circle cx="12" cy="16" r="1" fill="currentColor"/>'),
        "vpn-connected": wrap_stroke('<rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/><polyline points="9 16 11 18 15 14"/>'),
        "vpn-disconnected": wrap_stroke('<rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 9.9-1"/><line x1="1" y1="1" x2="23" y2="23"/>'),
        "bluetooth": wrap_stroke('<polyline points="6.5 6.5 17.5 17.5 12 23 12 1 17.5 6.5 6.5 17.5"/>'),
        "bluetooth-connected": wrap_stroke('<polyline points="6.5 6.5 17.5 17.5 12 23 12 1 17.5 6.5 6.5 17.5"/><line x1="18" y1="12" x2="21" y2="12"/><line x1="3" y1="12" x2="6" y2="12"/>'),
        "bluetooth-disabled": wrap_stroke('<polyline points="6.5 6.5 17.5 17.5 12 23 12 1 17.5 6.5 6.5 17.5"/><line x1="1" y1="1" x2="23" y2="23"/>'),
        "bluetooth-searching": wrap_stroke('<polyline points="6.5 6.5 17.5 17.5 12 23 12 1 17.5 6.5 6.5 17.5"/><circle cx="20" cy="12" r="2"/>'),
        "airplane-mode": wrap_stroke('<path d="M17.8 19.2L16 11l3.5-3.5a2.12 2.12 0 0 0-3-3L13 8 4.8 6.2a1 1 0 0 0-1.2 1.2L6 12l-3.5 3.5a1 1 0 0 0 .7 1.7H8l3 3v3.3a.7.7 0 0 0 1.2.5l2.6-2.6 3 3a1 1 0 0 0 1.4-1.4z"/>'),
        "hotspot": wrap_stroke('<path d="M5 12.55a11 11 0 0 1 14.08 0M8.53 16.11a6 6 0 0 1 6.95 0M12 20h.01"/><circle cx="12" cy="20" r="3"/>'),
        "audio": wrap_stroke('<polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"/><path d="M15.54 8.46a5 5 0 0 1 0 7.07"/>'),
        "volume": wrap_stroke('<polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"/><path d="M15.54 8.46a5 5 0 0 1 0 7.07M19.07 4.93a10 10 0 0 1 0 14.14"/>'),
        "volume-high": wrap_stroke('<polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"/><path d="M15.54 8.46a5 5 0 0 1 0 7.07M19.07 4.93a10 10 0 0 1 0 14.14"/>'),
        "volume-medium": wrap_stroke('<polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"/><path d="M15.54 8.46a5 5 0 0 1 0 7.07"/>'),
        "volume-low": wrap_stroke('<polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"/>'),
        "volume-muted": wrap_stroke('<polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"/><line x1="23" y1="9" x2="17" y2="15"/><line x1="17" y1="9" x2="23" y2="15"/>'),
        "microphone-muted": wrap_stroke('<path d="M12 1a3 3 0 0 0-3 3v8a3 3 0 0 0 6 0V4a3 3 0 0 0-3-3z"/><path d="M19 10v2a7 7 0 0 1-14 0v-2M12 19v4M8 23h8"/><line x1="1" y1="1" x2="23" y2="23"/>'),
        "speaker": wrap_stroke('<rect x="4" y="2" width="16" height="20" rx="2"/><circle cx="12" cy="14" r="4"/><circle cx="12" cy="6" r="1.5"/>'),
        "speaker-muted": wrap_stroke('<rect x="4" y="2" width="16" height="20" rx="2"/><circle cx="12" cy="14" r="4"/><line x1="1" y1="1" x2="23" y2="23"/>'),
        "rewind": wrap_stroke('<polygon points="11 19 2 12 11 5 11 19"/><polygon points="22 19 13 12 22 5 22 19"/>'),
        "fast-forward": wrap_stroke('<polygon points="13 19 22 12 13 5 13 19"/><polygon points="2 19 11 12 2 5 2 19"/>'),
        "record": wrap_stroke('<circle cx="12" cy="12" r="8" fill="currentColor"/>'),
        "eject": wrap_stroke('<polygon points="12 5 5 15 19 15 12 5"/><line x1="5" y1="19" x2="19" y2="19"/>'),
        "brightness": wrap_stroke('<circle cx="12" cy="12" r="5"/><path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"/>'),
        "brightness-high": wrap_stroke('<circle cx="12" cy="12" r="5"/><path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"/>'),
        "brightness-medium": wrap_stroke('<circle cx="12" cy="12" r="5"/><path d="M12 1v2M12 21v2M1 12h2M21 12h2"/>'),
        "brightness-low": wrap_stroke('<circle cx="12" cy="12" r="5"/>'),
        "night-light": wrap_stroke('<path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/>'),
        "dark-mode": wrap_stroke('<path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/>'),
        "light-mode": wrap_stroke('<circle cx="12" cy="12" r="5"/><path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2"/>'),
        "screen-lock": wrap_stroke('<rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/><circle cx="12" cy="16" r="1" fill="currentColor"/>'),
        "screen-unlock": wrap_stroke('<rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 9.9-1"/>'),
        "shutdown": wrap_stroke('<path d="M18.36 6.64a9 9 0 1 1-12.73 0M12 2v10"/>'),
        "restart": wrap_stroke('<path d="M23 4v6h-6M1 20v-6h6"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/>'),
        "logout": wrap_stroke('<path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M21 12H9"/>'),
        "log-out": wrap_stroke('<path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M21 12H9"/>'),
        "sleep": wrap_stroke('<path d="M2 4h6l-6 7h6M14 11h6l-6 7h6"/>'),
        "suspend": wrap_stroke('<path d="M2 4h6l-6 7h6M14 11h6l-6 7h6"/>'),
        "hibernate": wrap_stroke('<path d="M12 2v20M2 12h20M4.93 4.93l14.14 14.14M4.93 19.07l14.14-14.14"/>'),
        "user-session": wrap_stroke('<path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>'),
        "switch-user": wrap_stroke('<path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>'),
        "security": wrap_stroke('<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>'),
        "shield": wrap_stroke('<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>'),
        "shield-check": wrap_stroke('<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><polyline points="9 12 11 14 15 10"/>'),
        "shield-warning": wrap_stroke('<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>'),
        "shield-error": wrap_stroke('<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/>'),
        "password": wrap_stroke('<rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/><line x1="8" y1="16" x2="8.01" y2="16"/><line x1="12" y1="16" x2="12.01" y2="16"/><line x1="16" y1="16" x2="16.01" y2="16"/>'),
        "fingerprint": wrap_stroke('<path d="M2 12C2 6.5 6.5 2 12 2s10 4.5 10 10c0 4.2-2.6 7.8-6.3 9.3"/><path d="M6 12a6 6 0 0 1 12 0c0 2.8-1.5 5.2-3.8 6.3"/><path d="M10 12a2 2 0 0 1 4 0c0 1.2-.6 2.3-1.6 2.8"/>'),
        "authentication": wrap_stroke('<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><circle cx="12" cy="11" r="2"/>'),
        "secure": wrap_stroke('<rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>'),
        "encrypted": wrap_stroke('<rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>'),
        "preferences-system": wrap_stroke('<circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/>'),
        "system": wrap_stroke('<circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/>'),
        "sound": wrap_stroke('<polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"/><path d="M15.54 8.46a5 5 0 0 1 0 7.07M19.07 4.93a10 10 0 0 1 0 14.14"/>'),
        "appearance": wrap_stroke('<circle cx="13.5" cy="6.5" r="2.5"/><circle cx="17.5" cy="10.5" r="2.5"/><circle cx="8.5" cy="7.5" r="2.5"/><circle cx="6.5" cy="12.5" r="2.5"/><path d="M12 2C6.5 2 2 6.5 2 12s4.5 10 10 10c.92 0 1.7-.71 1.7-1.63 0-.44-.18-.85-.46-1.16-.27-.3-.44-.71-.44-1.21 0-.92.78-1.7 1.7-1.7h2c3.03 0 5.5-2.47 5.5-5.5 0-4.97-4.48-8.8-9.5-8.8z"/>'),
        "notifications": wrap_stroke('<path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9M13.73 21a2 2 0 0 1-3.46 0"/>'),
        "privacy": wrap_stroke('<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>'),
        "users": wrap_stroke('<path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>'),
        "accounts": wrap_stroke('<path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>'),
        "applications": wrap_stroke('<rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/>'),
        "storage": wrap_stroke('<rect x="2" y="6" width="20" height="12" rx="2"/><line x1="6" y1="12" x2="6.01" y2="12"/><line x1="18" y1="12" x2="18.01" y2="12"/>'),
        "date-time": wrap_stroke('<circle cx="12" cy="12" r="9"/><polyline points="12 6 12 12 16 14"/>'),
        "language": wrap_stroke('<circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>'),
        "accessibility": wrap_stroke('<circle cx="12" cy="4" r="2"/><path d="M12 7v7m0-7L8 10m4-3l4 3m-4 4l-3 7m3-7l3 7"/>'),
        "updates": wrap_stroke('<path d="M21.5 2v6h-6M2.5 22v-6h6"/><path d="M2 11.5a10 10 0 0 1 18.8-4.3L21.5 8M22 12.5a10 10 0 0 1-18.8 4.2L2.5 16"/>'),
        "user": wrap_stroke('<path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>'),
        "user-home": wrap_stroke('<path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/>'),
        "user-admin": wrap_stroke('<path d="M12 2L3 7v6c0 5.5 3.8 10.7 9 12 5.2-1.3 9-6.5 9-12V7l-9-5z"/><circle cx="12" cy="10" r="3"/>'),
        "user-group": wrap_stroke('<path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>'),
        "user-add": wrap_stroke('<path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><line x1="20" y1="8" x2="20" y2="14"/><line x1="17" y1="11" x2="23" y2="11"/>'),
        "user-remove": wrap_stroke('<path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><line x1="17" y1="11" x2="23" y2="11"/>'),
        "account": wrap_stroke('<path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>'),
        "avatar": wrap_stroke('<path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>'),
        "guest": wrap_stroke('<circle cx="12" cy="12" r="9"/><circle cx="12" cy="10" r="3"/><path d="M6.16 17a6 6 0 0 1 11.68 0"/>'),
        "administrator": wrap_stroke('<path d="M12 2L3 7v6c0 5.5 3.8 10.7 9 12 5.2-1.3 9-6.5 9-12V7l-9-5z"/>'),
        "calendar": wrap_stroke('<rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>'),
        "calendar-day": wrap_stroke('<rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/><rect x="8" y="13" width="3" height="3" fill="currentColor"/>'),
        "calendar-month": wrap_stroke('<rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/><line x1="8" y1="14" x2="8.01" y2="14"/><line x1="12" y1="14" x2="12.01" y2="14"/><line x1="16" y1="14" x2="16.01" y2="14"/>'),
        "clock": wrap_stroke('<circle cx="12" cy="12" r="9"/><polyline points="12 6 12 12 16 14"/>'),
        "alarm": wrap_stroke('<circle cx="12" cy="13" r="8"/><polyline points="12 9 12 13 15 15"/><path d="M5 3L2 6M22 6l-3-3"/>'),
        "timer": wrap_stroke('<line x1="10" y1="2" x2="14" y2="2"/><line x1="12" y1="2" x2="12" y2="5"/><circle cx="12" cy="14" r="8"/><polyline points="12 10 12 14 15 14"/>'),
        "history": wrap_stroke('<path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"/><polyline points="3 3 3 8 8 8"/><polyline points="12 7 12 12 15 15"/>'),
        "notification": wrap_stroke('<path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9M13.73 21a2 2 0 0 1-3.46 0"/>'),
        "notification-new": wrap_stroke('<path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9M13.73 21a2 2 0 0 1-3.46 0"/><circle cx="18" cy="4" r="3" fill="currentColor"/>'),
        "notification-important": wrap_stroke('<path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9M13.73 21a2 2 0 0 1-3.46 0"/><line x1="12" y1="8" x2="12" y2="11"/><line x1="12" y1="14" x2="12.01" y2="14"/>'),
        "notification-muted": wrap_stroke('<path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9M13.73 21a2 2 0 0 1-3.46 0M1 1l22 22"/>'),
        "error": wrap_stroke('<circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/>'),
        "warning": wrap_stroke('<path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>'),
        "success": wrap_stroke('<path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/>'),
        "info": wrap_stroke('<circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/>'),
        "help": wrap_stroke('<circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><line x1="12" y1="17" x2="12.01" y2="17"/>'),
        "question": wrap_stroke('<circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><line x1="12" y1="17" x2="12.01" y2="17"/>'),
        "dialog-error": wrap_stroke('<circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/>'),
        "dialog-warning": wrap_stroke('<path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>'),
        "dialog-information": wrap_stroke('<circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/>'),
    },
    "devices": {
        "computer": wrap_stroke('<rect x="2" y="3" width="20" height="14" rx="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/>'),
        "laptop": wrap_stroke('<rect x="4" y="4" width="16" height="12" rx="1"/><path d="M2 20h20"/>'),
        "tablet": wrap_stroke('<rect x="4" y="2" width="16" height="20" rx="2"/><line x1="12" y1="18" x2="12.01" y2="18"/>'),
        "phone": wrap_stroke('<rect x="5" y="2" width="14" height="20" rx="2"/><line x1="12" y1="18" x2="12.01" y2="18"/>'),
        "keyboard": wrap_stroke('<rect x="2" y="4" width="20" height="16" rx="2"/><line x1="6" y1="8" x2="6" y2="8"/><line x1="10" y1="8" x2="10" y2="8"/><line x1="14" y1="8" x2="14" y2="8"/><line x1="18" y1="8" x2="18" y2="8"/><line x1="6" y1="12" x2="6" y2="12"/><line x1="10" y1="12" x2="10" y2="12"/><line x1="14" y1="12" x2="14" y2="12"/><line x1="18" y1="12" x2="18" y2="12"/><line x1="8" y1="16" x2="16" y2="16"/>'),
        "mouse": wrap_stroke('<rect x="6" y="3" width="12" height="18" rx="6"/><line x1="12" y1="7" x2="12" y2="11"/>'),
        "touchpad": wrap_stroke('<rect x="3" y="4" width="18" height="16" rx="2"/><line x1="12" y1="15" x2="12" y2="20"/><line x1="3" y1="15" x2="21" y2="15"/>'),
        "display": wrap_stroke('<rect x="2" y="3" width="20" height="14" rx="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/>'),
        "monitor": wrap_stroke('<rect x="2" y="3" width="20" height="14" rx="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/>'),
        "camera": wrap_stroke('<path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/>'),
        "microphone": wrap_stroke('<path d="M12 1a3 3 0 0 0-3 3v8a3 3 0 0 0 6 0V4a3 3 0 0 0-3-3z"/><path d="M19 10v2a7 7 0 0 1-14 0v-2M12 19v4M8 23h8"/>'),
        "headphones": wrap_stroke('<path d="M3 18v-6a9 9 0 0 1 18 0v6"/><path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3zM3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z"/>'),
        "speaker": wrap_stroke('<rect x="4" y="2" width="16" height="20" rx="2"/><circle cx="12" cy="14" r="4"/><circle cx="12" cy="6" r="1.5"/>'),
        "printer": wrap_stroke('<polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/>'),
        "scanner": wrap_stroke('<rect x="2" y="14" width="20" height="7" rx="2"/><line x1="4" y1="8" x2="20" y2="4"/><line x1="2" y1="14" x2="22" y2="14"/>'),
        "usb": wrap_stroke('<circle cx="12" cy="5" r="2"/><path d="M12 7v10M12 17l-3-3M12 17l3-3"/><rect x="8" y="19" width="8" height="4"/>'),
        "usb-drive": wrap_stroke('<rect x="6" y="8" width="12" height="13" rx="2"/><rect x="8" y="3" width="8" height="5"/>'),
        "hard-drive": wrap_stroke('<rect x="2" y="6" width="20" height="12" rx="2"/><line x1="6" y1="12" x2="6.01" y2="12"/><line x1="18" y1="12" x2="18.01" y2="12"/>'),
        "ssd": wrap_stroke('<rect x="3" y="5" width="18" height="14" rx="2"/><line x1="7" y1="9" x2="17" y2="9"/><line x1="7" y1="13" x2="11" y2="13"/>'),
        "disk": wrap_stroke('<circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="3"/>'),
        "optical-disc": wrap_stroke('<circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="3"/>'),
        "drive-harddisk": wrap_stroke('<rect x="2" y="6" width="20" height="12" rx="2"/><line x1="6" y1="12" x2="6.01" y2="12"/><line x1="18" y1="12" x2="18.01" y2="12"/>'),
        "power-supply": wrap_stroke('<rect x="4" y="4" width="16" height="16" rx="2"/><line x1="9" y1="1" x2="9" y2="4"/><line x1="15" y1="1" x2="15" y2="4"/>'),
    },
    "places": {
        "home": wrap_stroke('<path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/>'),
        "desktop": wrap_stroke('<rect x="2" y="3" width="20" height="14" rx="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/>'),
        "downloads": wrap_stroke('<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3"/>'),
        "documents": wrap_stroke('<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/>'),
        "pictures": wrap_stroke('<rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/>'),
        "music": wrap_stroke('<path d="M9 18V5l12-2v13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/>'),
        "videos": wrap_stroke('<rect x="2" y="4" width="20" height="16" rx="2"/><path d="M10 9l5 3-5 3V9z"/>'),
        "templates": wrap_stroke('<rect x="3" y="3" width="18" height="18" rx="2"/><line x1="3" y1="9" x2="21" y2="9"/><line x1="9" y1="21" x2="9" y2="9"/>'),
        "public": wrap_stroke('<circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>'),
        "trash": wrap_stroke('<polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/>'),
        "user-trash": wrap_stroke('<polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/>'),
        "trash-empty": wrap_stroke('<polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>'),
        "trash-full": wrap_stroke('<polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/>'),
        "folder": wrap_stroke('<path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"/>'),
        "folder-open": wrap_stroke('<path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2v1"/><path d="M2 10h20l-2 9H4l-2-9z"/>'),
        "folder-new": wrap_stroke('<path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"/><line x1="12" y1="10" x2="12" y2="16"/><line x1="9" y1="13" x2="15" y2="13"/>'),
        "folder-locked": wrap_stroke('<path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"/><rect x="9" y="11" width="6" height="5" rx="1"/><path d="M10 11V9a2 2 0 0 1 4 0v2"/>'),
        "folder-shared": wrap_stroke('<path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="2"/>'),
        "drive": wrap_stroke('<rect x="2" y="6" width="20" height="12" rx="2"/><line x1="6" y1="12" x2="6.01" y2="12"/><line x1="18" y1="12" x2="18.01" y2="12"/>'),
        "drive-harddisk": wrap_stroke('<rect x="2" y="6" width="20" height="12" rx="2"/><line x1="6" y1="12" x2="6.01" y2="12"/><line x1="18" y1="12" x2="18.01" y2="12"/>'),
        "drive-removable-media": wrap_stroke('<rect x="6" y="8" width="12" height="13" rx="2"/><rect x="8" y="3" width="8" height="5"/>'),
        "drive-optical": wrap_stroke('<circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="3"/>'),
        "network-drive": wrap_stroke('<rect x="2" y="3" width="20" height="10" rx="2"/><path d="M6 13v3M18 13v3M12 13v8M2 21h20"/>'),
    },
    "emblems": {
        "emblem-default": wrap_stroke('<circle cx="12" cy="12" r="8"/>'),
        "emblem-important": wrap_stroke('<path d="M12 2L2 22h20L12 2zm0 14h.01M12 10v4"/>'),
    },
    "mimetypes": {
        "text-x-generic": wrap_stroke('<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/>'),
        "application-x-executable": wrap_stroke('<polygon points="12 2 2 7 12 12 22 7 12 2"/><polyline points="2 17 12 22 22 17"/><polyline points="2 12 12 17 22 12"/>'),
        "text": wrap_stroke('<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/>'),
        "document": wrap_stroke('<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/>'),
        "pdf": wrap_stroke('<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><path d="M9 13h2a1.5 1.5 0 0 0 0-3H9v5"/>'),
        "image": wrap_stroke('<rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/>'),
        "audio": wrap_stroke('<path d="M9 18V5l12-2v13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/>'),
        "video": wrap_stroke('<rect x="2" y="4" width="20" height="16" rx="2"/><path d="M10 9l5 3-5 3V9z"/>'),
        "archive": wrap_stroke('<polyline points="21 8 21 21 3 21 3 8"/><rect x="1" y="3" width="22" height="5"/><line x1="10" y1="12" x2="14" y2="12"/>'),
        "compressed": wrap_stroke('<polyline points="21 8 21 21 3 21 3 8"/><rect x="1" y="3" width="22" height="5"/><line x1="10" y1="12" x2="14" y2="12"/>'),
        "package": wrap_stroke('<path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/>'),
        "binary": wrap_stroke('<polygon points="12 2 2 7 12 12 22 7 12 2"/><polyline points="2 17 12 22 22 17"/><polyline points="2 12 12 17 22 12"/>'),
        "executable": wrap_stroke('<polygon points="12 2 2 7 12 12 22 7 12 2"/><polyline points="2 17 12 22 22 17"/><polyline points="2 12 12 17 22 12"/>'),
        "script": wrap_stroke('<polyline points="4 17 10 11 4 5"/><line x1="12" y1="19" x2="20" y2="19"/>'),
        "source-code": wrap_stroke('<polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/>'),
        "configuration": wrap_stroke('<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><circle cx="12" cy="14" r="2"/>'),
        "database": wrap_stroke('<ellipse cx="12" cy="5" rx="9" ry="3"/><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"/><path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/>'),
        "spreadsheet": wrap_stroke('<rect x="3" y="3" width="18" height="18" rx="2"/><line x1="3" y1="9" x2="21" y2="9"/><line x1="3" y1="15" x2="21" y2="15"/><line x1="9" y1="3" x2="9" y2="21"/><line x1="15" y1="3" x2="15" y2="21"/>'),
        "presentation": wrap_stroke('<rect x="2" y="3" width="20" height="14" rx="2"/><line x1="12" y1="17" x2="12" y2="21"/><path d="M8 21h8"/>'),
        "font": wrap_stroke('<path d="M4 20h16M6 16l6-12 6 12M8 12h8"/>'),
        "certificate": wrap_stroke('<rect x="3" y="3" width="18" height="14" rx="2"/><circle cx="12" cy="17" r="3"/><path d="M10 19.5L8 22l2-1 2 1"/>'),
        "key": wrap_stroke('<circle cx="7.5" cy="15.5" r="5.5"/><path d="M11.38 11.62L21.5 1.5"/><path d="M17.5 5.5l3 3"/>'),
        "file": wrap_stroke('<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/>'),
        "file-new": wrap_stroke('<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="12" y1="18" x2="12" y2="12"/><line x1="9" y1="15" x2="15" y2="15"/>'),
        "file-locked": wrap_stroke('<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><rect x="9" y="13" width="6" height="5" rx="1"/><path d="M10 13v-2a2 2 0 0 1 4 0v2"/>'),
        "file-encrypted": wrap_stroke('<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><rect x="9" y="13" width="6" height="5" rx="1"/><path d="M10 13v-2a2 2 0 0 1 4 0v2"/>'),
        "file-missing": wrap_stroke('<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="15" y1="11" x2="9" y2="17"/><line x1="9" y1="11" x2="15" y2="17"/>'),
    },
    "apps": {
        "kitty": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect x="2" y="3" width="20" height="18" rx="4" fill="#1E293B"/>
  <path d="M7 8l5 4-5 4" stroke="#7DD3FC" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
  <line x1="13" y1="16" x2="17" y2="16" stroke="#7DD3FC" stroke-width="2" stroke-linecap="round"/>
</svg>''',
        "utilities-terminal": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect x="2" y="3" width="20" height="18" rx="4" fill="#0F172A"/>
  <path d="M7 8l5 4-5 4" stroke="#38BDF8" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
  <line x1="13" y1="16" x2="17" y2="16" stroke="#38BDF8" stroke-width="2" stroke-linecap="round"/>
</svg>''',
        "quickshell": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect x="2" y="3" width="20" height="18" rx="4" fill="#11161F"/>
  <circle cx="12" cy="12" r="6" stroke="#7DD3FC" stroke-width="2" fill="none"/>
  <path d="M12 6v12M6 12h12" stroke="#8BA4FF" stroke-width="1.5" stroke-linecap="round"/>
</svg>''',
        "yazi": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z" fill="#0F172A" stroke="#7DD3FC" stroke-width="1.5"/>
  <path d="M8 13l3 3 5-6" stroke="#8BE28B" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
</svg>''',
        "btop": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect x="2" y="3" width="20" height="18" rx="3" fill="#0B0E14"/>
  <path d="M4 16l4-6 4 4 4-8 4 6" stroke="#7DD3FC" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
</svg>''',
        "system-monitor": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect x="2" y="3" width="20" height="18" rx="3" fill="#0B0E14"/>
  <path d="M4 16l4-6 4 4 4-8 4 6" stroke="#38BDF8" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
</svg>''',
        "nvim": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <path d="M4 4l7 16V8l9 12V4" stroke="#8BE28B" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
</svg>''',
        "firefox": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <circle cx="12" cy="12" r="9" fill="#0F172A" stroke="#E8C77B" stroke-width="1.5"/>
  <path d="M12 3a9 9 0 0 1 9 9c0 4.97-4.03 9-9 9a9 9 0 0 1-9-9" stroke="#F08080" stroke-width="2" fill="none"/>
</svg>''',
        "code": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <path d="M16.5 3.5L7 11.5l-4-3L1.5 10l5.5 5-5.5 5 1.5 1.5 4-3 9.5 8 5-2.5V6l-5-2.5z" fill="#0284C7"/>
</svg>''',
        "calculator": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect x="4" y="2" width="16" height="20" rx="3" fill="#1E293B" stroke="#7DD3FC" stroke-width="1.5"/>
  <rect x="7" y="5" width="10" height="4" rx="1" fill="#0F172A"/>
  <circle cx="8" cy="12" r="1" fill="#7DD3FC"/><circle cx="12" cy="12" r="1" fill="#7DD3FC"/><circle cx="16" cy="12" r="1" fill="#8BA4FF"/>
  <circle cx="8" cy="16" r="1" fill="#7DD3FC"/><circle cx="12" cy="16" r="1" fill="#7DD3FC"/><circle cx="16" cy="16" r="1" fill="#8BE28B"/>
</svg>''',
        "calendar-app": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect x="3" y="4" width="18" height="17" rx="3" fill="#0F172A" stroke="#7DD3FC" stroke-width="1.5"/>
  <path d="M3 8h18" stroke="#38BDF8" stroke-width="1.5"/>
  <circle cx="8" cy="13" r="1.5" fill="#8BE28B"/><circle cx="12" cy="13" r="1.5" fill="#7DD3FC"/><circle cx="16" cy="13" r="1.5" fill="#7DD3FC"/>
</svg>''',
        "text-editor": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect x="4" y="3" width="16" height="18" rx="2" fill="#1E293B" stroke="#38BDF8" stroke-width="1.5"/>
  <line x1="8" y1="8" x2="16" y2="8" stroke="#E8EDF5" stroke-width="1.5" stroke-linecap="round"/>
  <line x1="8" y1="12" x2="14" y2="12" stroke="#E8EDF5" stroke-width="1.5" stroke-linecap="round"/>
  <line x1="8" y1="16" x2="12" y2="16" stroke="#7DD3FC" stroke-width="1.5" stroke-linecap="round"/>
</svg>''',
        "image-viewer": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect x="3" y="3" width="18" height="18" rx="3" fill="#0F172A" stroke="#8BA4FF" stroke-width="1.5"/>
  <circle cx="8.5" cy="8.5" r="2" fill="#E8C77B"/>
  <polygon points="21 16 16 11 5 21 21 21" fill="#7DD3FC"/>
</svg>''',
        "media-player": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect x="3" y="3" width="18" height="18" rx="4" fill="#0B0E14" stroke="#B4A7FF" stroke-width="1.5"/>
  <polygon points="10 8 16 12 10 16 10 8" fill="#7DD3FC"/>
</svg>''',
        "archive-manager": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect x="3" y="4" width="18" height="16" rx="2" fill="#1E293B" stroke="#E8C77B" stroke-width="1.5"/>
  <line x1="12" y1="4" x2="12" y2="14" stroke="#E8C77B" stroke-width="2"/>
  <rect x="10" y="14" width="4" height="3" rx="1" fill="#E8C77B"/>
</svg>''',
        "software-center": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z" fill="#0F172A" stroke="#8BE28B" stroke-width="1.5"/>
  <line x1="3" y1="6" x2="21" y2="6" stroke="#8BE28B" stroke-width="1.5"/>
  <path d="M16 10a4 4 0 0 1-8 0" stroke="#7DD3FC" stroke-width="1.5" stroke-linecap="round" fill="none"/>
</svg>''',
        "disk-utility": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect x="3" y="6" width="18" height="12" rx="2" fill="#11161F" stroke="#7DD3FC" stroke-width="1.5"/>
  <circle cx="7" cy="12" r="1.5" fill="#8BE28B"/>
  <circle cx="17" cy="12" r="1.5" fill="#38BDF8"/>
</svg>''',
        "pavucontrol": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect x="3" y="3" width="18" height="18" rx="4" fill="#0F172A" stroke="#7DD3FC" stroke-width="1.5"/>
  <line x1="7" y1="8" x2="17" y2="8" stroke="#38BDF8" stroke-width="2" stroke-linecap="round"/>
  <circle cx="13" cy="8" r="2" fill="#8BA4FF"/>
  <line x1="7" y1="16" x2="17" y2="16" stroke="#38BDF8" stroke-width="2" stroke-linecap="round"/>
  <circle cx="9" cy="16" r="2" fill="#8BE28B"/>
</svg>''',
        "obsidian": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <polygon points="12 2 20 8 16 22 8 22 4 8 12 2" fill="#1E1B4B" stroke="#B4A7FF" stroke-width="1.5"/>
</svg>''',
        "discord": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect x="2" y="3" width="20" height="18" rx="5" fill="#312E81"/>
  <circle cx="9" cy="12" r="2" fill="#8BA4FF"/><circle cx="15" cy="12" r="2" fill="#8BA4FF"/>
</svg>''',
        "thunderbird": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect x="3" y="4" width="18" height="16" rx="3" fill="#0284C7"/>
  <polyline points="3 6 12 13 21 6" stroke="#E8EDF5" stroke-width="1.5" fill="none"/>
</svg>''',
        "gimp": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect x="3" y="3" width="18" height="18" rx="4" fill="#1E293B"/>
  <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" fill="#7DD3FC"/>
</svg>''',
        "inkscape": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <polygon points="12 2 20 20 4 20 12 2" fill="#0F172A" stroke="#7DD3FC" stroke-width="1.5"/>
</svg>''',
        "steam": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect x="2" y="3" width="20" height="18" rx="4" fill="#0F172A"/>
  <circle cx="14" cy="9" r="3" stroke="#38BDF8" stroke-width="2" fill="none"/>
  <circle cx="8" cy="16" r="2" stroke="#38BDF8" stroke-width="2" fill="none"/>
</svg>''',
        "brave-browser": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <polygon points="12 2 18 6 16 18 12 22 8 18 6 6 12 2" fill="#9A3412" stroke="#F97316" stroke-width="1.5"/>
</svg>''',
        "preferences-system-network": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect x="3" y="4" width="18" height="16" rx="3" fill="#0F172A" stroke="#7DD3FC" stroke-width="1.5"/>
  <path d="M7 9h10M7 13h10M7 17h6" stroke="#38BDF8" stroke-width="1.5" stroke-linecap="round"/>
  <circle cx="16" cy="17" r="1.5" fill="#8BE28B"/>
</svg>''',
        "network-wired": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect x="2" y="3" width="20" height="18" rx="4" fill="#0B0E14" stroke="#7DD3FC" stroke-width="1.5"/>
  <path d="M6 12h12M12 6v12" stroke="#38BDF8" stroke-width="1.5" stroke-linecap="round"/>
  <rect x="9" y="9" width="6" height="6" rx="1" fill="#8BA4FF"/>
</svg>''',
        "preferences-desktop-theme": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect x="3" y="3" width="18" height="18" rx="4" fill="#1E293B" stroke="#B4A7FF" stroke-width="1.5"/>
  <circle cx="8" cy="8" r="2" fill="#7DD3FC"/>
  <circle cx="16" cy="8" r="2" fill="#8BE28B"/>
  <circle cx="12" cy="16" r="2" fill="#E8C77B"/>
</svg>''',
        "preferences-desktop-emojis": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <circle cx="12" cy="12" r="9" fill="#0F172A" stroke="#E8C77B" stroke-width="1.5"/>
  <circle cx="9" cy="9" r="1.25" fill="#E8C77B"/>
  <circle cx="15" cy="9" r="1.25" fill="#E8C77B"/>
  <path d="M8 14s1.5 2 4 2 4-2 4-2" stroke="#E8C77B" stroke-width="1.5" stroke-linecap="round" fill="none"/>
</svg>''',
        "hwloc": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect x="4" y="4" width="16" height="16" rx="3" fill="#0F172A" stroke="#7DD3FC" stroke-width="1.5"/>
  <rect x="8" y="8" width="8" height="8" rx="1" fill="#1E293B" stroke="#38BDF8" stroke-width="1.5"/>
  <line x1="9" y1="1" x2="9" y2="4" stroke="#7DD3FC" stroke-width="1.5"/>
  <line x1="15" y1="1" x2="15" y2="4" stroke="#7DD3FC" stroke-width="1.5"/>
  <line x1="9" y1="20" x2="9" y2="23" stroke="#7DD3FC" stroke-width="1.5"/>
  <line x1="15" y1="20" x2="15" y2="23" stroke="#7DD3FC" stroke-width="1.5"/>
</svg>''',
        "printer": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <path d="M6 9V4h12v5" stroke="#7DD3FC" stroke-width="1.5" stroke-linecap="round" fill="none"/>
  <rect x="4" y="9" width="16" height="8" rx="2" fill="#1E293B" stroke="#7DD3FC" stroke-width="1.5"/>
  <path d="M6 14v6h12v-6" fill="#0F172A" stroke="#38BDF8" stroke-width="1.5"/>
  <circle cx="17" cy="11.5" r="1" fill="#8BE28B"/>
</svg>''',
        "applications-system": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect x="3" y="3" width="18" height="18" rx="4" fill="#0F172A" stroke="#7DD3FC" stroke-width="1.5"/>
  <circle cx="12" cy="12" r="3" stroke="#38BDF8" stroke-width="1.5" fill="none"/>
  <path d="M12 6v2M12 16v2M6 12h2M16 12h2" stroke="#8BA4FF" stroke-width="1.5" stroke-linecap="round"/>
</svg>''',
        "gpsd-logo": '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <circle cx="12" cy="12" r="9" fill="#0B0E14" stroke="#7DD3FC" stroke-width="1.5"/>
  <circle cx="12" cy="12" r="5" stroke="#38BDF8" stroke-width="1.25" fill="none"/>
  <circle cx="12" cy="12" r="2" fill="#8BE28B"/>
  <line x1="12" y1="2" x2="12" y2="22" stroke="#7DD3FC" stroke-width="1" stroke-dasharray="2 2"/>
  <line x1="2" y1="12" x2="22" y2="12" stroke="#7DD3FC" stroke-width="1" stroke-dasharray="2 2"/>
</svg>''',
    }
}

SYMLINKS = {
    "actions": {
        "system-search-symbolic.svg": "search.svg",
        "search-symbolic.svg": "search.svg",
        "system-search.svg": "search.svg",
        "edit-clear-symbolic.svg": "close.svg",
        "close-symbolic.svg": "close.svg",
        "window-close-symbolic.svg": "close.svg",
        "preferences-system-symbolic.svg": "settings.svg",
        "settings-symbolic.svg": "settings.svg",
        "preferences-system.svg": "settings.svg",
        "document-save-symbolic.svg": "save.svg",
        "document-save.svg": "save.svg",
        "document-save-as-symbolic.svg": "save-as.svg",
        "document-save-as.svg": "save-as.svg",
        "document-open-symbolic.svg": "open.svg",
        "document-open.svg": "open.svg",
        "document-new-symbolic.svg": "new.svg",
        "document-new.svg": "new.svg",
        "edit-undo-symbolic.svg": "undo.svg",
        "edit-undo.svg": "undo.svg",
        "edit-redo-symbolic.svg": "redo.svg",
        "edit-redo.svg": "redo.svg",
        "edit-cut-symbolic.svg": "cut.svg",
        "edit-cut.svg": "cut.svg",
        "edit-copy-symbolic.svg": "copy.svg",
        "edit-copy.svg": "copy.svg",
        "edit-paste-symbolic.svg": "paste.svg",
        "edit-paste.svg": "paste.svg",
        "edit-delete-symbolic.svg": "delete.svg",
        "edit-delete.svg": "delete.svg",
        "go-previous-symbolic.svg": "back.svg",
        "go-previous.svg": "back.svg",
        "go-next-symbolic.svg": "forward.svg",
        "go-next.svg": "forward.svg",
        "view-refresh-symbolic.svg": "refresh.svg",
        "view-refresh.svg": "refresh.svg",
        "help-about-symbolic.svg": "info.svg",
        "help-about.svg": "info.svg",
        "help-faq-symbolic.svg": "question.svg",
        "help-faq.svg": "question.svg",
        "media-playback-start-symbolic.svg": "play.svg",
        "media-playback-pause-symbolic.svg": "pause.svg",
        "media-playback-stop-symbolic.svg": "stop.svg",
    },
    "status": {
        "network-wireless-symbolic.svg": "network-wifi.svg",
        "network-wifi-symbolic.svg": "network-wifi.svg",
        "network-wireless.svg": "network-wifi.svg",
        "network-wired-symbolic.svg": "network-wired.svg",
        "network-offline-symbolic.svg": "network-disconnected.svg",
        "network-wireless-disconnected-symbolic.svg": "network-disconnected.svg",
        "bluetooth-symbolic.svg": "bluetooth.svg",
        "bluetooth-active-symbolic.svg": "bluetooth.svg",
        "audio-volume-high-symbolic.svg": "volume.svg",
        "audio-volume-medium-symbolic.svg": "volume-medium.svg",
        "audio-volume-low-symbolic.svg": "volume-low.svg",
        "audio-volume-high.svg": "volume.svg",
        "volume-symbolic.svg": "volume.svg",
        "audio-volume-muted-symbolic.svg": "volume-muted.svg",
        "audio-volume-muted.svg": "volume-muted.svg",
        "volume-muted-symbolic.svg": "volume-muted.svg",
        "battery-good-symbolic.svg": "battery.svg",
        "battery-full-symbolic.svg": "battery-full.svg",
        "battery-symbolic.svg": "battery.svg",
        "battery-caution-symbolic.svg": "battery-low.svg",
        "battery-low-symbolic.svg": "battery-low.svg",
        "battery-charging-symbolic.svg": "battery-charging.svg",
        "display-brightness-symbolic.svg": "brightness.svg",
        "brightness-symbolic.svg": "brightness.svg",
        "preferences-system-notifications-symbolic.svg": "notification.svg",
        "notification-symbolic.svg": "notification.svg",
        "system-shutdown-symbolic.svg": "power.svg",
        "system-reboot-symbolic.svg": "restart.svg",
        "system-log-out-symbolic.svg": "logout.svg",
        "system-lock-screen-symbolic.svg": "screen-lock.svg",
        "preferences-desktop-display-symbolic.svg": "display.svg",
        "preferences-desktop-keyboard-symbolic.svg": "keyboard.svg",
        "preferences-desktop-sound-symbolic.svg": "sound.svg",
        "preferences-system-network-symbolic.svg": "network.svg",
        "preferences-system-privacy-symbolic.svg": "privacy.svg",
    },
    "places": {
        "folder-symbolic.svg": "folder.svg",
        "user-trash-symbolic.svg": "trash.svg",
        "user-home-symbolic.svg": "home.svg",
        "user-home.svg": "home.svg",
        "user-desktop-symbolic.svg": "desktop.svg",
        "user-desktop.svg": "desktop.svg",
        "folder-download-symbolic.svg": "downloads.svg",
        "folder-download.svg": "downloads.svg",
        "folder-documents-symbolic.svg": "documents.svg",
        "folder-documents.svg": "documents.svg",
        "folder-pictures-symbolic.svg": "pictures.svg",
        "folder-pictures.svg": "pictures.svg",
        "folder-music-symbolic.svg": "music.svg",
        "folder-music.svg": "music.svg",
        "folder-videos-symbolic.svg": "videos.svg",
        "folder-videos.svg": "videos.svg",
    },
    "apps": {
        "utilities-terminal-symbolic.svg": "kitty.svg",
        "utilities-terminal.svg": "kitty.svg",
        "terminal.svg": "kitty.svg",
        "org.gnome.Terminal.svg": "kitty.svg",
        "system-file-manager.svg": "yazi.svg",
        "nemo.svg": "yazi.svg",
        "accessories-calculator.svg": "calculator.svg",
        "office-calendar.svg": "calendar-app.svg",
        "accessories-text-editor.svg": "text-editor.svg",
        "multimedia-photo-viewer.svg": "image-viewer.svg",
        "mpv.svg": "media-player.svg",
        "web-browser.svg": "firefox.svg",
        "browser.svg": "firefox.svg",
        "utilities-archiver.svg": "archive-manager.svg",
        "system-software-install.svg": "software-center.svg",
        "package-manager.svg": "software-center.svg",
        "gnome-disks.svg": "disk-utility.svg",
        "org.pulseaudio.pavucontrol.svg": "pavucontrol.svg",
        "org.mozilla.Thunderbird.svg": "thunderbird.svg",
        "org.gimp.GIMP.svg": "gimp.svg",
        "org.inkscape.Inkscape.svg": "inkscape.svg",
        "com.brave.Origin.beta.svg": "brave-browser.svg",
        "zen.svg": "firefox.svg",
        "nm-connection-editor.svg": "preferences-system-network.svg",
        "bssh.svg": "network-wired.svg",
        "bvnc.svg": "network-wired.svg",
        "avahi-discover.svg": "network-wired.svg",
        "lxappearance.svg": "preferences-desktop-theme.svg",
        "rofimoji.svg": "preferences-desktop-emojis.svg",
        "lstopo.svg": "hwloc.svg",
        "system-config-printer.svg": "printer.svg",
        "uuctl.svg": "applications-system.svg",
        "xgps.svg": "gpsd-logo.svg",
        "xgpsspeed.svg": "gpsd-logo.svg",
    }
}

INDEX_THEME = """[Icon Theme]
Name=Minimal
Comment=Minimal Custom SVG Icon Theme
Inherits=Adwaita,hicolor
Directories=scalable/actions,scalable/apps,scalable/devices,scalable/emblems,scalable/mimetypes,scalable/places,scalable/status

[scalable/actions]
Size=24
Context=Actions
Type=Scalable
MinSize=16
MaxSize=512

[scalable/apps]
Size=24
Context=Applications
Type=Scalable
MinSize=16
MaxSize=512

[scalable/devices]
Size=24
Context=Devices
Type=Scalable
MinSize=16
MaxSize=512

[scalable/emblems]
Size=24
Context=Emblems
Type=Scalable
MinSize=16
MaxSize=512

[scalable/mimetypes]
Size=24
Context=MimeTypes
Type=Scalable
MinSize=16
MaxSize=512

[scalable/places]
Size=24
Context=Places
Type=Scalable
MinSize=16
MaxSize=512

[scalable/status]
Size=24
Context=Status
Type=Scalable
MinSize=16
MaxSize=512
"""

def main():
    ensure_dirs()
    
    with open(os.path.join(DIST_DIR, "index.theme"), "w", encoding="utf-8") as f:
        f.write(INDEX_THEME)
        
    count_icons = 0
    for cat, icons in ICONS.items():
        for name, svg in icons.items():
            write_svg(cat, name, svg)
            count_icons += 1

    count_links = 0
    for cat, links in SYMLINKS.items():
        for link_name, target_file in links.items():
            dist_cat_dir = os.path.join(DIST_SCALABLE, cat)
            link_path = os.path.join(dist_cat_dir, link_name)
            if os.path.lexists(link_path):
                os.remove(link_path)
            os.symlink(target_file, link_path)
            
            src_cat_dir = os.path.join(SRC_DIR, cat)
            src_link_path = os.path.join(src_cat_dir, link_name)
            if os.path.lexists(src_link_path):
                os.remove(src_link_path)
            os.symlink(target_file, src_link_path)
            count_links += 1

    print(f"[OK] Generated {count_icons} canonical Minimal icons + {count_links} freedesktop symlinks in {DIST_DIR}")

if __name__ == "__main__":
    main()
