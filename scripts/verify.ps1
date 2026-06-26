$ErrorActionPreference = "Stop"

function Find-Tool {
    param([Parameter(Mandatory = $true)][string]$Name)
    $Cmd = Get-Command $Name -ErrorAction SilentlyContinue
    if ($Cmd) { return $Cmd.Source }
    return $null
}

$Root = Resolve-Path "$PSScriptRoot/.."
& (Join-Path $Root "scripts/build.ps1")
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$Python = Find-Tool "python"
if (-not $Python) { $Python = Find-Tool "py" }
if (-not $Python) {
    Write-Host "missing: python"
    Write-Host "needed : image verification"
    exit 1
}

$Image = Join-Path $Root "build/bonebox.img"
if (-not (Test-Path $Image)) {
    Write-Host "missing: build/bonebox.img"
    Write-Host "build did not produce an image"
    exit 1
}

& $Python (Join-Path $Root "tools/check_image.py") $Image
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

& $Python (Join-Path $Root "tools/smoke_image.py") $Image
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$Hash = Get-FileHash $Image -Algorithm SHA256
Write-Host "sha256 $($Hash.Hash.ToLowerInvariant())"
Write-Host "verify ok"
