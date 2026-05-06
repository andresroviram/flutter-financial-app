# Script para configurar archivos web necesarios para Drift

$SQLITE3_VERSION = "2.4.6"

Write-Host "Configurando Drift Web Support..." -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path "web")) {
    New-Item -ItemType Directory -Path "web" | Out-Null
}

# Descargar sqlite3.wasm
$SQLITE3_URL = "https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-$SQLITE3_VERSION/sqlite3.wasm"

Write-Host "1. Descargando sqlite3.wasm v$SQLITE3_VERSION..." -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri $SQLITE3_URL -OutFile "web\sqlite3.wasm" -ErrorAction Stop
    Write-Host "   ✓ sqlite3.wasm descargado" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Error: $_" -ForegroundColor Red
    exit 1
}

# Compilar worker
Write-Host ""
Write-Host "2. Compilando drift_worker.dart.js..." -ForegroundColor Yellow
Write-Host "   (esto puede tardar ~30 segundos)" -ForegroundColor Gray

try {
    $null = dart run build_runner build --delete-conflicting-outputs -o web:build_web 2>&1
    if (Test-Path "build_web\drift_worker.dart.js") {
        Copy-Item "build_web\drift_worker.dart.js" -Destination "web\drift_worker.dart.js" -Force
        $size = [math]::Round((Get-Item "web\drift_worker.dart.js").Length / 1KB, 2)
        Write-Host "   ✓ drift_worker.dart.js compilado ($size KB)" -ForegroundColor Green
    } else {
        throw "No se generó el archivo worker"
    }
} catch {
    Write-Host "   ✗ Error al compilar: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✓ Configuración completa!" -ForegroundColor Green
Write-Host ""
Write-Host "Ahora puedes ejecutar:" -ForegroundColor Cyan
Write-Host "  flutter run -d chrome" -ForegroundColor White
Write-Host "  flutter build web --release" -ForegroundColor White
