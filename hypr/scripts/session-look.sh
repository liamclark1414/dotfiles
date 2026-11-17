#!/usr/bin/env bash
# Apply the right desktop look for the session you just logged into.
#   session-look.sh hyprland   → Middle-earth (run by hyprland.conf exec-once)
#   session-look.sh gnome      → your GNOME setup (run by ~/.config/autostart, GNOME only)
# Settings like the GTK and icon theme are shared by both sessions, so each one sets its own at login.
G=org.gnome.desktop.interface
GTK4="$HOME/.config/gtk-4.0"

case "$1" in
  hyprland)
    gsettings set $G gtk-theme    'Middle-earth'
    gsettings set $G icon-theme   'Papirus-Dark'
    gsettings set $G cursor-theme 'Bibata-Modern-Gold'
    gsettings set $G color-scheme 'prefer-dark'
    ln -sfn gtk-middle-earth.css "$GTK4/gtk.css"
    ln -sfn gtk-middle-earth.css "$GTK4/gtk-dark.css"
    ;;
  gnome)
    gsettings set $G gtk-theme    'Orchis-Purple-Dark-Compact'
    gsettings set $G icon-theme   'Yaru-purple-dark'
    gsettings set $G cursor-theme 'default'
    gsettings set $G color-scheme 'prefer-dark'
    ln -sfn "$HOME/.themes/Orchis-Light/gtk-4.0/gtk.css"      "$GTK4/gtk.css"
    ln -sfn "$HOME/.themes/Orchis-Light/gtk-4.0/gtk-dark.css" "$GTK4/gtk-dark.css"
    ;;
  *) echo "usage: $0 hyprland|gnome" >&2; exit 1 ;;
esac
