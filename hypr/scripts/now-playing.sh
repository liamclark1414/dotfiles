#!/usr/bin/env bash
# Pop up a notification with the current song (Super+Shift+M).
t="$(playerctl metadata --format '{{ title }}' 2>/dev/null)"
[ -z "$t" ] && { notify-send -u low "The halls are silent" "Nothing is playing."; exit; }
a="$(playerctl metadata --format '{{ artist }}' 2>/dev/null)"
s="$(playerctl status 2>/dev/null)"
notify-send -u low -h string:x-canonical-private-synchronous:now-playing \
    "$([ "$s" = Playing ] && echo '󰎈 Now playing' || echo '󰏤 Paused')" "<b>$t</b>${a:+\n$a}"
