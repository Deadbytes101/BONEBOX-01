#!/usr/bin/env python3
from __future__ import annotations

import sys
from pathlib import Path

SECTOR = 512
EXPECTED_KERNEL_SEGMENT = b"BONEBOX-01"


def fail(message: str) -> int:
    print(f"smoke fail: {message}", file=sys.stderr)
    return 1


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print("usage: smoke_image.py build/bonebox.img", file=sys.stderr)
        return 2

    image_path = Path(argv[1])
    data = image_path.read_bytes()

    if len(data) < SECTOR * 2:
        return fail("image is too small")
    if data[510:512] != b"\x55\xaa":
        return fail("boot signature missing")
    if data[SECTOR : SECTOR + len(EXPECTED_KERNEL_SEGMENT)] == b"":
        return fail("kernel sector is empty")
    if EXPECTED_KERNEL_SEGMENT not in data:
        return fail("kernel banner missing")
    if len(data) % SECTOR != 0:
        return fail("image is not sector aligned")

    print("smoke ok")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
