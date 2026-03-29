#!/usr/bin/env bash
# script: ~/.config/bspwm/scripts/quake_kitty.sh

CLASS="quake_kitty"
SOCK="/tmp/kitty_quake.sock"

# Buscar la ventana
WID=$(xdotool search --class "$CLASS" | tail -n 1)

if [ -n "$WID" ]; then
    # Alternar visibilidad
    bspc node "$WID" --flag hidden
    
    # Si la ventana ahora es visible, enfocarla y limpiarla
    if ! bspc query -N -n "$WID.hidden" > /dev/null; then
        bspc node "$WID" -f
        # Enviar comando de limpieza al socket de kitty (hex \x0c es Ctrl+L)
        kitty @ --to=unix:$SOCK send-text "\x0c"
    fi
fi

fi
