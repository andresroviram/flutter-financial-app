# Script para verificar cobertura de tests
# Uso: .\scripts\check_coverage.ps1 [threshold]

param(
    [decimal]$Threshold = 60.0
)

$ErrorActionPreference = "Stop"

# Navegar a la app principal
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location (Join-Path $ScriptDir "..\apps\app")

Write-Host "🧪 Ejecutando tests con cobertura..." -ForegroundColor Blue
flutter test --coverage

if (-not (Test-Path "coverage/lcov.info")) {
    Write-Host "❌ Error: No se generó el archivo de cobertura" -ForegroundColor Red
    exit 1
}

Write-Host "`n📊 Analizando cobertura..." -ForegroundColor Blue

# Leer archivo lcov.info y calcular cobertura
$content = Get-Content "coverage/lcov.info" -Raw
$lines = ($content | Select-String -Pattern "LF:(\d+)" -AllMatches).Matches | ForEach-Object { [int]$_.Groups[1].Value }
$linesHit = ($content | Select-String -Pattern "LH:(\d+)" -AllMatches).Matches | ForEach-Object { [int]$_.Groups[1].Value }

$totalLines = ($lines | Measure-Object -Sum).Sum
$totalLinesHit = ($linesHit | Measure-Object -Sum).Sum

if ($totalLines -eq 0) {
    Write-Host "❌ Error: No se pudo calcular la cobertura" -ForegroundColor Red
    exit 1
}

$coverage = [math]::Round(($totalLinesHit / $totalLines) * 100, 2)

Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
Write-Host "📈 Resumen de Cobertura:" -ForegroundColor Blue
Write-Host "   Total de líneas: $totalLines" -ForegroundColor Cyan
Write-Host "   Líneas cubiertas: $totalLinesHit" -ForegroundColor Cyan
Write-Host "   Líneas sin cubrir: $($totalLines - $totalLinesHit)" -ForegroundColor Cyan
Write-Host ""
Write-Host "   Cobertura actual: $coverage%" -ForegroundColor Cyan
Write-Host "   Umbral mínimo: $Threshold%" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue

if ($coverage -lt $Threshold) {
    Write-Host ""
    Write-Host "❌ FALLO: Cobertura $coverage% por debajo del umbral $Threshold%" -ForegroundColor Red
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Red
    exit 1
} else {
    Write-Host ""
    Write-Host "✅ ÉXITO: Cobertura $coverage% cumple el umbral $Threshold%" -ForegroundColor Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
}

Write-Host "`n💡 Tip: Usa 'flutter test --coverage && genhtml -o coverage/html coverage/lcov.info' para generar reporte HTML" -ForegroundColor Yellow
Write-Host "   (Requiere lcov instalado)" -ForegroundColor Yellow
