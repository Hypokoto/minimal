#!/usr/bin/env python3
"""
generate-aetheria-icons.py
Generates the complete Aetheria SVG icon family across actions, status, devices, places, and apps.
All symbolic icons use 24x24 viewBox, currentColor stroke/fill, round caps/joins.
App icons use brand palettes.
"""

import os
import shutil
import xml.etree.ElementTree as ET

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC_DIR = os.path.join(REPO_ROOT, "icons", "src")
DIST_DIR = os.path.join(REPO_ROOT, "icons", "dist", "Aetheria")
DIST_SCALABLE = os.path.join(DIST_DIR, "scalable")

CATEGORIES = ["actions", "apps", "devices", "emblems", "mimetypes", "places", "status"]

def ensure_dirs():
    for cat in CATEGORIES:
        os.makedirs(os.path.join(SRC_DIR, cat), exist_ok=True)
        os.makedirs(os.path.join(DIST_SCALABLE, cat), exist_ok=True)

def write_svg(category, name, svg_content):
    src_path = os.path.join(SRC_DIR, category, f"{name}.svg")
    dist_path = os.path.join(DIST_SCALABLE, category, f"{name}.svg")
    
    # Format and strip leading/trailing whitespace
    clean_content = svg_content.strip() + "\n"
    
    with open(src_path, "w", encoding="utf-8") as f:
        f.write(clean_content)
    with open(dist_path, "w", encoding="utf-8") as f:
        f.write(clean_content)

# --- SYMBOLIC SVG TEMPLATES (24x24, 20x20 safe area, stroke=1.75, round caps) ---
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
        "remove": wrap_stroke('<path d="M5 12h14"/>'),
        "close": wrap_stroke('<path d="M18 6L6 18M6 6l12 12"/>'),
        "check": wrap_stroke('<path d="M20 6L9 17l-5-5"/>'),
        "search": wrap_stroke('<circle cx="11" cy="11" r="7"/><path d="M21 21l-4.35-4.35"/>'),
        "settings": wrap_stroke('<circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/>'),
        "menu": wrap_stroke('<path d="M3 12h18M3 6h18M3 18h18"/>'),
        "more": wrap_stroke('<circle cx="12" cy="12" r="1.25" fill="currentColor"/><circle cx="5" cy="12" r="1.25" fill="currentColor"/><circle cx="19" cy="12" r="1.25" fill="currentColor"/>'),
        "edit": wrap_stroke('<path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>'),
        "copy": wrap_stroke('<rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/>'),
        "paste": wrap_stroke('<path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/><rect x="8" y="2" width="8" height="4" rx="1" ry="1"/>'),
        "download": wrap_stroke('<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3"/>'),
        "upload": wrap_stroke('<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M17 8l-5-5-5 5M12 3v12"/>'),
        "refresh": wrap_stroke('<path d="M23 4v6h-6M1 20v-6h6"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/>'),
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
        "fullscreen": wrap_stroke('<path d="M8 3H5a2 2 0 0 0-2 2v3m18 0V5a2 2 0 0 0-2-2h-3m0 18h3a2 2 0 0 0 2-2v-3M3 16v3a2 2 0 0 0 2 2h3"/>'),
        "system-search": wrap_stroke('<circle cx="11" cy="11" r="7"/><path d="M21 21l-4.35-4.35"/>'),
        "edit-clear": wrap_stroke('<path d="M18 6L6 18M6 6l12 12"/>'),
    },
    "status": {
        "battery": wrap_stroke('<rect x="1" y="6" width="18" height="12" rx="2"/><line x1="23" y1="10" x2="23" y2="14"/>'),
        "battery-low": wrap_stroke('<rect x="1" y="6" width="18" height="12" rx="2"/><line x1="23" y1="10" x2="23" y2="14"/><line x1="5" y1="10" x2="5" y2="14"/>'),
        "battery-charging": wrap_stroke('<rect x="1" y="6" width="18" height="12" rx="2"/><line x1="23" y1="10" x2="23" y2="14"/><path d="M11 9l-3 4h4l-2 4"/>'),
        "network": wrap_stroke('<path d="M5 12.55a11 11 0 0 1 14.08 0M1.42 9a16 16 0 0 1 21.16 0M8.53 16.11a6 6 0 0 1 6.95 0M12 20h.01"/>'),
        "network-wifi": wrap_stroke('<path d="M5 12.55a11 11 0 0 1 14.08 0M1.42 9a16 16 0 0 1 21.16 0M8.53 16.11a6 6 0 0 1 6.95 0M12 20h.01"/>'),
        "network-wired": wrap_stroke('<rect x="2" y="2" width="20" height="8" rx="2"/><path d="M6 10v4M18 10v4M12 10v10M2 20h20"/>'),
        "network-disconnected": wrap_stroke('<path d="M1 1l22 22M16.72 11.06A10.94 10.94 0 0 1 19 12.55M5 12.55a10.94 10.94 0 0 1 5.17-2.39"/>'),
        "bluetooth": wrap_stroke('<polyline points="6.5 6.5 17.5 17.5 12 23 12 1 17.5 6.5 6.5 17.5"/>'),
        "volume": wrap_stroke('<polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"/><path d="M15.54 8.46a5 5 0 0 1 0 7.07M19.07 4.93a10 10 0 0 1 0 14.14"/>'),
        "volume-muted": wrap_stroke('<polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"/><line x1="23" y1="9" x2="17" y2="15"/><line x1="17" y1="9" x2="23" y2="15"/>'),
        "brightness": wrap_stroke('<circle cx="12" cy="12" r="5"/><path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"/>'),
        "notification": wrap_stroke('<path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9M13.73 21a2 2 0 0 1-3.46 0"/>'),
        "notification-muted": wrap_stroke('<path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9M13.73 21a2 2 0 0 1-3.46 0M1 1l22 22"/>'),
        "error": wrap_stroke('<circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/>'),
        "warning": wrap_stroke('<path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>'),
        "success": wrap_stroke('<path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/>'),
        "info": wrap_stroke('<circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/>'),
        "dialog-error": wrap_stroke('<circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/>'),
        "dialog-warning": wrap_stroke('<path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>'),
        "dialog-information": wrap_stroke('<circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/>'),
    },
    "devices": {
        "computer": wrap_stroke('<rect x="2" y="3" width="20" height="14" rx="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/>'),
        "laptop": wrap_stroke('<rect x="4" y="4" width="16" height="12" rx="1"/><path d="M2 20h20"/>'),
        "keyboard": wrap_stroke('<rect x="2" y="4" width="20" height="16" rx="2"/><line x1="6" y1="8" x2="6" y2="8"/><line x1="10" y1="8" x2="10" y2="8"/><line x1="14" y1="8" x2="14" y2="8"/><line x1="18" y1="8" x2="18" y2="8"/><line x1="6" y1="12" x2="6" y2="12"/><line x1="10" y1="12" x2="10" y2="12"/><line x1="14" y1="12" x2="14" y2="12"/><line x1="18" y1="12" x2="18" y2="12"/><line x1="8" y1="16" x2="16" y2="16"/>'),
        "mouse": wrap_stroke('<rect x="6" y="3" width="12" height="18" rx="6"/><line x1="12" y1="7" x2="12" y2="11"/>'),
        "headphones": wrap_stroke('<path d="M3 18v-6a9 9 0 0 1 18 0v6"/><path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3zM3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z"/>'),
        "microphone": wrap_stroke('<path d="M12 1a3 3 0 0 0-3 3v8a3 3 0 0 0 6 0V4a3 3 0 0 0-3-3z"/><path d="M19 10v2a7 7 0 0 1-14 0v-2M12 19v4M8 23h8"/>'),
        "phone": wrap_stroke('<rect x="5" y="2" width="14" height="20" rx="2" ry="2"/><line x1="12" y1="18" x2="12.01" y2="18"/>'),
        "usb": wrap_stroke('<circle cx="12" cy="5" r="2"/><path d="M12 7v10M12 17l-3-3M12 17l3-3"/><rect x="8" y="19" width="8" height="4"/>'),
        "disk": wrap_stroke('<circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="3"/>'),
        "drive-harddisk": wrap_stroke('<rect x="2" y="6" width="20" height="12" rx="2"/><line x1="6" y1="12" x2="6.01" y2="12"/><line x1="18" y1="12" x2="18.01" y2="12"/>'),
    },
    "places": {
        "home": wrap_stroke('<path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/>'),
        "desktop": wrap_stroke('<rect x="2" y="3" width="20" height="14" rx="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/>'),
        "downloads": wrap_stroke('<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3"/>'),
        "documents": wrap_stroke('<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/>'),
        "pictures": wrap_stroke('<rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/>'),
        "music": wrap_stroke('<path d="M9 18V5l12-2v13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/>'),
        "videos": wrap_stroke('<rect x="2" y="4" width="20" height="16" rx="2"/><path d="M10 9l5 3-5 3V9z"/>'),
        "trash": wrap_stroke('<polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/>'),
        "user-trash": wrap_stroke('<polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/>'),
        "folder": wrap_stroke('<path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"/>'),
        "folder-open": wrap_stroke('<path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2v1"/><path d="M2 10h20l-2 9H4l-2-9z"/>'),
    },
    "emblems": {
        "emblem-default": wrap_stroke('<circle cx="12" cy="12" r="8"/>'),
        "emblem-important": wrap_stroke('<path d="M12 2L2 22h20L12 2zm0 14h.01M12 10v4"/>'),
    },
    "mimetypes": {
        "text-x-generic": wrap_stroke('<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/>'),
        "application-x-executable": wrap_stroke('<polygon points="12 2 2 7 12 12 22 7 12 2"/><polyline points="2 17 12 22 22 17"/><polyline points="2 12 12 17 22 12"/>'),
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
    }
}

INDEX_THEME = """[Icon Theme]
Name=Aetheria
Comment=Aetheria Custom SVG Icon Theme
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
        
    for cat, icons in ICONS.items():
        for name, svg in icons.items():
            write_svg(cat, name, svg)
            
    print(f"[OK] Generated Aetheria icon family in {DIST_DIR}")

if __name__ == "__main__":
    main()
