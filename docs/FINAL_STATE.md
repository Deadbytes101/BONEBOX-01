# FINAL STATE

`v1.0.0` is the first closed BONEBOX proof.

The release tag is public.
The release assets are public.
The image boots.
The repo is clean.

## Frozen proof

```txt
release : v1.0.0
img     : bonebox.img
img sha : 12758c18d5a7a11bb41a0cc717c4aa15fd5fed0ebc2575f4f90ed258adde2b2b
iso     : bonebox.iso
iso sha : e059f0922ace02c600e73ac5d8ea8cf7dc8b395af6dcc6054637cd68205ec1b9
kernel  : kernel/core_v018.asm
pointer : kernel/current.asm
host    : QEMU
```

The banner inside the frozen kernel still says:

```txt
BONEBOX-01 v0.1.8
```

That is intentional.
`v1.0.0` is the public freeze of that proven cut.
Do not rewrite the old cut just to make the number prettier.
Proof beats cosmetics.

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
scripts/doctor.ps1
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
keyboard scan input
BIOS tick read
segment print
shell state print
fixed memory map
kernel label offsets
boot bytes peek
speaker touch
QEMU raw image run
QEMU ISO run
Windows build path
image smoke proof
kernel cut list
current kernel pointer
GitHub release assets
repo topics
repo description
README mark
```

## Do not mess with the freeze

After `v1.0.0`, do not mutate the frozen line.
Start a new line.

```txt
v1.1.x input line
v1.2.x memory line
v1.3.x disk read-only line
```

Small cuts.
Proof every cut.
No mystery machine.
