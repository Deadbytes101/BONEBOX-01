#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import sys
from pathlib import Path

SECTOR = 512


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print("usage: check_image.py build/bonebox.img", file=sys.stderr)
        return 2

    image_path = Path(argv[1])
    data = image_path.read_bytes()

    if len(data) < SECTOR:
        print("image is smaller than one sector", file=sys.stderr)
        return 1
    if data[510:512] != b"\x55\xaa":
        print("missing boot signature", file=sys.stderr)
        return 1
    if len(data) % SECTOR != 0:
        print("image size is not sector aligned", file=sys.stderr)
        return 1

    sha256 = hashlib.sha256(data).hexdigest()
    print(f"image: {image_path}")
    print(f"size : {len(data)} bytes / {len(data) // SECTOR} sectors")
    print(f"sha256: {sha256}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
