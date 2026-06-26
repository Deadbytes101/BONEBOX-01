#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import json
import re
import sys
from pathlib import Path

SECTOR = 512
INCLUDE_RE = re.compile(r'^\s*%include\s+"([^"]+)"\s*$')
BANNER_RE = re.compile(rb"BONEBOX-01 v[0-9]+\.[0-9]+\.[0-9]+")


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def active_kernel(root: Path) -> str:
    current = root / "kernel" / "current.asm"
    for line in current.read_text(encoding="utf-8").splitlines():
        match = INCLUDE_RE.match(line)
        if match:
            return match.group(1)
    raise SystemExit("manifest fail: current kernel pointer missing")


def banner_text(data: bytes) -> str:
    match = BANNER_RE.search(data)
    if not match:
        raise SystemExit("manifest fail: BONEBOX banner missing")
    return match.group(0).decode("ascii")


def main(argv: list[str]) -> int:
    if len(argv) != 4:
        print("usage: write_manifest.py <repo-root> <image> <out>", file=sys.stderr)
        return 2

    root = Path(argv[1])
    image = Path(argv[2])
    out = Path(argv[3])

    data = image.read_bytes()
    kernel = active_kernel(root)
    banner = banner_text(data)
    boot_sig = data[510:512].hex() if len(data) >= SECTOR else ""

    manifest = {
        "name": "BONEBOX-01",
        "banner": banner,
        "active_kernel": kernel,
        "image": image.as_posix(),
        "bytes": len(data),
        "sectors": len(data) // SECTOR if len(data) % SECTOR == 0 else None,
        "kernel_offset": SECTOR,
        "boot_signature": boot_sig,
        "sha256": sha256_bytes(data),
    }

    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(f"manifest {out}")
    print(f"banner   {banner}")
    print(f"kernel   {kernel}")
    print(f"sha256   {manifest['sha256']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
