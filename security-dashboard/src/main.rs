#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

mod app;
mod network;
mod process;
mod tools;

use eframe::egui;

#[tokio::main]
async fn main() -> eframe::Result<()> {
    let options = eframe::NativeOptions {
        viewport: egui::ViewportBuilder::default()
            .with_inner_size([1000.0, 700.0])
            .with_min_inner_size([800.0, 500.0])
            .with_title("Minimal Security Dashboard"),
        ..Default::default()
    };

    eframe::run_native(
        "security_dashboard",
        options,
        Box::new(|cc| Box::new(app::SecurityApp::new(cc))),
    )
}
