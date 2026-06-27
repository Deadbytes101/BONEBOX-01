#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path

ISO_SECTOR = 2048
FLOPPY_SIZE = 1440 * 1024


def pad(data: bytes, size: int, value: int = 0) -> bytes:
    if len(data) > size:
        raise SystemExit(f"input is {len(data)} bytes, max is {size}")
    return data + bytes([value]) * (size - len(data))


def both16(value: int) -> bytes:
    return value.to_bytes(2, "little") + value.to_bytes(2, "big")


def both32(value: int) -> bytes:
    return value.to_bytes(4, "little") + value.to_bytes(4, "big")


def sector(data: bytes = b"") -> bytes:
    return pad(data, ISO_SECTOR)


def dir_record(name: bytes, lba: int, size: int, flags: int) -> bytes:
    body = bytearray()
    body.append(0)
    body.append(0)
    body += both32(lba)
    body += both32(size)
    body += bytes([125, 1, 1, 0, 0, 0, 0])
    body.append(flags)
    body.append(0)
    body.append(0)
    body += both16(1)
    body.append(len(name))
    body += name
    if len(body) % 2:
        body.append(0)
    body[0] = len(body)
    return bytes(body)


def path_table(root_lba: int, big: bool) -> bytes:
    out = bytearray()
    out.append(1)
    out.append(0)
    out += root_lba.to_bytes(4, "big" if big else "little")
    out += (1).to_bytes(2, "big" if big else "little")
    out.append(0)
    out.append(0)
    return bytes(out)


def primary_volume(total_sectors: int, root_lba: int, path_l: int, path_m: int, path_size: int) -> bytes:
    out = bytearray(ISO_SECTOR)
    out[0] = 1
    out[1:6] = b"CD001"
    out[6] = 1
    out[8:40] = b"BONEBOX".ljust(32)
    out[40:72] = b"BONEBOX_01".ljust(32)
    out[80:88] = both32(total_sectors)
    out[120:124] = both16(1)
    out[124:128] = both16(1)
    out[128:132] = both16(ISO_SECTOR)
    out[132:140] = both32(path_size)
    out[140:144] = path_l.to_bytes(4, "little")
    out[148:152] = path_m.to_bytes(4, "big")
    root = dir_record(b"\x00", root_lba, ISO_SECTOR, 2)
    out[156:156 + len(root)] = root
    out[190:318] = b"BONEBOX-01".ljust(128)
    out[318:446] = b"DEADBYTE".ljust(128)
    out[813:830] = b"2026062700000000\x00"
    out[830:847] = b"2026062700000000\x00"
    out[847:864] = b"0000000000000000\x00"
    out[864:881] = b"0000000000000000\x00"
    out[881] = 1
    return bytes(out)


def boot_record(catalog_lba: int) -> bytes:
    out = bytearray(ISO_SECTOR)
    out[0] = 0
    out[1:6] = b"CD001"
    out[6] = 1
    out[7:39] = b"EL TORITO SPECIFICATION".ljust(32)
    out[71:75] = catalog_lba.to_bytes(4, "little")
    return bytes(out)


def terminator() -> bytes:
    out = bytearray(ISO_SECTOR)
    out[0] = 255
    out[1:6] = b"CD001"
    out[6] = 1
    return bytes(out)


def boot_catalog(image_lba: int) -> bytes:
    out = bytearray(ISO_SECTOR)
    entry = bytearray(32)
    entry[0] = 1
    entry[1] = 0
    entry[4:28] = b"BONEBOX-01".ljust(24)
    entry[30] = 0x55
    entry[31] = 0xAA
    checksum = (-sum(int.from_bytes(entry[i:i + 2], "little") for i in range(0, 32, 2))) & 0xFFFF
    entry[28:30] = checksum.to_bytes(2, "little")
    out[0:32] = entry

    boot = bytearray(32)
    boot[0] = 0x88
    boot[1] = 0x02
    boot[2:4] = (0).to_bytes(2, "little")
    boot[4] = 0
    boot[6:8] = (1).to_bytes(2, "little")
    boot[8:12] = image_lba.to_bytes(4, "little")
    out[32:64] = boot
    return bytes(out)


def root_dir(root_lba: int, catalog_lba: int, image_lba: int, readme_lba: int, readme_size: int) -> bytes:
    out = bytearray()
    out += dir_record(b"\x00", root_lba, ISO_SECTOR, 2)
    out += dir_record(b"\x01", root_lba, ISO_SECTOR, 2)
    out += dir_record(b"BOOT.CAT;1", catalog_lba, ISO_SECTOR, 0)
    out += dir_record(b"BONEBOX.IMG;1", image_lba, FLOPPY_SIZE, 0)
    out += dir_record(b"README.TXT;1", readme_lba, readme_size, 0)
    return sector(bytes(out))


def main() -> int:
    parser = argparse.ArgumentParser(description="pack BONEBOX bootable ISO")
    parser.add_argument("--image", required=True, type=Path)
    parser.add_argument("--out", required=True, type=Path)
    args = parser.parse_args()

    raw = args.image.read_bytes()
    floppy = pad(raw, FLOPPY_SIZE)
    readme = b"BONEBOX-01\r\nBOOTABLE ISO WRAPS THE RAW IMG AS A 1.44M EL TORITO FLOPPY\r\n"

    pvd_lba = 16
    br_lba = 17
    term_lba = 18
    path_l_lba = 19
    path_m_lba = 20
    root_lba = 21
    catalog_lba = 22
    readme_lba = 23
    image_lba = 24
    image_sectors = FLOPPY_SIZE // ISO_SECTOR
    total_sectors = image_lba + image_sectors
    path_l = path_table(root_lba, False)
    path_m = path_table(root_lba, True)

    parts: list[bytes] = []
    parts.append(bytes(16 * ISO_SECTOR))
    parts.append(primary_volume(total_sectors, root_lba, path_l_lba, path_m_lba, len(path_l)))
    parts.append(boot_record(catalog_lba))
    parts.append(terminator())
    parts.append(sector(path_l))
    parts.append(sector(path_m))
    parts.append(root_dir(root_lba, catalog_lba, image_lba, readme_lba, len(readme)))
    parts.append(boot_catalog(image_lba))
    parts.append(sector(readme))
    parts.append(floppy)

    iso = b"".join(parts)
    if len(iso) != total_sectors * ISO_SECTOR:
        raise SystemExit("iso size mismatch")

    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_bytes(iso)
    print(f"iso    {len(iso)} bytes -> {args.out}")
    print(f"floppy {len(floppy)} bytes from {args.image}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
