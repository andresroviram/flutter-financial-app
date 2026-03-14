# Script para verificar cobertura de tests.
# Uso:
#   .\scripts\check_coverage.ps1
#   .\scripts\check_coverage.ps1 -Threshold 70
#   .\scripts\check_coverage.ps1 -App financial-app
#   .\scripts\check_coverage.ps1 -App all -Threshold 70

param(
    [Parameter(Position = 0)]
    [string]$App = "client-app",

    [Parameter(Position = 1)]
    [decimal]$Threshold = 60.0,

    [switch]$Help
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Join-Path $ScriptDir ".."
$AvailableApps = @("client-app", "financial-app")

function Show-Usage {
    Write-Host @"
Uso:
  .\scripts\check_coverage.ps1
  .\scripts\check_coverage.ps1 -Threshold 70
  .\scripts\check_coverage.ps1 -App financial-app
  .\scripts\check_coverage.ps1 -App financial-app -Threshold 75
  .\scripts\check_coverage.ps1 -App all -Threshold 70

Notas:
  - Si no se indica app, se usa client-app para mantener compatibilidad.
  - Puedes usar all para ejecutar cobertura en ambas apps.
"@
}

function Resolve-AppName {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    switch ($Name.ToLowerInvariant()) {
        "client-app" { return "client-app" }
        "client" { return "client-app" }
        "client_app" { return "client-app" }
        "financial-app" { return "financial-app" }
        "financial" { return "financial-app" }
        "financial_app" { return "financial-app" }
        "all" { return "all" }
        "both" { return "all" }
        "ambas" { return "all" }
        default { throw "App no válida: $Name" }
    }
}

function Get-CoverageData {
    param(
        [Parameter(Mandatory = $true)]
        [string]$CoverageFile
    )

    $content = Get-Content $CoverageFile -Raw
    $lines = ($content | Select-String -Pattern "LF:(\d+)" -AllMatches).Matches | ForEach-Object { [int]$_.Groups[1].Value }
    $linesHit = ($content | Select-String -Pattern "LH:(\d+)" -AllMatches).Matches | ForEach-Object { [int]$_.Groups[1].Value }

    $totalLines = ($lines | Measure-Object -Sum).Sum
    $totalLinesHit = ($linesHit | Measure-Object -Sum).Sum

    if (-not $totalLines) {
        throw "No se pudo calcular la cobertura"
    }

    return [pscustomobject]@{
        TotalLines = [int]$totalLines
        CoveredLines = [int]$totalLinesHit
        UncoveredLines = [int]($totalLines - $totalLinesHit)
        Coverage = [math]::Round(($totalLinesHit / $totalLines) * 100, 2)
    }
}

function Invoke-CoverageForApp {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TargetApp,

        [Parameter(Mandatory = $true)]
        [decimal]$MinimumThreshold
    )

    $appDir = Join-Path $RootDir "apps/$TargetApp"
    $coverageFile = Join-Path $appDir "coverage/lcov.info"
    $htmlDir = Join-Path $appDir "coverage/html"

    if (-not (Test-Path $appDir)) {
        Write-Host "❌ Error: La app $TargetApp no existe en apps/" -ForegroundColor Red
        return $false
    }

    Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
    Write-Host "🧪 Ejecutando tests con cobertura para: $TargetApp" -ForegroundColor Blue
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue

    Push-Location $appDir
    try {
        flutter test --coverage
    } finally {
        Pop-Location
    }

    if (-not (Test-Path $coverageFile)) {
        Write-Host "❌ Error: No se generó el archivo de cobertura para $TargetApp" -ForegroundColor Red
        return $false
    }

    Write-Host "`n📊 Generando reporte HTML para $TargetApp..." -ForegroundColor Blue
    if (Get-Command genhtml -ErrorAction SilentlyContinue) {
        genhtml $coverageFile -o $htmlDir | Out-Null
        Write-Host "✓ Reporte HTML generado en apps/$TargetApp/coverage/html/index.html" -ForegroundColor Green
    } else {
        Write-Host "⚠ genhtml no está instalado. Instálalo con: choco install lcov o winget install lcov" -ForegroundColor Yellow
    }

    try {
        $coverageData = Get-CoverageData -CoverageFile $coverageFile
    } catch {
        Write-Host "❌ Error: $($_.Exception.Message) para $TargetApp" -ForegroundColor Red
        return $false
    }

    Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
    Write-Host "📈 Resumen de Cobertura para $TargetApp:" -ForegroundColor Blue
    Write-Host "   Total de líneas: $($coverageData.TotalLines)" -ForegroundColor Cyan
    Write-Host "   Líneas cubiertas: $($coverageData.CoveredLines)" -ForegroundColor Cyan
    Write-Host "   Líneas sin cubrir: $($coverageData.UncoveredLines)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   Cobertura actual: $($coverageData.Coverage)%" -ForegroundColor Cyan
    Write-Host "   Umbral mínimo: $MinimumThreshold%" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue

    if ($coverageData.Coverage -lt $MinimumThreshold) {
        Write-Host "" 
        Write-Host "❌ FALLO: Cobertura $($coverageData.Coverage)% por debajo del umbral $MinimumThreshold% en $TargetApp" -ForegroundColor Red
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Red
        return $false
    }

    Write-Host ""
    Write-Host "✅ ÉXITO: Cobertura $($coverageData.Coverage)% cumple el umbral $MinimumThreshold% en $TargetApp" -ForegroundColor Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
    return $true
}

if ($Help) {
    Show-Usage
    exit 0
}

try {
    $resolvedApp = Resolve-AppName -Name $App
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    Show-Usage
    exit 1
}

$targetApps = if ($resolvedApp -eq "all") { $AvailableApps } else { @($resolvedApp) }
$overallSuccess = $true

foreach ($targetApp in $targetApps) {
    if (-not (Invoke-CoverageForApp -TargetApp $targetApp -MinimumThreshold $Threshold)) {
        $overallSuccess = $false
    }
}

Write-Host "`n💡 Tip: Abre el reporte HTML de cada app en apps/<app>/coverage/html/index.html" -ForegroundColor Yellow

if (-not $overallSuccess) {
    exit 1
}
