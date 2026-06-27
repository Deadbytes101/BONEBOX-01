#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import re
import sys
from pathlib import Path

SECTOR = 512
KERNEL_OFFSET = SECTOR
BANNER_RE = re.compile(rb"BONEBOX-01 v[0-9]+\.[0-9]+\.[0-9]+")


def find_banner(data: bytes) -> tuple[str, int] | None:
    match = BANNER_RE.search(data)
    if not match:
        return None
    return match.group(0).decode("ascii", errors="replace"), match.start()


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print("usage: inspect_image.py build/bonebox.img", file=sys.stderr)
        return 2

    image = Path(argv[1])
    data = image.read_bytes()
    sectors = len(data) // SECTOR if len(data) % SECTOR == 0 else None
    sha256 = hashlib.sha256(data).hexdigest()
    sig = data[510:512] if len(data) >= SECTOR else b""
    banner = find_banner(data)

    print(f"image   {image}")
    print(f"bytes   {len(data)}")
    if sectors is not None:
        print(f"sectors {sectors}")
    else:
        print("sectors unaligned")
    print(f"sha256  {sha256}")
    print(f"bootsig {sig.hex()}")
    print(f"kernel  offset={KERNEL_OFFSET}")

    if banner:
        text, offset = banner
        print(f"banner  {text} @ {offset}")
    else:
        print("banner  missing")
        return 1

    if sig != b"\x55\xaa":
        return 1
    if sectors is None:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
