# Hyprland Wallpaper Dashboard

A Bash-only visual wallpaper picker for Hyprland, `awww`, Rofi, and Mako. It applies one wallpaper to every monitor, persists the active path, and caches 16:9 Rofi thumbnails.

## Install

Dependencies on Arch Linux:

```sh
sudo pacman -S awww rofi-wayland imagemagick libnotify xdg-utils
```

Create the source directory and add images:

```sh
mkdir -p ~/Pictures/Wallpapers
```

The Hyprland integration is installed in `~/.config/hypr/hyprland.conf` and `~/.config/hypr/keybinds.conf`. Reload the configuration with `hyprctl reload`, then use `SUPER + W`.

## Commands

```sh
~/.config/hypr/wallpaper/picker.sh
~/.config/hypr/wallpaper/random.sh
~/.config/hypr/wallpaper/next.sh
~/.config/hypr/wallpaper/previous.sh
~/.config/hypr/wallpaper/apply.sh ~/Pictures/Wallpapers/example.jpg
```

Only `apply.sh` invokes `awww`. It first validates the file and daemon, atomically writes `~/.cache/wallpaper/current`, and sends a notification.

## Configuration

Edit `config.sh` to change the source folder, thumbnail size, or file manager command. Wallpaper changes are immediate through `awww img`.

The picker accepts PNG, JPG, JPEG, and WebP files recursively. It sorts paths with `LC_ALL=C`, so next/previous ordering is stable. Duplicated names are shown with their relative path, and thumbnail cache paths mirror the source directory to avoid collisions. Delete `~/.cache/wallpaper/thumbnails` to force a clean thumbnail rebuild.

## Troubleshooting

- **Daemon unavailable:** ensure `awww-daemon` is running; it is started once by the Hyprland config.
- **No entries:** add readable supported images under `~/Pictures/Wallpapers`.
- **Slow first picker open:** ImageMagick must generate each thumbnail once. Subsequent opens reuse the cache; changed images regenerate automatically.

## Quality and extensions

Run ShellCheck with:

```sh
shellcheck ~/.config/hypr/wallpaper/*.sh ~/.config/hypr/wallpaper/lib/*.sh
```

The shared library centralizes inventory, state, cache, and notification behavior. Future favorites, tags, histories, categories, multi-monitor targets, preview panes, and scheduled switching can build on this inventory/state boundary without adding `awww` calls outside `apply.sh`.
