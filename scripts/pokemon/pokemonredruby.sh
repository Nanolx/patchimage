#!/bin/bash

DOWNLOAD_LINK="http://download2009.mediafire.com/kv9pjged8ueg/8tacxp6oz5cw6c8/Pokemon+Red+Ruby.rar"
RIIVOLUTION_ZIP="Pokemon Red Ruby.rar"
RIIVOLUTION_DIR="Installation Files"
GAMENAME="Pokemon Red Ruby"
GAME_TYPE=HANS

ROM_MASK="*000400000011[cC]400*cxi"
ROMFS="redruby.romfs"
DATA="${PATCHIMAGE_DATA_DIR}/RedRuby/"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Pokemon Red Ruby is rom hack of Pokemon Omega Ruby

Source:			https://gbatemp.net/threads/oras-romhack-pokemon-red-ruby.425268/
Base ROM:		Pokemon Omega Ruby
Supported Versions:	US, EU, JAP
************************************************"

}

check_hans_files () {

	check_riivolution_patch
	HANS_PATH="${RIIVOLUTION_DIR}"/romfs

}

patch_romfs () {

	cp -r "${HANS_PATH}"/* romfs/

	}
