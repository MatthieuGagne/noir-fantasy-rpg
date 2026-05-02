.DEFAULT_GOAL := assets

TILESETS_SRC := $(wildcard art/tilesets/*.xcf)
TILESETS_PNG := $(TILESETS_SRC:.xcf=.png)

.PHONY: assets export-art copy-art import check-xcftools

assets: export-art copy-art import

check-xcftools:
	@which xcf2png > /dev/null 2>&1 || (echo "Error: xcftools not found. Install with: sudo apt install xcftools" && exit 1)

export-art: check-xcftools $(TILESETS_PNG)

art/tilesets/%.png: art/tilesets/%.xcf
	xcf2png -o $@ $<

copy-art:
	rsync -a --include="*/" --include="*.png" --exclude="*" art/tilesets/ assets/tilesets/

import:
	DISPLAY=:0 godot --headless --editor --quit --path .
