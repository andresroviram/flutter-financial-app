#!/bin/bash

# Script para verificar cobertura de tests.
# Uso:
#   ./scripts/check_coverage.sh [threshold]
#   ./scripts/check_coverage.sh [app] [threshold]
#   ./scripts/check_coverage.sh --app <client-app|financial-app|all> [threshold]

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/.."
DEFAULT_THRESHOLD="60.0"
AVAILABLE_APPS=("client-app" "financial-app")

usage() {
    cat <<EOF
Uso:
  ./scripts/check_coverage.sh [threshold]
  ./scripts/check_coverage.sh [app] [threshold]
  ./scripts/check_coverage.sh --app <client-app|financial-app|all> [threshold]

Ejemplos:
  ./scripts/check_coverage.sh
  ./scripts/check_coverage.sh 70
  ./scripts/check_coverage.sh financial-app
  ./scripts/check_coverage.sh financial-app 75
  ./scripts/check_coverage.sh --app all 70

Notas:
  - Si no se indica app, se usa client-app para mantener compatibilidad.
  - Puedes usar all para ejecutar cobertura en ambas apps.
EOF
}

is_number() {
    [[ "$1" =~ ^[0-9]+([.][0-9]+)?$ ]]
}

normalize_app() {
    case "$1" in
        client-app|client|client_app)
            echo "client-app"
            ;;
        financial-app|financial|financial_app)
            echo "financial-app"
            ;;
        all|both|ambas)
            echo "all"
            ;;
        *)
            return 1
            ;;
    esac
}

add_app() {
    local app="$1"
    local existing_app

    for existing_app in "${TARGET_APPS[@]}"; do
        if [ "$existing_app" = "$app" ]; then
            return
        fi
    done

    TARGET_APPS+=("$app")
}

is_below_threshold() {
    local coverage="$1"
    local threshold="$2"

    awk -v coverage="$coverage" -v threshold="$threshold" 'BEGIN { exit !(coverage < threshold) }'
}

run_coverage_for_app() {
    local app="$1"
    local threshold="$2"
    local app_dir="$ROOT_DIR/apps/$app"
    local coverage_file="$app_dir/coverage/lcov.info"
    local html_dir="$app_dir/coverage/html"
    local coverage

    if [ ! -d "$app_dir" ]; then
        echo -e "${RED}❌ Error: La app $app no existe en apps/${NC}"
        return 1
    fi

    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}🧪 Ejecutando tests con cobertura para:${NC} $app"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    (
        cd "$app_dir"
        flutter test --coverage
    )

    if [ ! -f "$coverage_file" ]; then
        echo -e "${RED}❌ Error: No se generó el archivo de cobertura para $app${NC}"
        return 1
    fi

    echo -e "\n${BLUE}📊 Generando reporte HTML para ${app}...${NC}"
    if command -v genhtml &> /dev/null; then
        genhtml "$coverage_file" -o "$html_dir" >/dev/null
        echo -e "${GREEN}✓ Reporte HTML generado en apps/${app}/coverage/html/index.html${NC}"
    else
        echo -e "${YELLOW}⚠ genhtml no está instalado. Instálalo con: sudo apt-get install lcov${NC}"
    fi

    if command -v lcov &> /dev/null; then
        echo -e "\n${BLUE}📈 Análisis de cobertura para ${app}:${NC}"
        lcov --summary "$coverage_file"

        coverage=$(lcov --summary "$coverage_file" 2>&1 | awk '/lines\.*:/ { gsub("%", "", $2); print $2; exit }')

        if [ -z "$coverage" ]; then
            echo -e "${RED}❌ Error: No se pudo calcular la cobertura para $app${NC}"
            return 1
        fi

        echo -e "\n${BLUE}Cobertura actual (${app}):${NC} ${coverage}%"
        echo -e "${BLUE}Umbral mínimo:${NC} ${threshold}%"

        if is_below_threshold "$coverage" "$threshold"; then
            echo -e "${RED}❌ FALLO: Cobertura ${coverage}% por debajo del umbral ${threshold}% en ${app}${NC}"
            return 1
        fi

        echo -e "${GREEN}✅ ÉXITO: Cobertura ${coverage}% cumple el umbral ${threshold}% en ${app}${NC}"
    else
        echo -e "${YELLOW}⚠ lcov no está instalado. Instálalo con: sudo apt-get install lcov${NC}"
        echo -e "${GREEN}✓ Tests ejecutados correctamente para ${app}${NC}"
    fi

    return 0
}

THRESHOLD="$DEFAULT_THRESHOLD"
TARGET_APPS=()

while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        -a|--app|--apps)
            shift

            if [ $# -eq 0 ]; then
                echo -e "${RED}❌ Error: Debes indicar una app después de --app${NC}"
                usage
                exit 1
            fi

            normalized_app=$(normalize_app "$1") || {
                echo -e "${RED}❌ Error: App no válida: $1${NC}"
                usage
                exit 1
            }

            if [ "$normalized_app" = "all" ]; then
                TARGET_APPS=("${AVAILABLE_APPS[@]}")
            else
                add_app "$normalized_app"
            fi
            ;;
        *)
            if is_number "$1"; then
                THRESHOLD="$1"
            else
                normalized_app=$(normalize_app "$1") || {
                    echo -e "${RED}❌ Error: Argumento no reconocido: $1${NC}"
                    usage
                    exit 1
                }

                if [ "$normalized_app" = "all" ]; then
                    TARGET_APPS=("${AVAILABLE_APPS[@]}")
                else
                    add_app "$normalized_app"
                fi
            fi
            ;;
    esac

    shift
done

if [ ${#TARGET_APPS[@]} -eq 0 ]; then
    TARGET_APPS=("client-app")
fi

OVERALL_STATUS=0

for app in "${TARGET_APPS[@]}"; do
    if ! run_coverage_for_app "$app" "$THRESHOLD"; then
        OVERALL_STATUS=1
    fi
done

if command -v genhtml &> /dev/null; then
    echo -e "\n${BLUE}💡 Tip: Abre el reporte HTML de cada app en apps/<app>/coverage/html/index.html${NC}"
fi

exit "$OVERALL_STATUS"
