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

.PHONY: serif

fonts: serif

serif:
	fontmake -u sources/LambdaSerif-Regular.ufo -o otf ttf --output-dir _build/fonts
	fontmake -u sources/LambdaSerif-Bold.ufo -o otf ttf --output-dir _build/fonts
	fontmake -u sources/LambdaSerif-Italic.ufo -o otf ttf --output-dir _build/fonts
	fontmake -u sources/LambdaSerif-BoldItalic.ufo -o otf ttf --output-dir _build/fonts

#
# Developer tools
#

.PHONY: normalize fix-fontlab features

normalize-ufos-cmd = $(PYTHON) scripts/normalize-ufos.py
fix-fontlab-cmd = $(PYTHON) scripts/fix-fontlab.py
make-features-cmd = $(PYTHON) scripts/make-features.py

normalize:
	$(normalize-ufos-cmd) sources/LambdaSerif-Regular.ufo
	$(normalize-ufos-cmd) sources/LambdaSerif-Bold.ufo
	$(normalize-ufos-cmd) sources/LambdaSerif-Italic.ufo
	$(normalize-ufos-cmd) sources/LambdaSerif-BoldItalic.ufo

fix-fontlab:
	$(fix-fontlab-cmd) sources/LambdaSerif-Regular.ufo
	$(fix-fontlab-cmd) sources/LambdaSerif-Bold.ufo
	$(fix-fontlab-cmd) sources/LambdaSerif-Italic.ufo
	$(fix-fontlab-cmd) sources/LambdaSerif-BoldItalic.ufo

features:
	$(make-features-cmd) -u sources/LambdaSerif-Regular.ufo -f sources/features/main.feax
	$(make-features-cmd) -u sources/LambdaSerif-Bold.ufo -f sources/features/main.feax
	$(make-features-cmd) -u sources/LambdaSerif-Italic.ufo -f sources/features/main.feax
	$(make-features-cmd) -u sources/LambdaSerif-BoldItalic.ufo -f sources/features/main.feax
