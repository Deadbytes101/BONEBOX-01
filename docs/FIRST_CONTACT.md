# First contact

BONEBOX-01 reached QEMU first contact on Windows.

Host tools:

```txt
nasm  local repo copy
python C:\Program Files\Python314\python.exe
qemu  C:\Program Files\qemu\qemu-system-i386.exe
```

Build proof:

```txt
boot   512 bytes
kernel 1396 bytes / 16384 max
image  16896 bytes -> build/bonebox.img
size   16896 bytes / 33 sectors
sha256 1525889b2b41230b2045a53d309e784a2abd0efeb6ad67142a7dc8a7573f6f55
verify ok
```

Screen proof:

```txt
BONEBOX-01
direct screen. direct keys. no host OS.
type help

bone>
```

This is not a release claim. It is the first working boot proof.
