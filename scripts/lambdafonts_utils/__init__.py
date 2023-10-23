# SPDX-FileCopyrightText: 2023 Lynn Kirby
#
# SPDX-License-Identifier: 0BSD

from __future__ import annotations

import subprocess
from pathlib import Path
import sys
import os

import typing

CheckFix = typing.Literal["check", "fix", "none"]


def run_pysilfont_script(
    *,
    script: str,
    log_dir: Path | None = None,
    params: dict[str, str] | None = None,
    positional: list[str] | None = None,
) -> int:
    params = params or {}
    positional = positional or []

    args = [
        sys.executable,
        "-m",
        f"silfont.scripts.{script}",
    ]

    if log_dir is not None:
        args += ["-l", str(log_dir)]

    args += positional

    result = subprocess.run(args=args)

    return result.returncode


def run_psfnormalize(
    ufo: Path,
    *,
    checkfix: CheckFix = "check",
    log_dir: Path | None = None,
) -> None:
    run_pysilfont_script(
        script="psfnormalize",
        log_dir=log_dir,
        positional=[str(ufo)],
        params={"checkfix": checkfix},
    )


def run_psffixfontlab(
    ufo: Path,
    *,
    checkfix: CheckFix = "check",
    log_dir: Path | None = None,
) -> None:
    run_pysilfont_script(
        script="psffixfontlab",
        log_dir=log_dir,
        positional=[str(ufo)],
        params={"checkfix": checkfix},
    )


def dos2unix(file: Path) -> None:
    file.write_bytes(file.read_bytes().replace(b"\r\n", b"\n"))


def fix_line_endings(ufo: Path) -> None:
    if os.linesep != "\n":
        for file in ufo.glob("**/*.glif"):
            dos2unix(file)
        for file in ufo.glob("**/*.plist"):
            dos2unix(file)
