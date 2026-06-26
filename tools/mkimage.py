#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path

SECTOR = 512


def read_bytes(path: Path) -> bytes:
    return path.read_bytes()


def main() -> int:
    parser = argparse.ArgumentParser(description="pack BONEBOX raw disk image")
    parser.add_argument("--boot", required=True, type=Path)
    parser.add_argument("--kernel", required=True, type=Path)
    parser.add_argument("--out", required=True, type=Path)
    parser.add_argument("--kernel-sectors", required=True, type=int)
    args = parser.parse_args()

    boot = read_bytes(args.boot)
    kernel = read_bytes(args.kernel)

    if len(boot) != SECTOR:
        raise SystemExit(f"boot sector must be 512 bytes, got {len(boot)}")
    if boot[510:512] != b"\x55\xaa":
        raise SystemExit("boot sector has no 55 aa signature")
    if args.kernel_sectors <= 0:
        raise SystemExit("kernel sector count must be positive")

    kernel_limit = args.kernel_sectors * SECTOR
    if len(kernel) > kernel_limit:
        raise SystemExit(
            f"kernel is {len(kernel)} bytes, limit is {kernel_limit} bytes"
        )

    image = boot + kernel.ljust(kernel_limit, b"\x00")
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_bytes(image)

    print(f"boot   {len(boot)} bytes")
    print(f"kernel {len(kernel)} bytes / {kernel_limit} max")
    print(f"image  {len(image)} bytes -> {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
