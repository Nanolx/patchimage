#!/bin/bash

DOWNLOAD_LINK="https://drive.google.com/uc?id=0Bw0cbznV4l_TYUpNbFVwYUtJRVU&export=download"
RIIVOLUTION_ZIP="Eternal X V1.3.zip"
RIIVOLUTION_DIR="Eternal X V1.3/Game Files/"
GAMENAME="Pokemon Eternal X"
GAME_TYPE=HANS

CXI_MASK="*0004000000055[dD]00*cxi"
ROMFS="EternalX.romfs"
DATA=""

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Eternal X is a typical difficulty/721 hack; all Pokémon are obtainable
in all versions of the games, trade evolutions are optional and it is,
of course, more difficult than the base game.

Source:			http://www.pokecommunity.com/showthread.php?t=362505
Base ROM:		Pokemon X
Supported Versions:	US, EU, JAP
************************************************"

}

viola_nerf () {

	echo "
*** Viola Nerf ***
- nerf: make the first gym leader's team weaker
- keep: keep the first gym leader's team strength

enter either 'nerf' or press [Enter] to keep:
"

	read choice

	case choice in
		[nN]erf ) HANS_EXTRA_PATH="${HANS_PATH}/Viola Nerf Files" ;;
		* ) echo "invalid choice made, keeping first gym leader's team strength" ;;
	esac

}

check_hans_files () {

	check_riivolution_patch

	echo "
*** Game Version ***
Encounter type changes the wild Pokemon availability:
- Legal Version: makes useful Hidden Abilities easily available, and adds many
	egg and tutor moves to almost every Pokémon's level up moves, all of
	which are legal in the official games (hence the name).
- Rebalanced Version: includes all of these changes, as well as base stat, type
	and movepool changes intended to make weaker Pokémon more fun to use.
* Insanity Mode: this is essentially the Rebalanced Version with some more
	challenging Trainer battles.

enter either 'legal', 'rebalanced' or 'insanity':
"

	read choice

	case ${choice} in
		[lL]egal ) HANS_PATH="${RIIVOLUTION_DIR}/Legal version"
			   DAT="${HANS_PATH}/Hans Files/"
			   viola_nerf ;;
		[rR]ebalanced ) HANS_PATH="${RIIVOLUTION_DIR}/Rebalanced version"
				DAT="${HANS_PATH}/Hans Files"
				viola_nerf ;;
		[iI]nsanity ) HANS_PATH="${RIIVOLUTION_DIR}/Insanity Mode"
			      DAT="${HANS_PATH}/Hans Files" ;;
		* ) echo "invalid choice made, using 'Rebalanced version'."
		    HANS_PATH="${RIIVOLUTION_DIR}/Rebalanced version"
		    DAT="${HANS_PATH}/Hans Files"
		    viola_nerf ;;
	esac

}

patch_romfs () {

	cp -r "${HANS_PATH}"/a romfs/
	[[ ${HANS_EXTRA_PATH} ]] && cp -r "${HANS_EXTRA_PATH}"/a romfs/

	}
