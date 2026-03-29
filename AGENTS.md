# Role and Goal

Eres un desarrollador experto en ricing de Linux (X11, bspwm, sxhkd). Tu tarea es implementar un sistema OSD (On Screen Display) estilo "televisor CRT de los 90" para indicar el cambio de escritorios (canales) y el control de volumen.

# Environment Context

Estás ejecutándote en un workspace que contiene enlaces simbólicos a las configuraciones reales del usuario:

- `./bspwm/` apunta a `~/.config/bspwm/`
- `./sxhkd/` apunta a `~/.config/sxhkd/`

# Discoveries

- `osd_cat` no escala bien fuentes TrueType - solo funciona con fuentes bitmap X11.
- Dunst requiere matar xfce4-notifyd para funcionar.
- Mutt toggle en español: "sí" en vez de "yes".
- brightnessctl necesita sudo sin contraseña (pkexec no funciona sin agente polkit gráfico).
- Barra de volumen/brillo con `▰` y `▱` es más legible que `#` y `-`.
- Iconos de batería Nerd Font: `` a `` (10 niveles).
- Icono TV Nerd Font: `` (Font Awesome).
- Glyphs de Nerd Fonts pueden no renderizar bien en Meslo Nerd Font.

# Accomplished

- Script `bspwm_osd.sh` implementado con módulos: volumen, mute, brillo, canal, batería.
- Refactorización a estructura modular con `osd.conf` para centralizar configuraciones.
- dunst configurado con estilo CRT (fondo negro, borde verde, fuente Meslo).
- Atajos de teclas multimedia en sxhkdrc.
- Control de brillo funcional con F9/F10 sin `sudo` mediante regla Udev.
- Enlaces simbólicos configurados para trabajar directamente en el repo.
- Barra de volumen: `▰` y `▱` con icono `🔊`.
- Barra de brillo: `▰` y `▱` con icono `☀️`.
- Indicador de batería con iconos Nerd Font.
- README.md y AGENTS.md actualizados.

# Relevant files

- `/mnt/DataSD/sandbox/tv_osd_workspace/bspwm/scripts/bspwm_osd.sh` - Script principal OSD.
- `/mnt/DataSD/sandbox/tv_osd_workspace/bspwm/scripts/osd.conf` - Configuración externa.
- `/mnt/DataSD/sandbox/tv_osd_workspace/sxhkd/sxhkdrc` - Atajos de teclado.
- `~/.config/dunst/dunstrc` - Configuración de dunst.

# Notes

- Para brillo funciona con sudo sin contraseña, no pkexec.
- Los emojis funcionan bien en dunst con fuentes Nerd Font.
- El sistema mute usa grep en español ("sí"/"no").
- Barra de volumen/brillo usa `▰` (lleno) y `▱` (vacío).
- Batería en sysfs: `/sys/class/power_supply/axp288_fuel_gauge/`.
- Glyphs Nerd Font de batería: `` (0-10%) hasta `` (90-100%).
- Glyph Nerd Font de TV: `` (Font Awesome).
