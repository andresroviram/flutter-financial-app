#!/bin/bash
# Script para configurar archivos web necesarios para Drift
# Ejecutar desde la raíz del workspace: ./scripts/setup_web.sh

set -e

SQLITE3_VERSION="2.4.6"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SQLITE3_URL="https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-$SQLITE3_VERSION/sqlite3.wasm"

setup_app() {
    local APP_DIR="$1"
    local APP_NAME="$2"

    echo "Configurando Drift Web Support para $APP_NAME..."
    echo ""

    cd "$SCRIPT_DIR/../$APP_DIR"
    mkdir -p web

    echo "1. Descargando sqlite3.wasm v$SQLITE3_VERSION..."
    if curl -L -o "web/sqlite3.wasm" "$SQLITE3_URL"; then
        echo "   ✓ sqlite3.wasm descargado"
    else
        echo "   ✗ Error al descargar para $APP_NAME"
        exit 1
    fi

    echo ""
    echo "2. Compilando drift_worker.dart.js..."
    echo "   (esto puede tardar ~30 segundos)"

    if dart compile js -O1 -o web/drift_worker.dart.js web/drift_worker.dart; then
        echo "   ✓ drift_worker.dart.js compilado para $APP_NAME"
    else
        echo "   ✗ Error al compilar para $APP_NAME"
        exit 1
    fi

    echo ""
    echo "✓ $APP_NAME configurado!"
    echo ""
}

setup_app "apps/client-app" "client-app"
setup_app "apps/financial-app" "financial-app"

echo "Ahora puedes ejecutar:"
echo "  flutter run -d chrome"
echo "  flutter build web --release"
