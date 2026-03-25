#!/bin/bash

# ==============================================================================
# OSD script estilo CRT de los 90 para bspwm
# ==============================================================================

# --- Configuración ---
BATTERY_PATH="/sys/class/power_supply/axp288_fuel_gauge"
MAX_BRIGHTNESS=1200
BRIGHTNESS_STEP=50
MAX_VOLUME=150
DURATION_MS=2000
BAR_LENGTH=8

# Colores (reservados para uso futuro si se desea extender)
GREEN="#00FF00"
AMBER="#FFAA00"
RED="#FF0000"

# --- Dependencias ---
check_deps() {
    local deps=("pactl" "brightnessctl" "dunstify" "bspc")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo "Error: $dep no instalado." >&2
            exit 1
        fi
    done
}
check_deps

# --- Módulos ---

# Barra de brillo
create_brightness_bar() {
    local bri="$1"
    local blocks=$(( bri * BAR_LENGTH / MAX_BRIGHTNESS ))
    [ "$blocks" -lt 0 ] && blocks=0
    [ "$blocks" -gt "$BAR_LENGTH" ] && blocks=$BAR_LENGTH
    
    local bar=""
    for ((i=0; i<blocks; i++)); do bar+="▰"; done
    for ((i=blocks; i<BAR_LENGTH; i++)); do bar+="▱"; done
    printf "☀️ %s %3d%%" "$bar" "$((bri / 10))"
}

# Barra de volumen
create_volume_bar() {
    local vol="$1"
    local blocks=$(( vol * BAR_LENGTH / MAX_VOLUME ))
    [ "$blocks" -lt 0 ] && blocks=0
    [ "$blocks" -gt "$BAR_LENGTH" ] && blocks=$BAR_LENGTH
    
    local bar=""
    for ((i=0; i<blocks; i++)); do bar+="▰"; done
    for ((i=blocks; i<BAR_LENGTH; i++)); do bar+="▱"; done
    printf "󰖀 %s %3d%%" "$bar" "$vol"
}

# Funciones de control
volume_up() {
    pactl set-sink-mute @DEFAULT_SINK@ 0
    pactl set-sink-volume @DEFAULT_SINK@ +5%
    local vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1)
    [ "$vol" -gt "$MAX_VOLUME" ] && vol="$MAX_VOLUME"
    dunstify -r 3 -u normal -t "$DURATION_MS" "$(create_volume_bar "$vol")"
}

volume_down() {
    pactl set-sink-mute @DEFAULT_SINK@ 0
    pactl set-sink-volume @DEFAULT_SINK@ -5%
    local vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1)
    [ "$vol" -lt 0 ] && vol=0
    dunstify -r 3 -u normal -t "$DURATION_MS" "$(create_volume_bar "$vol")"
}

mute_toggle() {
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    sleep 0.2
    local mute=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -oP '(sí|no)')
    if [ "$mute" = "sí" ]; then
        dunstify -r 3 -u critical -t "$DURATION_MS" "🔇 MUTE"
    else
        local vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1)
        dunstify -r 3 -u normal -t "$DURATION_MS" "$(create_volume_bar "$vol")"
    fi
}

brightness_up() {
    local bri=$(brightnessctl get)
    local new_bri=$((bri + BRIGHTNESS_STEP))
    [ "$new_bri" -gt "$MAX_BRIGHTNESS" ] && new_bri="$MAX_BRIGHTNESS"
    sudo brightnessctl set "$new_bri"
    dunstify -r 4 -u normal -t "$DURATION_MS" "$(create_brightness_bar "$new_bri")"
}

brightness_down() {
    local bri=$(brightnessctl get)
    local new_bri=$((bri - BRIGHTNESS_STEP))
    [ "$new_bri" -lt 0 ] && new_bri=0
    sudo brightnessctl set "$new_bri"
    dunstify -r 4 -u normal -t "$DURATION_MS" "$(create_brightness_bar "$new_bri")"
}

# Batería
get_battery_icon() {
    local cap=$(cat "$BATTERY_PATH/capacity" 2>/dev/null || echo 0)
    
    if [ "$cap" -le 10 ]; then echo " $cap%"
    elif [ "$cap" -le 20 ]; then echo " $cap%"
    elif [ "$cap" -le 30 ]; then echo " $cap%"
    elif [ "$cap" -le 40 ]; then echo " $cap%"
    elif [ "$cap" -le 50 ]; then echo " $cap%"
    elif [ "$cap" -le 60 ]; then echo " $cap%"
    elif [ "$cap" -le 70 ]; then echo " $cap%"
    elif [ "$cap" -le 80 ]; then echo " $cap%"
    elif [ "$cap" -le 90 ]; then echo " $cap%"
    else echo " $cap%"
    fi
}

# Desktop
desktop_change() {
    local did="$1"
    local num=$(bspc query -D -d "$did" --names)
    local battery=$(get_battery_icon)
    local glyph
    case "$num" in
        1) glyph="➊" ;; 2) glyph="➋" ;; 3) glyph="➌" ;;
        4) glyph="➍" ;; 5) glyph="➎" ;; 6) glyph="➏" ;;
        7) glyph="➐" ;; 8) glyph="➑" ;; 9) glyph="➒" ;;
        10) glyph="❿" ;;
        *) glyph="$num" ;;
    esac
    dunstify -r 1 -u normal -t "$DURATION_MS" "$battery  $glyph"
}

# Daemon
start_daemon() {
    bspc subscribe desktop_focus | while read -r _ _ did; do
        desktop_change "$did"
    done
}

# Args
case "${1:-}" in
    volume-up)   volume_up ;;
    volume-down) volume_down ;;
    mute)        mute_toggle ;;
    brightness-up)   brightness_up ;;
    brightness-down) brightness_down ;;
    *)           start_daemon ;;
esac
