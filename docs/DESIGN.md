# Design

BONEBOX-01 is a small machine, not a general operating system.

The first rule is contact before structure. Touch the port. Touch the memory. See the thing move. Only then wrap it.

## Shape

```txt
BIOS loads boot sector
boot sector reads fixed kernel sectors
kernel runs at 1000:0000
VGA text memory lives at B800:0000
keyboard comes from ports 60/64
speaker comes from PIT and port 61
```

## Non-goals

```txt
filesystem
network
users
permissions
processes
ELF loader
USB stack
GUI toolkit
```

Those can exist later only if the machine asks for them.

## Rule

A feature is guilty until needed.
