#!/bin/bash
# Script para configurar archivos web necesarios para Drift
# Ejecutar desde la raíz del workspace: ./scripts/setup_web.sh

set -e

SQLITE3_VERSION="2.4.6"

# Navegar a la app principal
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../apps/app"

echo "Configurando Drift Web Support..."
echo ""

mkdir -p web

# Descargar sqlite3.wasm
SQLITE3_URL="https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-$SQLITE3_VERSION/sqlite3.wasm"

echo "1. Descargando sqlite3.wasm v$SQLITE3_VERSION..."
if curl -L -o "web/sqlite3.wasm" "$SQLITE3_URL"; then
    echo "   ✓ sqlite3.wasm descargado"
else
    echo "   ✗ Error al descargar"
    exit 1
fi

# Compilar worker
echo ""
echo "2. Compilando drift_worker.dart.js..."
echo "   (esto puede tardar ~30 segundos)"

if dart run build_runner build --delete-conflicting-outputs -o web:build_web > /dev/null 2>&1; then
    if [ -f "build_web/drift_worker.dart.js" ]; then
        cp "build_web/drift_worker.dart.js" "web/drift_worker.dart.js"
        echo "   ✓ drift_worker.dart.js compilado"
    else
        echo "   ✗ No se generó el archivo worker"
        exit 1
    fi
else
    echo "   ✗ Error al compilar"
    exit 1
fi

echo ""
echo "✓ Configuración completa!"
echo ""
echo "Ahora puedes ejecutar:"
echo "  flutter run -d chrome"
echo "  flutter build web --release"
