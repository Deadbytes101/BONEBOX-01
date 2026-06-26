# Release line

Final target:

```txt
v1.0.0 = First Contact Final
```

This is not a general-purpose OS release. It is the first stable BONEBOX machine proof:

```txt
boot sector -> 16-bit kernel -> direct VGA shell
```

Frozen active kernel:

```txt
kernel/core_v018.asm
```

Frozen shell commands:

```txt
help
ver
tick
seg
state
map
addr
scan
last
cls
mem
ports
peek
beep
demo
law
stop
```

Final proof gate:

```powershell
./scripts/set-current.ps1 latest
./scripts/kernels.ps1
./scripts/verify.ps1
./scripts/run-qemu.ps1
```

Release artifacts:

```txt
build/bonebox.img
build/bonebox.img.sha256
build/bonebox.manifest.json
```

Suggested repository topics:

```txt
bare-metal
x86
bios
qemu
assembly
nasm
bootloader
vga-text-mode
ps2-keyboard
pc-speaker
operating-system
osdev
retro-computing
low-level
```

After v1.0.0, the next lines can start real expansion:

```txt
v1.1.x = input/editor line
v1.2.x = memory tools
v1.3.x = disk read-only experiments
```
