# TV OSD - Sistema de On-Screen Display estilo CRT de los 90

Un sistema OSD (On-Screen Display) ligero para bspwm que imita la estética de los televisores CRT de los años 90. Muestra información de cambio de escritorio (canales), control de volumen, mute, brillo y nivel de batería.

## Características

- **Estilo CRT verde clásico**: Texto verde fosforescente estilo terminal antiguo.
- **Usa dunst**: Para notificaciones con estilo retro (no osd_cat, que no escala bien fuentes TrueType).
- **Barras de volumen y brillo**: Usa `▰` (bloque lleno) y `▱` (bloque claro) para mejor visibilidad.
- **Control de brillo**: F9/F10 con brightnessctl + sudo sin contraseña.
- **Indicador de batería**: Icono con porcentaje en el OSD de escritorio.
- **Script único y ligero**: Un solo script bash que maneja todas las funcionalidades.

## Funcionalidades

### 1. Cambio de escritorio (CANAL)

- Muestra icono de batería, icono de TV y número de escritorio.
- Se muestra automáticamente al cambiar de escritorio.
- Formato: `B 41%  TV 01`

### 2. Control de volumen

- Teclas: `XF86AudioRaiseVolume`, `XF86AudioLowerVolume`.
- Barra: `󰖀 ▰▰▰▰▱▱▱▱ 75%` (▰ lleno, ▱ vacío).
- Límite máximo: 150%.

### 3. Mute toggle

- Tecla: `XF86AudioMute`.
- Muestra "🔇 MUTE" en rojo cuando está activo.

### 4. Control de brillo

- Teclas: F9 (bajar), F10 (subir).
- Barra: `☀️ ▰▰▰▰▱▱▱▱ 60%` (▰ lleno, ▱ vacío).
- Usa brightnessctl + sudo sin contraseña.

### 5. Batería

- Se muestra en el OSD de escritorio.
- Iconos con 10 niveles de batería (Nerd Fonts).

## Instalación

### Dependencias

- `bspwm`, `sxhkd` - Gestor de ventanas y atajos.
- `dunst`, `dunstify` - Demonio de notificaciones.
- `pactl` - Control de volumen (PulseAudio).
- `brightnessctl` - Control de brillo.
- `sudo` - Para brightnessctl sin contraseña.

### Configurar sudo para brightnessctl

```bash
echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/brightnessctl" | sudo tee /etc/sudoers.d/brightnessctl
```

### Configurar dunst

Crear `~/.config/dunst/dunstrc` con estilo CRT (fondo negro, borde verde, fuente Meslo).

### Atajos de teclado

En `sxhkdrc`:

- `XF86AudioRaiseVolume` / `XF86AudioLowerVolume` - Volumen.
- `XF86AudioMute` - Mute.
- `F9` - Bajar brillo.
- `F10` - Subir brillo.

## Archivos

- `bspwm/scripts/bspwm_osd.sh` - Script principal OSD.
- `sxhkd/sxhkdrc` - Configuración de atajos.
- `~/.config/dunst/dunstrc` - Configuración de dunst.

## Solución de problemas

ninguno.

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
