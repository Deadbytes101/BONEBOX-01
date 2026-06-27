$ErrorActionPreference = "Stop"

function Find-Qemu {
    $Cmd = Get-Command "qemu-system-i386" -ErrorAction SilentlyContinue
    if ($Cmd) { return $Cmd.Source }

    $Fallbacks = @(
        "C:\Program Files\qemu\qemu-system-i386.exe",
        "C:\Program Files (x86)\qemu\qemu-system-i386.exe"
    )

    foreach ($Path in $Fallbacks) {
        if (Test-Path $Path) { return $Path }
    }

    return $null
}

$Root = Resolve-Path "$PSScriptRoot/.."
& (Join-Path $Root "scripts/build.ps1")

$Qemu = Find-Qemu
if (-not $Qemu) {
    Write-Host "missing: qemu-system-i386"
    Write-Host "image  : build/bonebox.iso"
    Write-Host "read   : docs/WINDOWS.md"
    exit 1
}

$Iso = Join-Path $Root "build/bonebox.iso"
& $Qemu -machine pc -cdrom $Iso -boot d
