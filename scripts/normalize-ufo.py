# SPDX-FileCopyrightText: 2023 Lynn Kirby
#
# SPDX-License-Identifier: 0BSD

from __future__ import annotations

import os
import subprocess
import sys
from argparse import ArgumentParser
from pathlib import Path
from tempfile import TemporaryDirectory


def run_psfnormalize(ufo: Path, log_dir: Path, quiet: bool) -> None:
    # Run a Python subprocess instead of calling the psfnormalize script
    # directly. The script holds onto file handles after exiting, which messes
    # up our temporary directory log file.
    args = [
        sys.executable,
        "-m",
        "silfont.scripts.psfnormalize",
        "-l",
        str(log_dir),
        "-p",
        "checkfix=none",
        "-p",
        "backup=false",
    ]
    if quiet:
        args.append("-q")
    args.append(str(ufo))
    subprocess.run(args=args)


def normalize_line_endings(file: Path):
    lines = file.read_text(encoding="utf-8").splitlines()
    result = "\n".join(lines)
    if not result.endswith("\n"):
        result = result + "\n"
    file.write_bytes(result.encode("utf-8"))


def main():
    parser = ArgumentParser()
    parser.add_argument("-l", "--log-dir", type=Path)
    parser.add_argument("-q", "--quiet", action="store_true")
    parser.add_argument("ufo", type=Path)
    args = parser.parse_args()

    ufo: Path = args.ufo
    log_dir: Path | None = args.log_dir
    quiet: bool = args.quiet

    if args.log_dir is None:
        # Can't disable log output so just write to a temporary directory.
        with TemporaryDirectory() as tmpdir:
            run_psfnormalize(ufo=ufo, log_dir=Path(tmpdir), quiet=quiet)
    else:
        os.makedirs(args.log_dir, exist_ok=True)
        run_psfnormalize(ufo=ufo, log_dir=log_dir, quiet=quiet)

    for file in ufo.glob("**/*.glif"):
        normalize_line_endings(file)
    for file in ufo.glob("**/*.plist"):
        normalize_line_endings(file)


if __name__ == "__main__":
    main()
