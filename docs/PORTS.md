# Ports

BONEBOX-01 touches a tiny set of old PC hardware ports.

```txt
0x60  keyboard data
0x64  keyboard status
0x3d4 VGA cursor index
0x3d5 VGA cursor data
0x42  PIT channel 2 data
0x43  PIT command
0x61  PC speaker gate
```

The first kernel polls the keyboard. No IRQ path yet.

The screen is VGA text memory at physical address `0xb8000`.

The boot sector is read by BIOS. The kernel does not call DOS. The kernel does not write disk.
