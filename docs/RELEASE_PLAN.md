# Release line

Current line:

```txt
v0.1.x = first-contact cuts
```

Do not call this v1.0.0 yet.

The clean finish for the first public proof is:

```txt
v0.2.0 = First Contact Final
```

Recommended path:

```txt
v0.1.9  cleanup cut
v0.2.0  first-contact final freeze
```

`v0.1.9` should only contain fixes and proof cleanup:

```txt
PowerShell scripts stable
current kernel pointer stable
image proof stable
kernel list stable
QEMU boot proof stable
```

`v0.2.0` should freeze the first usable BONEBOX shell:

```txt
boot
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

After v0.2.0, the next line can start real expansion:

```txt
v0.3.x = input/editor line
v0.4.x = memory tools
v0.5.x = disk read-only experiments
```
