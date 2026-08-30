#!/usr/bin/env python3
import sys
import os
import subprocess
import datetime

def log_debug(msg):
    with open("/tmp/rofi-apps-debug.log", "a") as f:
        f.write(f"{datetime.datetime.now()} - {msg}\n")

def launch_app(desktop_file):
    log_debug(f"Launching: {desktop_file}")
    exec_cmd = ""
    terminal = False
    with open(desktop_file, 'r', encoding='utf-8', errors='ignore') as f:
        in_desktop_entry = False
        for line in f:
            line = line.strip()
            if line == "[Desktop Entry]":
                in_desktop_entry = True
            elif line.startswith("[") and in_desktop_entry:
                break
            if in_desktop_entry:
                if line.startswith("Exec="):
                    exec_cmd = line.split("=", 1)[1]
                elif line.startswith("Terminal="):
                    terminal = line.split("=", 1)[1].lower() == "true"
    
    if exec_cmd:
        for token in ["%u", "%U", "%f", "%F", "%c", "%i", "%k"]:
            exec_cmd = exec_cmd.replace(token, "")
        exec_cmd = exec_cmd.strip()
        
        if terminal:
            exec_cmd = f"kitty -- {exec_cmd}"
            
        log_debug(f"Executing command: {exec_cmd}")
        subprocess.Popen(["sh", "-c", exec_cmd], start_new_session=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        subprocess.Popen(["pkill", "-x", "rofi"])

log_debug(f"Invoked with argv: {sys.argv} | ROFI_RETV: {os.environ.get('ROFI_RETV')} | ROFI_INFO: {os.environ.get('ROFI_INFO')}")

if "ROFI_INFO" in os.environ and os.environ.get("ROFI_RETV") in ["1", "2"]:
    log_debug("ROFI_INFO found in environment. Launching directly.")
    launch_app(os.environ["ROFI_INFO"])
    sys.exit(0)

directories = [
    "/usr/share/applications",
    os.path.expanduser("~/.local/share/applications")
]

def parse_desktop_file(filepath):
    app = {"file": filepath, "name": "", "icon": "", "categories": [], "nodisplay": False, "generic": ""}
    try:
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            in_desktop_entry = False
            for line in f:
                line = line.strip()
                if line == "[Desktop Entry]":
                    in_desktop_entry = True
                elif line.startswith("[") and in_desktop_entry:
                    break
                if not in_desktop_entry:
                    continue
                    
                if line.startswith("Name=") and not app["name"]:
                    app["name"] = line.split("=", 1)[1]
                elif line.startswith("GenericName=") and not app["generic"]:
                    app["generic"] = line.split("=", 1)[1]
                elif line.startswith("Icon=") and not app["icon"]:
                    app["icon"] = line.split("=", 1)[1]
                elif line.startswith("Categories="):
                    cats = line.split("=", 1)[1].split(";")
                    app["categories"] = [c.strip() for c in cats if c.strip()]
                elif line.startswith("NoDisplay="):
                    app["nodisplay"] = line.split("=", 1)[1].lower() == "true"
    except Exception:
        return None
        
    if app["name"] and not app["nodisplay"]:
        return app
    return None

MAIN_CATEGORIES = {
    "AudioVideo": "Multimedia",
    "Audio": "Multimedia",
    "Video": "Multimedia",
    "Development": "Development",
    "Education": "Education",
    "Game": "Games",
    "Graphics": "Graphics",
    "Network": "Network",
    "Office": "Office",
    "Science": "Science",
    "Settings": "System",
    "System": "System",
    "Utility": "Utilities"
}

def get_category(cats):
    for c in cats:
        if c in MAIN_CATEGORIES:
            return MAIN_CATEGORIES[c]
    return "Other"

apps = []
seen_names = set()

for d in directories:
    if not os.path.isdir(d):
        continue
    for filename in os.listdir(d):
        if not filename.endswith(".desktop"):
            continue
        app = parse_desktop_file(os.path.join(d, filename))
        if app:
            if app["name"] not in seen_names:
                seen_names.add(app["name"])
                app["main_category"] = get_category(app["categories"])
                apps.append(app)

if len(sys.argv) > 1 and sys.argv[1] == "get_modes":
    present_categories = set(app["main_category"] for app in apps)
    sorted_cats = sorted(list(present_categories))
    if "Other" in sorted_cats:
        sorted_cats.remove("Other")
        sorted_cats.append("Other")
    
    script_path = os.path.abspath(__file__)
    modes = [f"All:{script_path} All"]
    for cat in sorted_cats:
        modes.append(f"{cat}:{script_path} {cat}")
    print(",".join(modes))
    sys.exit(0)

target_category = sys.argv[1] if len(sys.argv) > 1 else "All"
apps.sort(key=lambda x: x["name"].lower())

# Build the display list
for app in apps:
    generic = f"  <span size='9pt' fgcolor='#8D95B3'>{app['generic']}</span>" if app['generic'] else ""
    app["display"] = f"{app['name']}{generic}"

# Fallback launch method if ROFI_INFO fails but ROFI_RETV indicates a selection
if os.environ.get("ROFI_RETV") in ["1", "2"] and len(sys.argv) > 2:
    selected_text = sys.argv[2]
    log_debug(f"Selection detected via argv[2]. Text: {selected_text}")
    for app in apps:
        if app["display"] == selected_text or app["name"] == selected_text:
            log_debug(f"Matched app: {app['name']}")
            launch_app(app["file"])
            subprocess.Popen(["pkill", "-x", "rofi"])
            sys.exit(0)

# Otherwise print list
for app in apps:
    if target_category != "All" and app["main_category"] != target_category:
        continue
    meta = f"{app['name']} {app['generic']}"
    # Print rofi entry
    print(f"{app['display']}\0icon\x1f{app['icon']}\x1fmeta\x1f{meta}\x1finfo\x1f{app['file']}")
