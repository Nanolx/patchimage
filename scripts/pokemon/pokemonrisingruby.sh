#!/bin/bash

DOWNLOAD_LINK="https://drive.google.com/uc?id=0B-zmEVN0Mas6NUlqM1hMTnVuS00&export=download"
RIIVOLUTION_ZIP="RRSSv2.0.zip"
RIIVOLUTION_DIR="RRSSv2.0"
GAMENAME="Pokemon Rising Ruby"
GAME_TYPE=HANS

ROM_MASK="*000400000011[cC]400*cxi"
ROMFS="RisingRuby.romfs"
DATA="${PATCHIMAGE_DATA_DIR}/RisingRuby/"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Source:			https://projectpokemon.org/forums/showthread.php?49883-Pok%E9mon-Rising-Ruby-and-Sinking-Sapphire
Base ROM:		Pokemon Omega Ruby
Supported Versions:	US, EU, JAP
************************************************"

}

check_hans_files () {

	check_riivolution_patch

}

patch_romfs () {

	cp -r "${RIIVOLUTION_DIR}/Rising Ruby Files/Raw Files/romFS a/" romfs/a/

	}
