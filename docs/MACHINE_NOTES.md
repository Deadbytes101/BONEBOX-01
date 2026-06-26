# MACHINE NOTES

This is not a normal app.

This is a box.

It wakes from BIOS.
It reads sectors.
It jumps to `1000:0000`.
It writes the screen by touching `b800:0000`.
It reads the keyboard from `0x60` and `0x64`.
It touches the PIT and speaker ports.
It asks the BIOS data area for time.

No window manager.
No shell from someone else.
No filesystem story.
No fake machine.

## Boot path

```txt
BIOS
  -> boot/boot.asm
  -> load 32 sectors
  -> jump 1000:0000
  -> kernel/current.asm
  -> kernel/core_v018.asm
```

## Screen

```txt
VGA text memory: b800:0000
80 columns
25 rows
2 bytes per cell
char byte
attr byte
```

The cursor is not a widget.
It is VGA hardware state.

## Keyboard

```txt
status port: 0x64
data port  : 0x60
```

BONEBOX reads scan codes first.
Then it maps them to small ASCII.
`scan` shows the raw key scan.
`last` shows what the box remembers.

## Time

```txt
BIOS data area: 0040:006c
```

`tick` prints the BIOS timer counter.
It is not pretty time.
It is the machine counting.

## Sound

```txt
PIT command : 0x43
PIT channel2: 0x42
speaker gate: 0x61
```

`beep` touches voltage.
Not audio middleware.
Not a mixer.

## Memory sense

`seg` prints segment registers.
`state` prints shell state.
`map` prints fixed memory places.
`addr` prints label offsets inside the kernel.

The point is simple:

```txt
make the box see itself
then let it answer
```
