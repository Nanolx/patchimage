#!/bin/bash

DOWNLOAD_LINK="https://drive.google.com/uc?id=0BzJZMhlTQ-CPaUtiTlp4YjlEY3M&export=download"
RIIVOLUTION_ZIP="RRSSFiles 18-11-2015.zip"
RIIVOLUTION_DIR="RRSSFiles 18-11-2015"
GAMENAME="Pokemon Sinking Sapphire"
GAME_TYPE=HANS

ROM_MASK="*000400000011[cC]500*cxi"
ROMFS="SinkingSapphire.romfs"
DATA="${PATCHIMAGE_DATA_DIR}/SinkingSapphire/"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Source:			https://twitter.com/Drayano60/status/662793363255656448
Base ROM:		Pokemon Alpha Sapphire
Supported Versions:	US, EU, JAP
************************************************"

}

check_hans_files () {

	check_riivolution_patch

}

patch_romfs () {

	cp -r "${RIIVOLUTION_DIR}"/a romfs/

	}
