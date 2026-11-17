# Middle-earth dotfiles

A Lord of the Rings rice for Hyprland on Ubuntu. Every workspace is a place in
Middle-earth, and the whole desktop restyles itself when you travel between them.

| Workspace | Place | Mood |
|---|---|---|
| 1 | Bag End | elven green, sunflower gold |
| 2 | Bree | timber brown, terracotta roofs |
| 3 | Rivendell | storm grey, autumn gold, waterfall mist |
| 4 | Moria | teal abyss, torchlight |
| 5 | Lórien | indigo twilight, glowing moss |

## What's here

| Folder | What |
|---|---|
| `hypr/` | Hyprland, hyprpaper, hyprlock ("Speak, friend, and enter"), hypridle, and `scripts/` |
| `hypr/scripts/workspace-theme.sh` | the heart of it: per-place wallpaper, kitty, Waybar, Rofi, mako, GTK, lock screen, borders |
| `hypr/scripts/session-look.sh` | Middle-earth GTK/icons/cursor in Hyprland, your normal look in GNOME |
| `kitty/` | terminal config; `themes/` holds one palette per place (the source of every colour) |
| `waybar/` | the top bar, workspaces named after places |
| `rofi/` | app launcher |
| `fastfetch/` | welcome screen: the White Tree of Gondor and a quote of lore |
| `starship/` | prompt ("you shall not pass" on errors) |
| `nvim/` | Neovim colorscheme that follows the current place |
| `gtk/` | GTK3/GTK4 theme for apps inside Hyprland |
| `bash/` | the welcome-screen hook sourced from `~/.bashrc` |

## Install

```sh
sudo apt install hyprland hyprland-qtutils hyprpaper hyprlock hypridle waybar rofi \
    kitty fastfetch starship mako-notifier socat papirus-icon-theme bibata-cursor-theme
git clone <this repo> ~/dotfiles && ~/dotfiles/install.sh
```

Wallpapers are not included: put `bag_end.jpg`, `bree.jpg`, `rivendell.jpg`,
`moria.jpg`, `lorien.jpg` and `lotr_desktop_wallpaper_2.jpg` in `~/Pictures`.

To change a place's colours, edit `kitty/themes/<place>.conf`; everything else follows.
