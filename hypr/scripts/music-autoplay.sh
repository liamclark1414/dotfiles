#!/usr/bin/env bash
# Play your local music on login: everything in ~/Music (sub-folders too),
# shuffled, looping forever, no window, resuming where you left off.
# Control it with playerctl (Super+M).
MUSIC="${MUSIC_DIR:-$HOME/Music}"
pgrep -f 'mpv .*--title=middle-earth-music' >/dev/null && exit 0

# nothing downloaded yet? stay quiet
find "$MUSIC" -type f \( -iname '*.mp3' -o -iname '*.flac' -o -iname '*.ogg' -o -iname '*.opus' \
    -o -iname '*.m4a' -o -iname '*.wav' -o -iname '*.aac' \) -print -quit 2>/dev/null | grep -q . || exit 0

exec mpv --title=middle-earth-music --no-video --no-terminal --force-window=no \
    --shuffle --loop-playlist=inf --volume=60 \
    --save-position-on-quit --watch-later-options=start \
    --input-ipc-server="$XDG_RUNTIME_DIR/mpv-music.sock" \
    "$MUSIC"
