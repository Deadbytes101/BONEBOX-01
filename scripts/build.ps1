$ErrorActionPreference = "Stop"

$Root = Resolve-Path "$PSScriptRoot/.."
$Build = Join-Path $Root "build"
New-Item -ItemType Directory -Force $Build | Out-Null

$Boot = Join-Path $Build "boot.bin"
$Kernel = Join-Path $Build "kernel.bin"
$Image = Join-Path $Build "bonebox.img"

nasm -f bin (Join-Path $Root "boot/boot.asm") -o $Boot
nasm -f bin (Join-Path $Root "kernel/kernel.asm") -o $Kernel
python (Join-Path $Root "tools/mkimage.py") --boot $Boot --kernel $Kernel --out $Image --kernel-sectors 32

Write-Host "built $Image"
