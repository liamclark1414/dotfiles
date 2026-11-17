#!/usr/bin/env bash
# Shown when a kitty terminal opens: fastfetch, then a random line of lore.
FF="$HOME/.config/fastfetch"
command -v fastfetch >/dev/null && fastfetch
q="$(shuf -n1 "$FF/quotes.txt")"
printf '\n  \e[3;33m“%s”\e[0m\n  \e[90m    — %s\e[0m\n' "${q%%|*}" "${q##*|}"
