#!/bin/bash

# Ruta base del caché de Telegram
TELEGRAM_CACHE_DIR="$HOME/Library/Group Containers/6N38VWS5BX.ru.keepcoder.Telegram/stable"

# Directorio de destino
DEST_DIR="$HOME/Downloads"

# Buscar y copiar archivos >= 2 MB que no sean stickers animados
echo "🔍 Buscando archivos de video en caché de Telegram..."

find "$TELEGRAM_CACHE_DIR" -type f -size +1M ! -name "*sticker*" | while read -r filepath; do
    filename=$(basename "$filepath")
    newname="${filename}.mp4"
    cp "$filepath" "$DEST_DIR/$newname"
    echo "✅ Copiado: $newname"
done

echo "🎉 Proceso terminado. Archivos copiados a ~/Downloads"
