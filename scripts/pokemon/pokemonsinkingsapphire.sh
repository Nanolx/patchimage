#!/bin/bash

DOWNLOAD_LINK="https://drive.google.com/uc?id=0B-zmEVN0Mas6Qm5jYXZkVy1QZjA&export=download"

RIIVOLUTION_ZIP="RRSSv2.1.zip"
RIIVOLUTION_DIR="RRSSv2.1"
GAMENAME="Pokemon Sinking Sapphire"
GAME_TYPE=HANS

ROM_MASK="*000400000011[cC]500*cxi"
ROMFS="SinkingSapphire.romfs"
DATA="${PATCHIMAGE_DATA_DIR}/Sinking Sapphire/"

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

	cp -r "${RIIVOLUTION_DIR}/Drop-In Files/Sinking Sapphire/Drop-It-In (CRO FOR LUMA3DS ONLY)/romfs/a/" romfs/

	}
