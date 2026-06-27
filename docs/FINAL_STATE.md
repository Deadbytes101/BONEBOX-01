# FINAL STATE

`v1.0.0` proved the box.
`v1.0.1` fixes the VirtualBox keyboard path.

The raw image is still canonical.
The ISO is a VM wrapper.
The kernel pointer now follows the live cut.

## Current cut

```txt
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

## Last public release

```txt
release : v1.0.0
img     : bonebox.img
img sha : 12758c18d5a7a11bb41a0cc717c4aa15fd5fed0ebc2575f4f90ed258adde2b2b
iso     : bonebox.iso
iso sha : e059f0922ace02c600e73ac5d8ea8cf7dc8b395af6dcc6054637cd68205ec1b9
kernel  : kernel/core_v018.asm
host    : QEMU
status  : boots in VirtualBox, keyboard path does not answer there
```

Do not rewrite that release.
Cut forward.

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

Do not mutate old release proof.
Cut forward.

```txt
bad proof -> new cut
new cut -> test
test -> tag
```

Small cuts.
Proof every cut.
No mystery machine.
