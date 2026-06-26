$ErrorActionPreference = "Stop"

$Root = Resolve-Path "$PSScriptRoot/.."

function Find-Tool {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [string[]]$FallbackPaths = @()
    )

    foreach ($Path in $FallbackPaths) {
        if (Test-Path $Path) { return $Path }
    }

    $Cmd = Get-Command $Name -ErrorAction Ignore
    if ($Cmd) { return $Cmd.Source }

    return $null
}

function Need-Tool {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][string]$Reason,
        [string[]]$FallbackPaths = @()
    )

    $Tool = Find-Tool $Name $FallbackPaths
    if (-not $Tool) {
        Write-Host "missing: $Name"
        Write-Host "needed : $Reason"
        Write-Host "read   : docs/WINDOWS.md"
        exit 1
    }
    return $Tool
}

$Build = Join-Path $Root "build"
New-Item -ItemType Directory -Force $Build | Out-Null

$Nasm = Need-Tool "nasm" "flat binary assembly" @(
    (Join-Path $Root "nasm.exe"),
    (Join-Path $Root "tools/nasm.exe")
)

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
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

& $Nasm -f bin (Join-Path $Root "kernel/current.asm") -o $Kernel
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

& $Python (Join-Path $Root "tools/mkimage.py") --boot $Boot --kernel $Kernel --out $Image --kernel-sectors 32
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "built $Image"
