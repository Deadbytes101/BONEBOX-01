# Kernels

BONEBOX keeps old kernel cuts as fixed fossils.

The build path assembles one pointer file:

```txt
kernel/current.asm
```

`current.asm` includes the active kernel cut. At the moment:

```txt
kernel/core_v018.asm
```

Current cut:

```txt
v0.1.8 addr cut
```

Release line:

```txt
v0.1.9 cleanup cut
v0.2.0 First Contact Final
```

Why this exists:

```txt
versioned kernels keep proof history
current.asm keeps build scripts stable
Makefile and PowerShell do not change every cut
```

Switch current kernel on Windows:

```powershell
./scripts/set-current.ps1 latest
./scripts/set-current.ps1 kernel/core_v018.asm
```

Switch current kernel with make:

```sh
make current-latest
```

Do not edit old cuts unless the old cut itself is broken. Add a new cut, then move `current.asm`.
