#!/usr/bin/env python3
from __future__ import annotations

import re
import sys
from pathlib import Path

INCLUDE_RE = re.compile(r'^\s*%include\s+"([^"]+)"\s*$')
BANNER_RE = re.compile(rb"BONEBOX-01 v[0-9]+\.[0-9]+\.[0-9]+")


def fail(message: str) -> int:
    print(f"current fail: {message}", file=sys.stderr)
    return 1


def main(argv: list[str]) -> int:
    root = Path(argv[1]) if len(argv) == 2 else Path.cwd()
    current = root / "kernel" / "current.asm"

    if not current.exists():
        return fail("kernel/current.asm missing")

    include_path: str | None = None
    for line in current.read_text(encoding="utf-8").splitlines():
        match = INCLUDE_RE.match(line)
        if match:
            include_path = match.group(1)
            break

    if not include_path:
        return fail("current.asm has no include pointer")

    target = root / include_path
    if not target.exists():
        return fail(f"include target missing: {include_path}")

    data = target.read_bytes()
    banner = BANNER_RE.search(data)
    if not banner:
        return fail(f"target has no BONEBOX version banner: {include_path}")

    print(f"current {include_path}")
    print(f"banner  {banner.group(0).decode('ascii')}")
    print(f"bytes   {len(data)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
