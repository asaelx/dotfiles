/bin/bash -c 'set -euo pipefail

echo "Desinstalando fórmulas Homebrew relacionadas con transmission..."
brew uninstall --force --zap transmission transmission-cli transmission-daemon 2>/dev/null || true
brew cleanup -s || true
brew autoremove || true

echo "Descargando/descargando launch agents/daemons relacionados (si existen)..."
launchctl remove org.m0k.transmission 2>/dev/null || true
[ -f "$HOME/Library/LaunchAgents/org.m0k.transmission.plist" ] && launchctl unload "$HOME/Library/LaunchAgents/org.m0k.transmission.plist" 2>/dev/null || true
sudo launchctl unload /Library/LaunchDaemons/org.m0k.transmission.plist 2>/dev/null || true || true

echo "Eliminando archivos de configuración, cachés y datos (directorios comunes)..."
rm -rf \
  "$HOME/Library/Application Support/Transmission" \
  "$HOME/Library/Application Support/Transmission/Torrents" \
  "$HOME/Library/Application Support/Transmission/resume" \
  "$HOME/Library/Application Support/Transmission/blocklist.dat" \
  "$HOME/Library/Preferences/org.m0k.transmission.plist" \
  "$HOME/Library/Caches/org.m0k.transmission" \
  "$HOME/.config/transmission" \
  "$HOME/.config/transmission-daemon" \
  "$HOME/.transmission" \
  "$HOME/Downloads/"*.torrent 2>/dev/null || true

echo "Eliminando posibles enlaces y cachés de Homebrew..."
rm -rf /usr/local/var/homebrew/linked/transmission* 2>/dev/null || true
rm -rf /opt/homebrew/var/homebrew/linked/transmission* 2>/dev/null || true
rm -rf "$(brew --cache 2>/dev/null)/transmission"* 2>/dev/null || true

echo "Eliminando plist en /Library si existe (requiere sudo)..."
sudo rm -f /Library/LaunchDaemons/org.m0k.transmission.plist 2>/dev/null || true
sudo rm -f /Library/LaunchAgents/org.m0k.transmission.plist 2>/dev/null || true

echo "Hecho. Transmission (binarios, configs y datos comunes) eliminado."
'
