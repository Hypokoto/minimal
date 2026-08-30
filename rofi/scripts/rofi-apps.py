#!/usr/bin/env python3
import sys
import os
import subprocess

def launch_app(desktop_file):
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
            
        subprocess.Popen(["hyprctl", "dispatch", "exec", "--", exec_cmd], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

if "ROFI_INFO" in os.environ:
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
    # Auto-generate modes based on present categories
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

for app in apps:
    if target_category != "All" and app["main_category"] != target_category:
        continue
    generic = f"  <span size='9pt' fgcolor='#8D95B3'>{app['generic']}</span>" if app['generic'] else ""
    display = f"{app['name']}{generic}"
    meta = f"{app['name']} {app['generic']}"
    print(f"{display}\0icon\x1f{app['icon']}\x1fmeta\x1f{meta}\x1finfo\x1f{app['file']}")
