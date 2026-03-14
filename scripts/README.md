# Scripts de Utilidad

Esta carpeta contiene scripts de utilidad para el proyecto Flutter.

## 📊 Scripts de Cobertura

### check_coverage.ps1 / check_coverage.sh

Ejecuta tests con cobertura y verifica que cumplan un umbral mínimo.

**Windows:**
```powershell
.\scripts\check_coverage.ps1              # Umbral: 60%
.\scripts\check_coverage.ps1 -Threshold 70 # Umbral personalizado
.\scripts\check_coverage.ps1 -App financial-app # Ejecuta cobertura para financial-app
.\scripts\check_coverage.ps1 -App all -Threshold 70 # Ejecuta ambas apps con umbral 70%
```

**Linux/Mac:**
```bash
chmod +x scripts/check_coverage.sh
./scripts/check_coverage.sh               # Umbral: 60%
./scripts/check_coverage.sh 70            # Umbral personalizado
./scripts/check_coverage.sh financial-app # Ejecuta cobertura para financial-app
./scripts/check_coverage.sh all 70        # Ejecuta ambas apps con umbral 70%
```

**Funcionalidades de `check_coverage.sh`:**
- ✅ Ejecuta `flutter test --coverage`
- ✅ Soporta `client-app`, `financial-app` o ambas
- ✅ Calcula el porcentaje de cobertura
- ✅ Compara contra un umbral mínimo
- ✅ Genera reporte HTML (si lcov está instalado)
- ✅ Falla si la cobertura está por debajo del umbral

## 🌐 Scripts de Configuración Web

### setup_web.ps1 / setup_web.sh

Configura los archivos necesarios para el soporte web de Drift (SQLite).

**Windows:**
```powershell
.\scripts\setup_web.ps1
```

**Linux/Mac:**
```bash
chmod +x scripts/setup_web.sh
./scripts/setup_web.sh
```

**Funcionalidades:**
- ✅ Descarga `sqlite3.wasm` desde GitHub
- ✅ Compila `drift_worker.dart.js` con build_runner
- ✅ Copia los archivos a la carpeta `web/`
- ✅ Verifica que todo esté configurado correctamente

**Cuándo usar:**
- Después de clonar el repositorio
- Antes de ejecutar la app en web por primera vez
- Si `drift_worker.dart.js` falta o está desactualizado
- Después de actualizar dependencias de Drift

## 📝 Notas

- Todos los scripts están diseñados para ejecutarse desde la **raíz del workspace**
- `check_coverage.sh` usa `apps/client-app` por defecto, pero acepta `financial-app` o `all`
- Los scripts Bash (.sh) requieren permisos de ejecución: `chmod +x scripts/*.sh`
- Los scripts PowerShell (.ps1) pueden requerir ajustar la política de ejecución en Windows
