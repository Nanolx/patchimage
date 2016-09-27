#!/bin/bash

DOWNLOAD_LINK="https://drive.google.com/uc?id=0B-zmEVN0Mas6NUlqM1hMTnVuS00&export=download"
RIIVOLUTION_ZIP="RRSSv2.0.zip"
RIIVOLUTION_DIR="RRSSv2.0"
GAMENAME="Pokemon Sinking Sapphire"
GAME_TYPE=HANS

ROM_MASK="*000400000011[cC]500*cxi"
ROMFS="SinkingSapphire.romfs"
DATA="${PATCHIMAGE_DATA_DIR}/Sinking Sapphire Files/Raw Files/romFS a/"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Source:			https://projectpokemon.org/forums/showthread.php?49883-Pok%E9mon-Rising-Ruby-and-Sinking-Sapphire
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
