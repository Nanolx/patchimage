#!/bin/bash

DOWNLOAD_LINK="https://drive.google.com/uc?id=0BzJZMhlTQ-CPaUtiTlp4YjlEY3M&export=download"
RIIVOLUTION_ZIP="RRSSFiles 18-11-2015.zip"
RIIVOLUTION_DIR="RRSSFiles 18-11-2015"
GAMENAME="Pokemon Rising Ruby"
GAME_TYPE=HANS

ROM_MASK="*000400000011[cC]400*cxi"
ROMFS="RisingRuby.romfs"
DATA="${PATCHIMAGE_DATA_DIR}/RisingRuby/"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Source:			https://twitter.com/Drayano60/status/662793363255656448
Base ROM:		Pokemon Omega Ruby
Supported Versions:	US, EU, JAP
************************************************"

}

check_hans_files () {

	check_riivolution_patch

}

patch_romfs () {

	cp -r "${RIIVOLUTION_DIR}"/a romfs/

	}
