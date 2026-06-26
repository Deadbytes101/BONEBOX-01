# BONEBOX-01

One person. One box. No OS underneath.

BONEBOX-01 is a small bare-metal machine for direct contact with the old PC surface: boot sector, keyboard port, VGA text memory, PIT, PC speaker.

It boots, owns the screen, reads keys, and answers simple commands.

## First contact

Target: x86 BIOS, QEMU first.

The first machine stays deliberately small:

```txt
boot sector -> 16-bit kernel -> direct VGA shell
```

No disk writes.
No filesystem.
No network.
No multitasking.
No package manager.

First working boot proof is recorded in:

```txt
docs/FIRST_CONTACT.md
```

## Commands

```txt
help   list commands
ver    print version
tick   print BIOS timer counter
seg    print segments and stack pointer
state  print shell state
map    print fixed memory map
scan   read one key scan
last   print last key state
cls    clear screen
mem    show fixed memory facts
ports  show touched hardware ports
peek   show bytes from boot memory
beep   hit the PIT and PC speaker
demo   write directly into B800 text memory
law    print the machine law
stop   park the CPU
```

## Build

Requirements:

```txt
nasm
python 3
qemu-system-i386 optional for run
```

Windows PowerShell:

```powershell
./scripts/doctor.ps1
./scripts/build.ps1
./scripts/run-qemu.ps1
./scripts/verify.ps1
./scripts/kernels.ps1
```

Windows setup notes:

```txt
docs/WINDOWS.md
```

POSIX shell with make:

```sh
make
make run
make verify
make kernels
```

Output image:

```txt
build/bonebox.img
```

## Law

```txt
No hidden machine.
No abstraction before contact.
The screen is memory.
Sound is voltage.
A feature is guilty until needed.
```
