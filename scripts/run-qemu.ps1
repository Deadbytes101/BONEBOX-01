$ErrorActionPreference = "Stop"

$Root = Resolve-Path "$PSScriptRoot/.."
& (Join-Path $Root "scripts/build.ps1")

$Image = Join-Path $Root "build/bonebox.img"
qemu-system-i386 -machine pc -drive file=$Image,format=raw,index=0,media=disk
