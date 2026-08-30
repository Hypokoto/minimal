use eframe::egui;
use eframe::egui::{Color32, RichText, ScrollArea};
use crossbeam_channel::{unbounded, Receiver};
use crate::process::{ProcessEvent, ProcessManager};
use crate::network::{NetworkStatus, spawn_network_monitor};
use crate::tools::{get_tools, ToolDefinition, ArgType};

pub struct SecurityApp {
    tools: Vec<ToolDefinition>,
    selected_tool_idx: Option<usize>,
    arg_inputs: Vec<String>,
    
    network_rx: Receiver<NetworkStatus>,
    network_status: NetworkStatus,
    
    process_rx: Receiver<ProcessEvent>,
    process_manager: ProcessManager,
    
    output_buffer: Vec<(String, Color32)>, // line, color
    is_running: bool,
    auto_scroll: bool,
}

impl SecurityApp {
    pub fn new(cc: &eframe::CreationContext<'_>) -> Self {
        // Apply custom fonts and styles here
        let mut style = (*cc.egui_ctx.style()).clone();
        style.visuals.window_fill = Color32::from_rgba_premultiplied(10, 12, 18, 240);
        style.visuals.panel_fill = Color32::from_rgba_premultiplied(10, 12, 18, 240);
        cc.egui_ctx.set_style(style);

        let (net_tx, net_rx) = unbounded();
        spawn_network_monitor(net_tx, cc.egui_ctx.clone());

        let (proc_tx, proc_rx) = unbounded();
        let process_manager = ProcessManager::new(proc_tx, cc.egui_ctx.clone());

        Self {
            tools: get_tools(),
            selected_tool_idx: None,
            arg_inputs: Vec::new(),
            
            network_rx: net_rx,
            network_status: NetworkStatus::default(),
            
            process_rx: proc_rx,
            process_manager,
            
            output_buffer: Vec::new(),
            is_running: false,
            auto_scroll: true,
        }
    }

    fn handle_events(&mut self) {
        // Network events
        while let Ok(status) = self.network_rx.try_recv() {
            self.network_status = status;
        }

        // Process events
        while let Ok(event) = self.process_rx.try_recv() {
            match event {
                ProcessEvent::Stdout(line) => {
                    self.output_buffer.push((line, Color32::from_rgb(242, 246, 255))); // @fg
                }
                ProcessEvent::Stderr(line) => {
                    self.output_buffer.push((line, Color32::from_rgb(255, 84, 112))); // @danger
                }
                ProcessEvent::Exit(code) => {
                    self.is_running = false;
                    let msg = match code {
                        Some(c) => format!("Process exited with code {}", c),
                        None => "Process terminated".to_string(),
                    };
                    self.output_buffer.push((format!("--- {} ---", msg), Color32::from_rgb(0, 217, 255)));
                }
                ProcessEvent::Error(err) => {
                    self.is_running = false;
                    self.output_buffer.push((format!("Error: {}", err), Color32::from_rgb(255, 84, 112)));
                }
            }
        }
    }
}

impl eframe::App for SecurityApp {
    fn update(&mut self, ctx: &egui::Context, _frame: &mut eframe::Frame) {
        self.handle_events();

        // Top Status Bar
        egui::TopBottomPanel::top("status_bar")
            .frame(egui::Frame::none().fill(Color32::from_rgb(28, 34, 48)).inner_margin(8.0))
            .show(ctx, |ui| {
                ui.horizontal(|ui| {
                    ui.label(RichText::new(format!("iface 󰈀  {}", self.network_status.iface)).color(Color32::from_rgb(141, 149, 179)));
                    ui.add_space(20.0);
                    ui.label(RichText::new(format!("local {}", self.network_status.local_ip)).color(Color32::from_rgb(0, 217, 255)));
                    ui.add_space(20.0);
                    ui.label(RichText::new(format!("pub {}", self.network_status.pub_ip)).color(Color32::from_rgb(0, 217, 255)));
                    ui.add_space(20.0);
                    ui.label(RichText::new(format!("estab {}", self.network_status.estab)).color(Color32::from_rgb(77, 255, 145)));
                });
            });

        // Left Panel (Tool Grid)
        egui::SidePanel::left("tools_panel")
            .min_width(200.0)
            .frame(egui::Frame::none().fill(Color32::from_rgb(17, 20, 29)).inner_margin(12.0))
            .show(ctx, |ui| {
                ui.heading(RichText::new("Tools").color(Color32::from_rgb(0, 217, 255)));
                ui.add_space(10.0);
                
                ScrollArea::vertical().show(ui, |ui| {
                    let mut new_selection = None;
                    for (i, tool) in self.tools.iter().enumerate() {
                        let is_selected = self.selected_tool_idx == Some(i);
                        let fill = if is_selected { Color32::from_rgb(28, 34, 48) } else { Color32::TRANSPARENT };
                        let text_color = if is_selected { Color32::from_rgb(0, 217, 255) } else { Color32::from_rgb(242, 246, 255) };

                        let btn = egui::Button::new(RichText::new(&tool.name).color(text_color))
                            .fill(fill)
                            .min_size(egui::vec2(ui.available_width(), 36.0));
                            
                        if ui.add(btn).clicked() {
                            new_selection = Some(i);
                        }
                        ui.add_space(4.0);
                    }

                    if let Some(i) = new_selection {
                        self.selected_tool_idx = Some(i);
                        self.arg_inputs = vec!["".to_string(); self.tools[i].required_args.len()];
                        // Populate defaults
                        for (idx, arg) in self.tools[i].required_args.iter().enumerate() {
                            if let ArgType::String { default, .. } = arg {
                                self.arg_inputs[idx] = default.clone();
                            }
                        }
                    }
                });
            });

        // Central Panel (Input & Output)
        egui::CentralPanel::default()
            .frame(egui::Frame::none().fill(Color32::from_rgb(10, 12, 18)).inner_margin(12.0))
            .show(ctx, |ui| {
                
                if let Some(tool_idx) = self.selected_tool_idx {
                    let tool = self.tools[tool_idx].clone();
                    
                    ui.group(|ui| {
                        ui.heading(RichText::new(format!("Configure: {}", tool.name)).color(Color32::from_rgb(0, 217, 255)));
                        ui.add_space(8.0);
                        
                        for (i, arg) in tool.required_args.iter().enumerate() {
                            match arg {
                                ArgType::String { label, .. } => {
                                    ui.horizontal(|ui| {
                                        ui.label(format!("{}: ", label));
                                        ui.text_edit_singleline(&mut self.arg_inputs[i]);
                                    });
                                }
                                ArgType::Select { label, options, .. } => {
                                    ui.horizontal(|ui| {
                                        ui.label(format!("{}: ", label));
                                        egui::ComboBox::from_id_source(i)
                                            .selected_text(&self.arg_inputs[i])
                                            .show_ui(ui, |ui| {
                                                for opt in options {
                                                    ui.selectable_value(&mut self.arg_inputs[i], opt.clone(), opt);
                                                }
                                            });
                                    });
                                }
                            }
                            ui.add_space(4.0);
                        }

                        ui.add_space(8.0);
                        ui.horizontal(|ui| {
                            if self.is_running {
                                if ui.button(RichText::new("STOP").color(Color32::from_rgb(255, 84, 112))).clicked() {
                                    self.process_manager.stop();
                                }
                            } else {
                                if ui.button(RichText::new("RUN").color(Color32::from_rgb(77, 255, 145))).clicked() {
                                    self.output_buffer.clear();
                                    self.output_buffer.push((format!("$ {} ...", tool.program), Color32::from_rgb(141, 149, 179)));
                                    
                                    let args = (tool.build_args)(&self.arg_inputs);
                                    self.is_running = true;
                                    self.process_manager.spawn(tool.program, args);
                                }
                            }
                            if ui.button("CLEAR").clicked() {
                                self.output_buffer.clear();
                            }
                            ui.checkbox(&mut self.auto_scroll, "Auto-scroll");
                        });
                    });
                    
                    ui.add_space(12.0);
                    ui.separator();
                    ui.add_space(12.0);
                } else {
                    ui.label("Select a tool from the left panel.");
                }

                // Output Terminal
                let scroll = ScrollArea::vertical()
                    .stick_to_bottom(self.auto_scroll)
                    .auto_shrink([false, false]);
                
                scroll.show(ui, |ui| {
                    ui.style_mut().override_text_style = Some(egui::TextStyle::Monospace);
                    for (line, color) in &self.output_buffer {
                        ui.label(RichText::new(line).color(*color));
                    }
                });
            });
    }
}
