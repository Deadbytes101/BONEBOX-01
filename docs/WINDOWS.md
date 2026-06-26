# Windows

BONEBOX-01 needs three host tools:

```txt
nasm.exe              build boot/kernel flat binaries
python.exe or py.exe  pack and check the raw image
qemu-system-i386.exe  run the image
```

Check the box:

```powershell
./scripts/doctor.ps1
```

Build only:

```powershell
./scripts/build.ps1
```

Run in QEMU:

```powershell
./scripts/run-qemu.ps1
```

If `nasm` is missing, install NASM and make sure `nasm.exe` is in PATH.

The scripts also accept local NASM copies here:

```txt
./nasm.exe
./tools/nasm.exe
```

PowerShell does not run programs from the current directory by bare name. `nasm.exe` can exist beside the repo files while `nasm` still fails unless the script calls it by path.

If `qemu-system-i386` is missing, install QEMU or add its install directory to PATH. The runner also checks these common paths:

```txt
C:\Program Files\qemu\qemu-system-i386.exe
C:\Program Files (x86)\qemu\qemu-system-i386.exe
```

Quick PATH check:

```powershell
where.exe nasm
where.exe python
where.exe qemu-system-i386
```

After changing PATH, open a new PowerShell window.
