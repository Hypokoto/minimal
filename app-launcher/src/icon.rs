use std::collections::HashMap;
use std::path::PathBuf;

pub struct IconResolver {
    cache: HashMap<String, String>,
}

impl IconResolver {
    pub fn new() -> Self {
        Self {
            cache: HashMap::new(),
        }
    }

    pub fn get_icon_uri(&mut self, icon_name: &Option<String>) -> String {
        let name = icon_name.as_deref().unwrap_or("application-x-executable");
        
        if let Some(cached) = self.cache.get(name) {
            return cached.clone();
        }

        let uri = self.resolve(name);
        self.cache.insert(name.to_string(), uri.clone());
        uri
    }

    fn resolve(&self, name: &str) -> String {
        // Find icon using linicon
        let mut icon_path = None;
        
        if let Some(mut iter) = Some(linicon::lookup_icon(name).with_size(64)) {
            if let Some(Ok(i)) = iter.next() {
                icon_path = Some(i.path);
            }
        }

        let path = icon_path.or_else(|| {
            // Absolute path fallback
            let p = PathBuf::from(name);
            if p.exists() {
                Some(p)
            } else {
                None
            }
        });

        match path {
            Some(p) => format!("file://{}", p.display()),
            None => "".to_string(), // Let egui handle missing image
        }
    }
}
