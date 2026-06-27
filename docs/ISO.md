# ISO

The raw image is still the real BONEBOX artifact.

```txt
build/bonebox.img
```

The ISO is a wrapper for booting the same box through CD-ROM style paths:

```txt
build/bonebox.iso
```

It packs the raw image as a 1.44M El Torito floppy image.

Why it exists:

```txt
some VMs like ISO
some people expect ISO
release pages look complete with both
```

What it is not:

```txt
not a filesystem story
not a second OS image
not a new kernel
```

Build on Windows:

```powershell
./scripts/build.ps1
```

Boot raw image:

```powershell
./scripts/run-qemu.ps1
```

Boot ISO:

```powershell
./scripts/run-iso.ps1
```

Build with make:

```sh
make
make run
make run-iso
```

After building, add it to the existing release:

```powershell
gh release upload v1.0.0 build/bonebox.iso --repo Deadbytes101/BONEBOX-01 --clobber
```
