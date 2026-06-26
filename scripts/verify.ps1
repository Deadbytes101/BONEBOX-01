$ErrorActionPreference = "Stop"

$Root = Resolve-Path "$PSScriptRoot/.."
& (Join-Path $Root "scripts/build.ps1")

$Image = Join-Path $Root "build/bonebox.img"
python (Join-Path $Root "tools/check_image.py") $Image

$Hash = Get-FileHash $Image -Algorithm SHA256
Write-Host "sha256 $($Hash.Hash.ToLowerInvariant())"
Write-Host "verify ok"
