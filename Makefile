# SPDX-FileCopyrightText: none
#
# SPDX-License-Identifier: 0BSD

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
