# SPDX-FileCopyrightText: 2023 Lynn Kirby
#
# SPDX-License-Identifier: 0BSD

from __future__ import annotations

from argparse import ArgumentParser
from pathlib import Path

import lambdafonts_utils as utils


def main():
    parser = ArgumentParser()
    parser.add_argument("-l", "--log-dir", type=Path)
    parser.add_argument("-u", "--ufo", type=Path)
    parser.add_argument("-f", "--fea", type=Path)
    args = parser.parse_args()

    ufo: Path = args.ufo
    fea: Path = args.fea
    log_dir: Path | None = args.log_dir

    utils.run_psfmakefea(ufo=ufo, fea=fea, log_dir=log_dir)
    utils.fix_line_endings(ufo / "features.fea")


if __name__ == "__main__":
    main()
