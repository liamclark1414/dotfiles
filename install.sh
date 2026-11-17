#!/usr/bin/env bash
# Link these dotfiles into place. Anything already there is moved aside to *.pre-dotfiles.
# Usage: ~/dotfiles/install.sh
set -e
D="$(cd "$(dirname "$0")" && pwd)"
C="${XDG_CONFIG_HOME:-$HOME/.config}"

link() {   # link <source in repo> <destination>
    local src="$D/$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then echo "  ok      $dst"; return; fi
    if [ -e "$dst" ] || [ -L "$dst" ]; then mv "$dst" "$dst.pre-dotfiles"; echo "  backup  $dst.pre-dotfiles"; fi
    ln -s "$src" "$dst"; echo "  linked  $dst"
}

echo "Linking dotfiles from $D"
for app in hypr kitty waybar rofi fastfetch nvim; do link "$app" "$C/$app"; done
link starship/starship.toml           "$C/starship.toml"
link gtk/gtk-4.0/gtk-middle-earth.css "$C/gtk-4.0/gtk-middle-earth.css"
link gtk/themes/Middle-earth          "$HOME/.themes/Middle-earth"
link autostart/session-look-gnome.desktop "$C/autostart/session-look-gnome.desktop"
ln -sfn "$C/gtk-4.0/middle-earth-colors.css" "$D/gtk/gtk-4.0/middle-earth-colors.css"

# the default place, so everything has colours before the first workspace switch
[ -e "$D/kitty/current-theme.conf" ] || ln -s themes/bag_end.conf "$D/kitty/current-theme.conf"

# the welcome screen hook
grep -q 'dotfiles/bash/middle-earth.sh' "$HOME/.bashrc" 2>/dev/null || cat >> "$HOME/.bashrc" <<'RC'

# Middle-earth welcome screen (kept in ~/dotfiles)
[ -f ~/dotfiles/bash/middle-earth.sh ] && . ~/dotfiles/bash/middle-earth.sh
RC

# the gold cursor is generated, not stored
[ -d "$HOME/.local/share/icons/Bibata-Modern-Gold" ] || {
    if [ -d /usr/share/icons/Bibata-Modern-Amber ]; then
        python3 "$D/hypr/scripts/make-gold-cursor.py"
        mkdir -p "$HOME/.icons" && ln -sfn "$HOME/.local/share/icons/Bibata-Modern-Gold" "$HOME/.icons/Bibata-Modern-Gold"
    else
        echo "  note    install bibata-cursor-theme, then re-run for the gold cursor"
    fi
}
echo "Done. Log into Hyprland to see it."
