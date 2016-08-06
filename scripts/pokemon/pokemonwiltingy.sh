#!/bin/bash

DOWNLOAD_LINK="https://drive.google.com/uc?id=0Bw0cbznV4l_TNC1vVklzTFhDNTg&export=download"
RIIVOLUTION_ZIP="Wilting Y V1.3.zip"
RIIVOLUTION_DIR="Wilting Y V1.3/Game Files/"
GAMENAME="Pokemon Wilting Y"
GAME_TYPE=HANS

ROM_MASK="*0004000000055[eE]00*cxi"
ROMFS="WiltingY.romfs"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Wilting Y is a typical difficulty/721 hack; all Pokémon are obtainable
in all versions of the games, trade evolutions are optional and it is,
of course, more difficult than the base game.

Source:			http://www.pokecommunity.com/showthread.php?t=362505
Base ROM:		Pokemon Y
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

	read -r choice

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

	read -r choice

	case ${choice} in
		[lL]egal ) HANS_PATH="${RIIVOLUTION_DIR}/Legal version"
			   viola_nerf ;;
		[rR]ebalanced ) HANS_PATH="${RIIVOLUTION_DIR}/Rebalanced version"
				viola_nerf ;;
		[iI]nsanity ) HANS_PATH="${RIIVOLUTION_DIR}/Insanity Mode" ;;
		* ) echo "invalid choice made, using 'Rebalanced version'."
		    HANS_PATH="${RIIVOLUTION_DIR}/Rebalanced version"
		    viola_nerf ;;
	esac

	DATA="${HANS_PATH}/Hans Files"

}

patch_romfs () {

	cp -r "${HANS_PATH}"/a romfs/
	[[ ${HANS_EXTRA_PATH} ]] && cp -r "${HANS_EXTRA_PATH}"/a romfs/

	}
