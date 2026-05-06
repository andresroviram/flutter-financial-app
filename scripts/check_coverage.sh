#!/bin/bash

# Script para verificar cobertura de tests
# Uso: ./scripts/check_coverage.sh [threshold]

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Navegar a la app principal
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../apps/client-app"

echo -e "${BLUE}🧪 Ejecutando tests con cobertura...${NC}"
flutter test --coverage

if [ ! -f coverage/lcov.info ]; then
    echo -e "${RED}❌ Error: No se generó el archivo de cobertura${NC}"
    exit 1
fi

echo -e "\n${BLUE}📊 Generando reporte HTML...${NC}"
if command -v genhtml &> /dev/null; then
    genhtml coverage/lcov.info -o coverage/html
    echo -e "${GREEN}✓ Reporte HTML generado en coverage/html/index.html${NC}"
else
    echo -e "${YELLOW}⚠ genhtml no está instalado. Instálalo con: sudo apt-get install lcov${NC}"
fi

# Calcular cobertura
if command -v lcov &> /dev/null; then
    echo -e "\n${BLUE}📈 Análisis de cobertura:${NC}"
    lcov --summary coverage/lcov.info
    
    # Extraer porcentaje
    COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | awk '{print $2}' | sed 's/%//')
    THRESHOLD=${1:-60.0}
    
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}Cobertura actual:${NC} ${COVERAGE}%"
    echo -e "${BLUE}Umbral mínimo:${NC} ${THRESHOLD}%"
    
    # Comparar con umbral
    if (( $(echo "$COVERAGE < $THRESHOLD" | bc -l) )); then
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${RED}❌ FALLO: Cobertura ${COVERAGE}% por debajo del umbral ${THRESHOLD}%${NC}"
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        exit 1
    else
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}✅ ÉXITO: Cobertura ${COVERAGE}% cumple el umbral ${THRESHOLD}%${NC}"
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    fi
else
    echo -e "${YELLOW}⚠ lcov no está instalado. Instálalo con: sudo apt-get install lcov${NC}"
    echo -e "${GREEN}✓ Tests ejecutados correctamente${NC}"
fi

echo -e "\n${BLUE}💡 Tip: Abre coverage/html/index.html en tu navegador para ver el reporte detallado${NC}"
