#!/usr/bin/env python3

from fontTools.ttLib import TTFont
import sys

for arg in sys.argv[1:]:
    font = TTFont(arg)

    for cmap in font['cmap'].tables:
        if cmap.isUnicode():
            for char in cmap.cmap:
                print(char)
