$ErrorActionPreference = "Stop"

$Root = Resolve-Path "$PSScriptRoot/.."

function Find-Tool {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [string[]]$FallbackPaths = @()
    )

    $Cmd = Get-Command $Name -ErrorAction SilentlyContinue
    if ($Cmd) {
        return $Cmd.Source
    }

    foreach ($Path in $FallbackPaths) {
        if (Test-Path $Path) {
            return $Path
        }
    }

    return $null
}

$Nasm = Find-Tool "nasm" @(
    (Join-Path $Root "nasm.exe"),
    (Join-Path $Root "tools/nasm.exe")
)
$Python = Find-Tool "python"
if (-not $Python) {
    $Python = Find-Tool "py"
}
$Qemu = Find-Tool "qemu-system-i386" @(
    "C:\Program Files\qemu\qemu-system-i386.exe",
    "C:\Program Files (x86)\qemu\qemu-system-i386.exe"
)

Write-Host "BONEBOX-01 tool check"
Write-Host ""

if ($Nasm) { Write-Host "nasm  $Nasm" } else { Write-Host "nasm  missing" }
if ($Python) { Write-Host "python $Python" } else { Write-Host "python missing" }
if ($Qemu) { Write-Host "qemu  $Qemu" } else { Write-Host "qemu  missing" }

Write-Host ""

if (-not $Nasm -or -not $Python) {
    Write-Host "Build tools are missing. Read docs/WINDOWS.md."
    exit 1
}

if (-not $Qemu) {
    Write-Host "Build can work, but run-qemu needs qemu-system-i386. Read docs/WINDOWS.md."
    exit 1
}

Write-Host "doctor ok"
