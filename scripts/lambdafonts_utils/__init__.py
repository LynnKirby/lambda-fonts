# SPDX-FileCopyrightText: 2023 Lynn Kirby
#
# SPDX-License-Identifier: 0BSD

from __future__ import annotations

import os
import subprocess
import sys
import typing
from pathlib import Path

CheckFix = typing.Literal["check", "fix", "none"]


def run_pysilfont_script(
    *,
    script: str,
    log_dir: Path | None = None,
    params: dict[str, str] | None = None,
    args: list[str] | None = None,
) -> int:
    params = params or {}
    args = args or []

    run_args = [sys.executable, "-m", f"silfont.scripts.{script}"]

    if log_dir is not None:
        run_args += ["-l", str(log_dir)]

    for k, v in params.items():
        run_args += ["-p", f"{k}={v}"]

    run_args += args
    result = subprocess.run(args=run_args)
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
        args=[str(ufo)],
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
        args=[str(ufo)],
        params={"checkfix": checkfix},
    )


def run_psfmakefea(
    ufo: Path,
    fea: Path,
    *,
    log_dir: Path | None = None,
) -> None:
    run_pysilfont_script(
        script="psfmakefea",
        log_dir=log_dir,
        args=["-i", str(fea), "-o", str(ufo / "features.fea"), str(ufo)],
    )


def dos2unix(file: Path) -> None:
    file.write_bytes(file.read_bytes().replace(b"\r\n", b"\n"))


def fix_line_endings(ufo: Path) -> None:
    if os.linesep != "\n":
        for file in ufo.glob("**/*.glif"):
            dos2unix(file)
        for file in ufo.glob("**/*.plist"):
            dos2unix(file)
