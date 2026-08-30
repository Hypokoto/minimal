use std::collections::{HashSet, HashMap};
use std::path::PathBuf;
use std::fs;
use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Default, Clone)]
pub struct AppState {
    pub favorites: HashSet<String>, // Stores desktop file names or names
    pub launch_counts: HashMap<String, u32>,
    pub recent: Vec<String>,
}

impl AppState {
    pub fn load() -> Self {
        if let Some(mut path) = dirs::config_dir() {
            path.push("app-launcher");
            path.push("state.json");
            if let Ok(content) = fs::read_to_string(&path) {
                if let Ok(state) = serde_json::from_str(&content) {
                    return state;
                }
            }
        }
        Self::default()
    }

    pub fn save(&self) {
        if let Some(mut path) = dirs::config_dir() {
            path.push("app-launcher");
            if !path.exists() {
                let _ = fs::create_dir_all(&path);
            }
            path.push("state.json");
            if let Ok(json) = serde_json::to_string_pretty(self) {
                let _ = fs::write(path, json);
            }
        }
    }

    pub fn record_launch(&mut self, app_name: &str) {
        *self.launch_counts.entry(app_name.to_string()).or_insert(0) += 1;
        self.recent.retain(|n| n != app_name);
        self.recent.insert(0, app_name.to_string());
        if self.recent.len() > 10 {
            self.recent.truncate(10);
        }
        self.save();
    }

    pub fn toggle_favorite(&mut self, app_name: &str) {
        if !self.favorites.insert(app_name.to_string()) {
            self.favorites.remove(app_name);
        }
        self.save();
    }
}
