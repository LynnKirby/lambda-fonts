# SPDX-FileCopyrightText: none
#
# SPDX-License-Identifier: 0BSD

ifeq ($(OS),Windows_NT)
PYTHON = python
else
PYTHON = python3
endif

#
# Build fonts
#

all: fonts

fonts: serif

.PHONY: serif-regular serif-bold serif-italic serif-bolditalic

serif: serif-regular serif-bold serif-italic serif-bolditalic

serif-regular:
	fontmake -u sources/LambdaSerif-Regular.ufo -o otf ttf --output-dir _build/fonts

serif-bold:
	fontmake -u sources/LambdaSerif-Bold.ufo -o otf ttf --output-dir _build/fonts

serif-italic:
	fontmake -u sources/LambdaSerif-Italic.ufo -o otf ttf --output-dir _build/fonts

serif-bolditalic:
	fontmake -u sources/LambdaSerif-BoldItalic.ufo -o otf ttf --output-dir _build/fonts

#
# Developer tools
#

.PHONY: normalize-ufos

normalize-ufos-cmd = $(PYTHON) scripts/normalize-ufo.py --log-dir _build/pysilfont-logs

normalize-ufos:
	$(normalize-ufos-cmd) sources/LambdaSerif-Regular.ufo
	$(normalize-ufos-cmd) sources/LambdaSerif-Bold.ufo
	$(normalize-ufos-cmd) sources/LambdaSerif-Italic.ufo
	$(normalize-ufos-cmd) sources/LambdaSerif-BoldItalic.ufo
