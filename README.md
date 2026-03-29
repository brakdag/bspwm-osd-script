# TV OSD - Sistema de On-Screen Display estilo CRT de los 90

Un sistema OSD (On-Screen Display) ligero para bspwm que imita la estética de los televisores CRT de los años 90. Muestra información de cambio de escritorio (canales), control de volumen, mute, brillo y nivel de batería.

## Características

- **Estilo CRT verde clásico**: Texto verde fosforescente estilo terminal antiguo.
- **Usa dunst**: Para notificaciones con estilo retro (no osd_cat, que no escala bien fuentes TrueType).
- **Barras de volumen y brillo**: Usa `▰` (bloque lleno) y `▱` (bloque claro) para mejor visibilidad.
- **Control de brillo**: F9/F10 con `brightnessctl` (sin `sudo` mediante regla Udev).
...
### 4. Control de brillo

- Teclas: F9 (bajar), F10 (subir).
- Barra: `☀️ ▰▰▰▰▱▱▱▱ 60%` (▰ lleno, ▱ vacío).
- Configuración: Permisos mediante regla Udev para evitar `sudo`.

...
### Configurar permisos para brightnessctl (Sin sudo)

Crear `/etc/udev/rules.d/99-backlight.rules`:

```bash
ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
```

Asegurarse de que tu usuario pertenece al grupo `video`.

...
## Archivos

- `bspwm/scripts/bspwm_osd.sh` - Script principal OSD.
- `bspwm/scripts/osd.conf` - Configuración externa.
- `sxhkd/sxhkdrc` - Configuración de atajos.
- `~/.config/dunst/dunstrc` - Configuración de dunst.


## Solución de problemas

Ninguno que solucionar.

### Brillo no funciona

1. Verificar regla sudo: `cat /etc/sudoers.d/brightnessctl`
2. Probar manualmente: `sudo brightnessctl set 100`

### OSD no aparece

1. Matar otros demonios: `killall xfce4-notifyd`
2. Verificar dunst: `pgrep dunst`

### Atajos no responden

```bash
pkill -USR1 -x sxhkd
```

### Daemon no funciona

```bash
pkill -f bspwm_osd.sh
~/.config/bspwm/scripts/bspwm_osd.sh &
```
