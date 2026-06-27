# BONEBOX-01

One box.
One boot sector.
No OS underneath.

BONEBOX-01 is an x86 BIOS box that wakes up in its own 16-bit shell.

The screen is memory.
The keyboard is a port.
The clock is a BIOS counter.
The speaker is voltage.

No desktop.
No runtime.
No package smell.
No soft layer pretending to be the machine.

Just the box answering back.

## First contact

<p align="center">
  <img width="254" height="254" alt="BONEBOX-01 logo" src="https://github.com/user-attachments/assets/90a83d85-7a4d-4264-9fab-e11d602d53bd" />
</p>

![release](https://img.shields.io/badge/RELEASE-v1.0.0-blue)
![target](https://img.shields.io/badge/TARGET-x86_BIOS-yellow)
![boot](https://img.shields.io/badge/BOOT-512_BYTE_SECTOR-white)
![machine](https://img.shields.io/badge/MACHINE-BARE_METAL-black)
![shell](https://img.shields.io/badge/SHELL-VGA_TEXT_MODE-blue)
![asm](https://img.shields.io/badge/ASM-NASM-red)
![qemu](https://img.shields.io/badge/PROOF-QEMU-green)
![license](https://img.shields.io/badge/LICENSE-Apache--2.0-lightgrey)

```txt
BONEBOX MARK
BLUE B IN A BLACK SCREEN
BONES BEHIND THE BOX
OLD PC SURFACE
DEADBYTE CUT
DIRECT MACHINE CONTACT
```

Target: x86 BIOS.
Proof host: QEMU.

The first machine stays small on purpose:

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

## Docs

```txt
docs/MACHINE_NOTES.md   what the box touches
docs/FINAL_STATE.md     what v1.0.0 freezes
docs/ISO.md             why the ISO exists
docs/KERNELS.md         kernel cuts and current pointer
docs/RELEASE_PLAN.md    release line
docs/WINDOWS.md         Windows build notes
docs/PORTS.md           touched hardware ports
docs/DESIGN.md          shape of the machine
docs/FIRST_CONTACT.md   first boot proof
```

## Commands

```txt
help   list commands
ver    print version
tick   print BIOS timer counter
seg    print segments and stack pointer
state  print shell state
map    print fixed memory map
addr   print kernel label offsets
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
./scripts/run-iso.ps1
./scripts/verify.ps1
./scripts/kernels.ps1
python tools/write_manifest.py . build/bonebox.img build/bonebox.manifest.json
```

Windows setup notes:

```txt
docs/WINDOWS.md
```

POSIX shell with make:

```sh
make
make run
make run-iso
make verify
make kernels
make manifest
```

Output image:

```txt
build/bonebox.img  raw disk image canonical
build/bonebox.iso  El Torito 1.44M boot wrapper
build/bonebox.manifest.json
```

## Law

```txt
No hidden machine.
No abstraction before contact.
The screen is memory.
Sound is voltage.
A feature is guilty until needed.
```
