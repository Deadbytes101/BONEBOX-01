#!/usr/bin/env python3
from pathlib import Path
import sys


def main() -> int:
    root = Path(sys.argv[1]) if len(sys.argv) == 2 else Path.cwd()
    current = root / "kernel" / "current.asm"

    if not current.exists():
        print("current fail: kernel/current.asm missing", file=sys.stderr)
        return 1

    includes = []
    for raw in current.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if not line.startswith("%include"):
            continue
        parts = line.split(maxsplit=1)
        if len(parts) != 2:
            continue
        includes.append(parts[1].strip().strip('"').strip("'"))

    if len(includes) != 1:
        print(f"current fail: include count {len(includes)}", file=sys.stderr)
        return 1

    target = root / includes[0]
    if not target.is_file():
        print(f"current fail: missing {includes[0]}", file=sys.stderr)
        return 1

    print(f"current ok {includes[0]}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
