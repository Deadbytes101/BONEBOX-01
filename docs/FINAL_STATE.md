# FINAL STATE

`v1.0.0` is the public release line.
`v1.0.1` is the current kernel cut inside that line.

The raw image is still canonical.
The ISO is a VM wrapper.
The kernel pointer follows the live cut.
No new tag is required for this fix.

## Current cut

```txt
line    : v1.0.0 release page
cut     : v1.0.1
kernel  : kernel/core_v101.asm
pointer : kernel/current.asm
fix     : shell input uses BIOS int 16h
reason  : direct 0x60/0x64 polling worked in QEMU, not VirtualBox ISO boot
```

The banner now says:

```txt
BONEBOX-01 v1.0.1
```

## Release assets

Rebuild locally.
Test locally.
Overwrite the assets on the existing `v1.0.0` release page.

```txt
bonebox.img  raw disk image, canonical
bonebox.iso  El Torito VM wrapper
```

Do not move the tag just to replace the files.
The tag marks the first public line.
The assets carry the current working cut.

## Commands in the box

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

## Repo proof tools

```txt
scripts/build.ps1
scripts/verify.ps1
scripts/run-qemu.ps1
scripts/run-iso.ps1
scripts/kernels.ps1
scripts/set-current.ps1

tools/mkimage.py
tools/mkiso.py
tools/check_image.py
tools/smoke_image.py
tools/inspect_image.py
tools/check_current.py
tools/list_kernels.py
tools/set_current.py
tools/write_manifest.py
```

## What is done

```txt
boot sector handoff
flat kernel image
El Torito ISO wrapper
VGA text shell
BIOS keyboard shell input
BIOS tick read
segment print
shell state print
fixed memory map
kernel label offsets
boot bytes peek
speaker touch
QEMU raw image run
QEMU ISO run
VirtualBox ISO boot path
Windows build path
image smoke proof
kernel cut list
current kernel pointer
GitHub release assets
repo topics
repo description
README mark
```

## Rule

```txt
bad proof -> new cut
new cut -> test
test -> upload assets
```

Small cuts.
Proof every cut.
No mystery machine.
