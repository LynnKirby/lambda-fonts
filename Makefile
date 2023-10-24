# SPDX-FileCopyrightText: none
#
# SPDX-License-Identifier: 0BSD

.SUFFIXES:
.SECONDARY: # Don't delete intermediate files.

ifeq ($(OS),Windows_NT)
PYTHON = python
copyfile = powershell -c $$null = Copy-Item
makedir = powershell -c $$null = New-Item -ItemType Directory -Path
else
PYTHON = python3
copyfile = cp
makedir = mkdir -p
endif

#
# Build fonts
#

all: fonts

.PHONY: serif

fonts: serif

serif:
	fontmake -u sources/LambdaSerif-Regular.ufo -o otf ttf --output-dir _build/tmp
	fontmake -u sources/LambdaSerif-Bold.ufo -o otf ttf --output-dir _build/tmp
	fontmake -u sources/LambdaSerif-Italic.ufo -o otf ttf --output-dir _build/tmp
	fontmake -u sources/LambdaSerif-BoldItalic.ufo -o otf ttf --output-dir _build/tmp

#
# Documentation
#

preview-png: _build/tmp/preview.png
preview-pdf: _build/tmp/preview.pdf
preview-svg: _build/tmp/preview.svg

# Copy files: documentation/* -> _build/tmp/*
_build/tmp/%.tex: documentation/%.tex | _build/tmp/
	$(copyfile) $< $@

# Build PDF from LaTeX
_build/tmp/%.pdf: _build/tmp/%.tex $(wildcard _build/tmp/*.otf)
	cd _build/tmp && lualatex -interaction=batchmode $(notdir $<)

# Build PNG from PDF
_build/tmp/%.png: _build/tmp/%.pdf
	pdftoppm -png -singlefile $< $(basename $<)

# Build DVI from LaTeX
_build/tmp/%.dvi: _build/tmp/%.tex $(wildcard _build/tmp/*.otf)
	cd _build/tmp && dvilualatex -interaction=batchmode $(notdir $<)

# Build SVG from DVI
_build/tmp/%.svg: _build/tmp/%.dvi Makefile
	cd _build/tmp && dvisvgm --zoom=4 --exact --no-fonts $(notdir $<)

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

#
# Misc.
#

%/:
	$(makedir) $@
