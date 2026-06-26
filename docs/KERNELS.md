# Kernels

BONEBOX keeps old kernel cuts as fixed fossils.

The build path assembles one pointer file:

```txt
kernel/current.asm
```

`current.asm` includes the active kernel cut. At the moment:

```txt
kernel/core_v017.asm
```

Why this exists:

```txt
versioned kernels keep proof history
current.asm keeps build scripts stable
Makefile and PowerShell do not change every cut
```

Do not edit old cuts unless the old cut itself is broken. Add a new cut, then move `current.asm`.
