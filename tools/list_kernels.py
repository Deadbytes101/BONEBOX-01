#!/usr/bin/env python3
from __future__ import annotations

import re
import sys
from pathlib import Path

BANNER_RE = re.compile(rb"BONEBOX-01 v[0-9]+\.[0-9]+\.[0-9]+")


def banner_for(path: Path) -> str:
    data = path.read_bytes()
    match = BANNER_RE.search(data)
    if match:
        return match.group(0).decode("ascii", errors="replace")
    return "no banner"


def main(argv: list[str]) -> int:
    root = Path(argv[1]) if len(argv) == 2 else Path.cwd()
    kernel_dir = root / "kernel"

    if not kernel_dir.is_dir():
        print("kernel directory missing", file=sys.stderr)
        return 1

    cuts = sorted(kernel_dir.glob("core_v*.asm"))
    if not cuts:
        print("no kernel cuts", file=sys.stderr)
        return 1

    for path in cuts:
        rel = path.relative_to(root).as_posix()
        print(f"{rel}  {path.stat().st_size:5d} bytes  {banner_for(path)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
