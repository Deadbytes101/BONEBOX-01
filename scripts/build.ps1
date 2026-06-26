$ErrorActionPreference = "Stop"

function Find-Tool {
    param([Parameter(Mandatory = $true)][string]$Name)
    $Cmd = Get-Command $Name -ErrorAction SilentlyContinue
    if ($Cmd) { return $Cmd.Source }
    return $null
}

function Need-Tool {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][string]$Reason
    )

    $Tool = Find-Tool $Name
    if (-not $Tool) {
        Write-Host "missing: $Name"
        Write-Host "needed : $Reason"
        Write-Host "read   : docs/WINDOWS.md"
        exit 1
    }
    return $Tool
}

$Root = Resolve-Path "$PSScriptRoot/.."
$Build = Join-Path $Root "build"
New-Item -ItemType Directory -Force $Build | Out-Null

$Nasm = Need-Tool "nasm" "flat binary assembly"
$Python = Find-Tool "python"
if (-not $Python) { $Python = Find-Tool "py" }
if (-not $Python) {
    Write-Host "missing: python"
    Write-Host "needed : image packing and verification"
    Write-Host "read   : docs/WINDOWS.md"
    exit 1
}

$Boot = Join-Path $Build "boot.bin"
$Kernel = Join-Path $Build "kernel.bin"
$Image = Join-Path $Build "bonebox.img"

& $Nasm -f bin (Join-Path $Root "boot/boot.asm") -o $Boot
& $Nasm -f bin (Join-Path $Root "kernel/core.asm") -o $Kernel
& $Python (Join-Path $Root "tools/mkimage.py") --boot $Boot --kernel $Kernel --out $Image --kernel-sectors 32

Write-Host "built $Image"
