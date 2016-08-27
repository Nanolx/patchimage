#!/bin/bash

DOWNLOAD_LINK="http://download842.mediafire.com/610594k0d1dg/nd9z16t5nb92743/Neo+X+and+Y+Files.rar"
RIIVOLUTION_ZIP="Neo X and Y Files.rar"
RIIVOLUTION_DIR="Neo X and Y Files/Pokemon NeoXY1.4/Installation hub/data/"
GAMENAME="Pokemon Neo X"
GAME_TYPE=HANS

ROM_MASK="*0004000000055[dD]00*cxi"
ROMFS="neox.romfs"
DATA="${PATCHIMAGE_DATA_DIR}/NeoX"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Neo X & Neo Y are rom hacks of Pokemon X and Y designed to offer the player
greater difficulty through expanded trainers and better variety through edited
wild Pokemon encounters along with a plethora of other features.

NeoX & NeoY are pretty much identical at this stage.​

Source:			https://gbatemp.net/threads/pokemon-neo-x-neo-y.388272/
Base ROM:		Pokemon X
Supported Versions:	US, EU, JAP
************************************************"

}

check_hans_files () {

	check_riivolution_patch

	echo "
*** Full vs. Lite Version ***
- Full version contains all the features mentioned in Homepage
- Lite version contains only edited trainers and wild Pokemon encounters

enter either 'full' or 'lite':
"

	read -er choice

	case ${choice} in
		[fF]ull ) HANS_PATH="${RIIVOLUTION_DIR}"/Full/romfs ;;
		[lL]ite ) HANS_PATH="${RIIVOLUTION_DIR}"/Lite/romfs ;;
		* ) echo "invalid choice made, using 'Full version'."
		    HANS_PATH="${RIIVOLUTION_DIR}"/Full/romfs ;;
	esac

}

patch_romfs () {

	cp -r "${HANS_PATH}"/* romfs/

	}
