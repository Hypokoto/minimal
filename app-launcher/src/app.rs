use eframe::egui;
use eframe::egui::{Color32, RichText, Key, ScrollArea, Vec2, Frame, Margin, Rounding, Stroke};
use fuzzy_matcher::FuzzyMatcher;
use fuzzy_matcher::skim::SkimMatcherV2;
use std::process::Command;

use crate::desktop::{discover_apps, AppEntry};
use crate::state::AppState;
use crate::icon::IconResolver;

pub struct LauncherApp {
    apps: Vec<AppEntry>,
    filtered: Vec<AppEntry>,
    state: AppState,
    icon_resolver: IconResolver,
    
    search_query: String,
    selected_index: usize,
    
    categories: Vec<String>,
    active_category: String,
    
    matcher: SkimMatcherV2,
}

impl LauncherApp {
    pub fn new(cc: &eframe::CreationContext<'_>) -> Self {
        egui_extras::install_image_loaders(&cc.egui_ctx);
        
        let mut style = (*cc.egui_ctx.style()).clone();
        style.visuals.window_fill = Color32::from_rgba_premultiplied(11, 15, 23, 230); // Dark translucent
        style.visuals.panel_fill = Color32::from_rgba_premultiplied(11, 15, 23, 230);
        cc.egui_ctx.set_style(style);

        let apps = discover_apps();
        let state = AppState::load();
        
        let mut categories = vec!["All".to_string(), "Favorites".to_string(), "Recent".to_string()];
        let mut cat_set = std::collections::HashSet::new();
        for app in &apps {
            for c in &app.categories {
                cat_set.insert(c.clone());
            }
        }
        let mut sorted_cats: Vec<_> = cat_set.into_iter().collect();
        sorted_cats.sort();
        categories.extend(sorted_cats);

        let mut app = Self {
            apps: apps.clone(),
            filtered: apps,
            state,
            icon_resolver: IconResolver::new(),
            search_query: String::new(),
            selected_index: 0,
            categories,
            active_category: "All".to_string(),
            matcher: SkimMatcherV2::default(),
        };
        app.update_filter();
        app
    }

    fn update_filter(&mut self) {
        self.selected_index = 0;
        
        if self.search_query.is_empty() {
            match self.active_category.as_str() {
                "All" => {
                    self.filtered = self.apps.clone();
                }
                "Favorites" => {
                    self.filtered = self.apps.iter()
                        .filter(|a| self.state.favorites.contains(&a.name))
                        .cloned()
                        .collect();
                }
                "Recent" => {
                    self.filtered = self.state.recent.iter()
                        .filter_map(|name| self.apps.iter().find(|a| &a.name == name))
                        .cloned()
                        .collect();
                }
                cat => {
                    self.filtered = self.apps.iter()
                        .filter(|a| a.categories.contains(&cat.to_string()))
                        .cloned()
                        .collect();
                }
            }
        } else {
            let mut matches = Vec::new();
            for app in &self.apps {
                let text_to_match = format!("{} {}", app.name, app.exec);
                if let Some(score) = self.matcher.fuzzy_match(&text_to_match, &self.search_query) {
                    matches.push((score, app.clone()));
                }
            }
            matches.sort_by(|a, b| b.0.cmp(&a.0));
            self.filtered = matches.into_iter().map(|(_, app)| app).collect();
        }
    }

    fn launch(&mut self, app: &AppEntry) {
        self.state.record_launch(&app.name);
        
        // Parse Exec (very simplified)
        let parts: Vec<&str> = app.exec.split_whitespace().collect();
        if parts.is_empty() { return; }
        
        // Filter out `%u`, `%F`, etc.
        let args: Vec<&str> = parts[1..].iter()
            .filter(|a| !a.starts_with('%'))
            .copied()
            .collect();
            
        let _ = Command::new(parts[0])
            .args(args)
            .spawn();
            
        std::process::exit(0);
    }
}

impl eframe::App for LauncherApp {
    fn update(&mut self, ctx: &egui::Context, _frame: &mut eframe::Frame) {
        // Keyboard shortcuts
        if ctx.input(|i| i.key_pressed(Key::Escape)) {
            if self.search_query.is_empty() {
                std::process::exit(0);
            } else {
                self.search_query.clear();
                self.update_filter();
            }
        }

        if ctx.input(|i| i.key_pressed(Key::ArrowDown)) {
            // Need columns width math here, simple fallback for now
            self.selected_index = (self.selected_index + 1).min(self.filtered.len().saturating_sub(1));
        }
        if ctx.input(|i| i.key_pressed(Key::ArrowUp)) {
            self.selected_index = self.selected_index.saturating_sub(1);
        }
        if ctx.input(|i| i.key_pressed(Key::ArrowRight)) {
            self.selected_index = (self.selected_index + 1).min(self.filtered.len().saturating_sub(1));
        }
        if ctx.input(|i| i.key_pressed(Key::ArrowLeft)) {
            self.selected_index = self.selected_index.saturating_sub(1);
        }
        if ctx.input(|i| i.key_pressed(Key::Enter)) {
            if let Some(app) = self.filtered.get(self.selected_index).cloned() {
                self.launch(&app);
            }
        }

        // Main Layout
        egui::CentralPanel::default().frame(Frame::none().fill(Color32::TRANSPARENT)).show(ctx, |ui| {
            ui.add_space(30.0);
            
            // Search Bar
            ui.horizontal(|ui| {
                ui.add_space(ui.available_width() * 0.2); // Center horizontally
                
                let search_width = ui.available_width() * 0.75; // 0.6 / 0.8
                let mut search_frame = Frame::default()
                    .inner_margin(Margin::same(14.0))
                    .rounding(Rounding::same(12.0))
                    .fill(Color32::from_rgba_premultiplied(20, 25, 35, 200))
                    .stroke(Stroke::new(1.0, Color32::from_rgba_premultiplied(0, 217, 255, 100)));
                    
                search_frame.show(ui, |ui| {
                    ui.set_width(search_width);
                    let res = ui.add(egui::TextEdit::singleline(&mut self.search_query)
                        .hint_text("Search applications...")
                        .font(egui::TextStyle::Heading)
                        .frame(false));
                        
                    res.request_focus();
                    if res.changed() {
                        self.update_filter();
                    }
                });
            });

            ui.add_space(20.0);

            // Categories
            if self.search_query.is_empty() {
                let mut clicked_cat = None;
                ui.horizontal(|ui| {
                    ScrollArea::horizontal().show(ui, |ui| {
                        ui.add_space(20.0);
                        for cat in &self.categories {
                            let is_active = *cat == self.active_category;
                            let color = if is_active { Color32::from_rgb(0, 217, 255) } else { Color32::from_rgb(141, 149, 179) };
                            
                            if ui.add(egui::SelectableLabel::new(is_active, RichText::new(cat).color(color))).clicked() {
                                clicked_cat = Some(cat.clone());
                            }
                        }
                    });
                });
                if let Some(cat) = clicked_cat {
                    self.active_category = cat;
                    self.update_filter();
                }
                ui.add_space(10.0);
            }

            // Grid
            ScrollArea::vertical().show(ui, |ui| {
                let avail_width = ui.available_width();
                let item_width = 140.0;
                let columns = (avail_width / item_width).max(1.0) as usize;
                
                if self.filtered.is_empty() {
                    ui.add_space(50.0);
                    ui.vertical_centered(|ui| {
                        ui.label(RichText::new("No applications found").color(Color32::from_rgb(141, 149, 179)));
                        ui.label(RichText::new("Try another search").color(Color32::from_rgb(100, 110, 140)));
                    });
                } else {
                    egui::Grid::new("app_grid")
                        .num_columns(columns)
                        .spacing(Vec2::new(10.0, 10.0))
                        .show(ui, |ui| {
                            for (i, app) in self.filtered.clone().iter().enumerate() {
                                let is_selected = i == self.selected_index;
                                
                                let bg_color = if is_selected { 
                                    Color32::from_rgba_premultiplied(0, 217, 255, 30) 
                                } else { 
                                    Color32::TRANSPARENT 
                                };
                                
                                let stroke = if is_selected {
                                    Stroke::new(1.0, Color32::from_rgb(0, 217, 255))
                                } else {
                                    Stroke::NONE
                                };

                                let frame = Frame::none()
                                    .fill(bg_color)
                                    .stroke(stroke)
                                    .rounding(Rounding::same(12.0))
                                    .inner_margin(Margin::same(12.0));

                                let resp = frame.show(ui, |ui| {
                                    ui.set_width(item_width - 20.0);
                                    ui.vertical_centered(|ui| {
                                        let uri = self.icon_resolver.get_icon_uri(&app.icon_name);
                                        if !uri.is_empty() {
                                            ui.add(egui::Image::new(&uri).max_size(Vec2::new(64.0, 64.0)));
                                        } else {
                                            ui.add_space(64.0); // Placeholder
                                        }
                                        ui.add_space(8.0);
                                        
                                        // Truncate name if too long
                                        let name = if app.name.len() > 16 {
                                            format!("{}...", &app.name[0..13])
                                        } else {
                                            app.name.clone()
                                        };
                                        ui.label(RichText::new(name).color(Color32::from_rgb(242, 246, 255)));
                                    });
                                }).response;

                                if resp.clicked() {
                                    self.launch(&app);
                                }
                                
                                if resp.hovered() {
                                    self.selected_index = i;
                                }

                                resp.context_menu(|ui| {
                                    if ui.button("Open").clicked() {
                                        self.launch(&app);
                                        ui.close_menu();
                                    }
                                    if self.state.favorites.contains(&app.name) {
                                        if ui.button("Remove from Favorites").clicked() {
                                            self.state.toggle_favorite(&app.name);
                                            self.update_filter();
                                            ui.close_menu();
                                        }
                                    } else {
                                        if ui.button("Add to Favorites").clicked() {
                                            self.state.toggle_favorite(&app.name);
                                            self.update_filter();
                                            ui.close_menu();
                                        }
                                    }
                                });

                                if (i + 1) % columns == 0 {
                                    ui.end_row();
                                }
                            }
                        });
                }
            });
            
            // Bottom Status
            ui.with_layout(egui::Layout::bottom_up(egui::Align::LEFT), |ui| {
                ui.add_space(8.0);
                ui.horizontal(|ui| {
                    ui.label(RichText::new(format!("{} applications", self.apps.len())).color(Color32::from_rgb(100, 110, 140)));
                    ui.with_layout(egui::Layout::right_to_left(egui::Align::Center), |ui| {
                        ui.label(RichText::new("↑↓ Navigate   Enter Launch   Esc Close").color(Color32::from_rgb(100, 110, 140)));
                    });
                });
            });
        });
    }
}
