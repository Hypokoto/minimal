use std::path::{Path, PathBuf};
use std::fs;
use walkdir::WalkDir;

#[derive(Clone, Debug, PartialEq)]
pub struct AppEntry {
    pub name: String,
    pub generic_name: Option<String>,
    pub exec: String,
    pub icon_name: Option<String>,
    pub categories: Vec<String>,
    pub desktop_file: PathBuf,
}

pub fn discover_apps() -> Vec<AppEntry> {
    let mut apps = Vec::new();
    let mut seen_execs = std::collections::HashSet::new();

    let mut search_paths = vec![PathBuf::from("/usr/share/applications")];
    if let Some(mut local_share) = dirs::data_local_dir() {
        local_share.push("applications");
        search_paths.push(local_share);
    }

    for base_path in search_paths {
        if !base_path.exists() {
            continue;
        }

        for entry in WalkDir::new(base_path).into_iter().filter_map(|e| e.ok()) {
            if entry.path().extension().and_then(|s| s.to_str()) != Some("desktop") {
                continue;
            }

            if let Some(app) = parse_desktop_file(entry.path()) {
                // Deduplicate by exact name + exec pattern to avoid duplicated entries
                // Many apps put files in both /usr/share and ~/.local/share
                let sig = format!("{}|{}", app.name, app.exec.split_whitespace().next().unwrap_or(""));
                if seen_execs.insert(sig) {
                    apps.push(app);
                }
            }
        }
    }

    apps.sort_by(|a, b| a.name.to_lowercase().cmp(&b.name.to_lowercase()));
    apps
}

fn parse_desktop_file(path: &Path) -> Option<AppEntry> {
    let content = fs::read_to_string(path).ok()?;
    
    let mut name = None;
    let mut generic_name = None;
    let mut exec = None;
    let mut icon_name = None;
    let mut categories = Vec::new();
    let mut no_display = false;
    let mut hidden = false;
    let mut type_is_app = false;

    let mut in_desktop_entry = false;

    for line in content.lines() {
        let line = line.trim();
        if line.is_empty() || line.starts_with('#') {
            continue;
        }

        if line.starts_with('[') {
            in_desktop_entry = line == "[Desktop Entry]";
            continue;
        }

        if !in_desktop_entry {
            continue;
        }

        if let Some((k, v)) = line.split_once('=') {
            let key = k.trim();
            let val = v.trim();

            match key {
                "Type" => type_is_app = val == "Application",
                "Name" => if name.is_none() { name = Some(val.to_string()) }, // Avoid overwriting with localized Name[xx] if they appear later, though typical parser checks exact key.
                "GenericName" => if generic_name.is_none() { generic_name = Some(val.to_string()) },
                "Exec" => exec = Some(val.to_string()),
                "Icon" => icon_name = Some(val.to_string()),
                "Categories" => {
                    categories = val.split(';').map(|s| s.trim().to_string()).filter(|s| !s.is_empty()).collect();
                }
                "NoDisplay" => no_display = val.to_lowercase() == "true",
                "Hidden" => hidden = val.to_lowercase() == "true",
                _ => {}
            }
        }
    }

    if !type_is_app || no_display || hidden {
        return None;
    }

    let name = name?;
    let exec = exec?;

    Some(AppEntry {
        name,
        generic_name,
        exec,
        icon_name,
        categories,
        desktop_file: path.to_path_buf(),
    })
}
