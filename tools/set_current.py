#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
from pathlib import Path

CUT_RE = re.compile(r"core_v([0-9]+)\.asm$")
BANNER_RE = re.compile(r"BONEBOX-01 v[0-9]+\.[0-9]+\.[0-9]+")


def cut_number(path: Path) -> int:
    match = CUT_RE.search(path.name)
    if not match:
        return -1
    return int(match.group(1))


def read_banner(path: Path) -> str:
    text = path.read_text(encoding="utf-8")
    match = BANNER_RE.search(text)
    if not match:
        raise SystemExit(f"missing banner in {path}")
    return match.group(0)


def find_latest(kernel_dir: Path) -> Path:
    cuts = sorted(kernel_dir.glob("core_v*.asm"), key=cut_number)
    if not cuts:
        raise SystemExit("no kernel cuts found")
    return cuts[-1]


def resolve_target(root: Path, target: str) -> Path:
    kernel_dir = root / "kernel"
    if target == "latest":
        return find_latest(kernel_dir)

    path = Path(target)
    if not path.is_absolute():
        path = root / path
    if not path.exists():
        raise SystemExit(f"target missing: {target}")
    if path.parent != kernel_dir:
        raise SystemExit("target must live in kernel/")
    if cut_number(path) < 0:
        raise SystemExit("target must be named core_vNNN.asm")
    return path


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("target", help="latest or kernel/core_vNNN.asm")
    parser.add_argument("--root", default=".")
    args = parser.parse_args()

    root = Path(args.root).resolve()
    target = resolve_target(root, args.target).resolve()
    rel = target.relative_to(root).as_posix()
    banner = read_banner(target)

    current = root / "kernel" / "current.asm"
    current.write_text(
        "; Active BONEBOX-01 kernel.\n"
        "; Build scripts assemble this file, not versioned kernels directly.\n"
        "\n"
        f"%include \"{rel}\"\n",
        encoding="utf-8",
    )

    print(f"current {rel}")
    print(f"banner  {banner}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
