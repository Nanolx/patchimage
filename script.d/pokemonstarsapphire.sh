#!/bin/bash

DOWNLOAD_LINK="https://mega.nz/#!JQpjzZSK!NFJjbRHMtM_q3UaFKGdn_aGqvxfZYsyUxSABeXb_ySo"
RIIVOLUTION_ZIP="Star Sapphire 2.0 - Distribution.zip"
RIIVOLUTION_DIR="Star Sapphire - Distribution"
GAMENAME="Pokemon Star Sapphire"
GAME_TYPE=HANS

CXI_MASK="*000400000011[cC]500*cxi"
ROMFS="ssapphire.romfs"
DATA="${RIIVOLUTION_DIR}/HansPack/"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Pokémon Rutile Ruby and Star Sapphire are romhacks of Pokémon Omega Ruby and
Alpha Sapphire. Their main purpose is to provide a more challenging game
experience while not artificially limiting the player. The premier feature of
Rutile Ruby and Star Sapphire is the ground-up redesign of Pokémon Trainers in
the world to increase the game's challenge. Every trainer in the game has been
edited, and the level curve expects use of the Experience Share, which means
that you level up very quickly. You should be hitting Level 100 by the time you
get to the Elite Four.

Source:			https://projectpokemon.org/forums/showthread.php?46315
Base ROM:		Pokemon Alpha Sapphire
Supported Versions:	US, EU, JAP
************************************************"

}

check_input_rom () {

	if [[ ! ${CXI} ]]; then
		CXI=$(find . -name ${CXI_MASK} | sed -e 's,./,,')
		if [[ -f ${CXI} ]]; then
			CXI=${CXI}
			RFS=${ROMFS}
			DAT=${DATA}
		else
			echo -e "error: could not find suitable ROM, specify using --rom"
			exit 15
		fi
	fi

}

check_hans_files () {

	check_riivolution_patch

	echo "
*** Encounter Type ***
Encounter type changes the wild Pokemon availability:
- Legit Build: All Wild Pokémon are 100% legit for trade and will not appear as
	'hacked' by any legitimacy testers. Post-game foreign Pokémon are unlocked
	from the start, and rarities and Hordes are adjusted.
- Leveled Build: Wild Pokémon are the same as in the Legit Build, but are leveled
	up to keep pace with RR/SS's harsh level curve. A quick adjustment in PKHeX
	(editing Met Level) will make them 100% legit.
- 679 Build: Wild Pokémon are altered so that every non-Legendary non-Starter
	species is available, at the same level as the Leveled Build. Legendary
	encounters are not changed in this or any Build.

enter either 'legit', 'leveled' or '679':
"

	read choice

	case ${choice} in
		[lL]egit ) HANS_EXTRA_PATH="${RIIVOLUTION_DIR}/Encounter Type/Legit Build" ;;
		[lL]eveled ) HANS_EXTRA_PATH="${RIIVOLUTION_DIR}/Encounter Type/Leveled Build";;
		679 ) HANS_EXTRA_PATH="${RIIVOLUTION_DIR}/Encounter Type/679 Build" ;;
		* ) echo "invalid choice made, using 'Legit' build."
		    HANS_EXTRA_PATH="${RIIVOLUTION_DIR}/Encounter Type/Legit Build" ;;
	esac

	HANS_PATH="${RIIVOLUTION_DIR}/romfs"

}

patch_romfs () {

	cp -r "${HANS_PATH}"/* romfs/
	cp -r "${HANS_EXTRA_PATH}"/* romfs/

	}
