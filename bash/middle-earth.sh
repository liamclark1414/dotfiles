# ~/dotfiles/bash/middle-earth.sh — sourced from ~/.bashrc
# Middle-earth welcome (only in interactive kitty terminals)
if [[ $- == *i* && $TERM == xterm-kitty && -z $MIDDLE_EARTH_WELCOMED ]]; then
    export MIDDLE_EARTH_WELCOMED=1
    ~/.config/fastfetch/welcome.sh
fi
