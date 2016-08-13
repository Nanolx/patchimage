#!/bin/bash

DOWNLOAD_LINK="mega:///#!z9oEwB4R!8Ab1mp23iEYnAdekP-rH3VrWNe_kUAoTgrh5_oU9BdE"
RIIVOLUTION_ZIP="Pokemon Delta Emerald.zip"
GAMENAME="Pokemon Delta Emerald (Alpha Saphhire)"
PATCH="Pokemon - Delta Emerald.xdelta"
GAME_TYPE=HANS
HANS_DELTA=TRUE

ROM_MASK="*000400000011[cC]500*cxi"
ROMFS="DeltaEmerald-AS.romfs"
DATA="${PATCHIMAGE_DATA_DIR}/DeltaEmerald-AS/"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Source:			https://gbatemp.net/threads/or-as-pokemon-delta-emerald-rom-hack.421637/
Base ROM:		Pokemon Alpha Sapphire
Supported Versions:	US, EU, JAP
************************************************"

}

check_hans_files () {

	check_riivolution_patch --nofail

}
