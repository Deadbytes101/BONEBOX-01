# Kernels

BONEBOX keeps old kernel cuts as fossils.

The build path assembles one pointer file:

```txt
kernel/current.asm
```

`current.asm` includes the active kernel cut. At the moment:

```txt
kernel/core_v101.asm
```

Current cut:

```txt
v1.0.1 virtualbox key cut
```

Why this exists:

```txt
versioned kernels keep proof history
current.asm keeps build scripts stable
Makefile and PowerShell do not change every cut
old release proof stays old
bad proof gets a new cut
```

Known cuts:

```txt
kernel/core_v014.asm
kernel/core_v015.asm
kernel/core_v016.asm
kernel/core_v017.asm
kernel/core_v018.asm  v1.0.0 release proof, QEMU OK, VirtualBox keyboard bad
kernel/core_v101.asm  v1.0.1, BIOS int16 keyboard path
```

Switch current kernel on Windows:

```powershell
./scripts/set-current.ps1 latest
./scripts/set-current.ps1 kernel/core_v101.asm
```

Switch current kernel with make:

```sh
make current-latest
```

Do not rewrite old cuts for vanity.
Add a new cut, move `current.asm`, build, test, tag.
