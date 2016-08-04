#!/bin/bash

GAMENAME="Bravely Second Uncensored"
GAME_TYPE=HANS

CXI_MASK="*000400000017[bB][bB]00*cxi"
ROMFS="0017BB00.romfs"

UNP_EXTRA_ARGS="-- -pAsia81"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Source:			https://gbatemp.net/threads/released-bravely-default-second-uncensored.391715/
Base ROM:		Bravely Second
Supported Versions:	US, EU
************************************************"

}

check_hans_files () {

	echo "
*** Game Version ***
	EU	patch European version of Bravely Second
	US	patch US version of Bravely Second

enter either 'EU' or 'US':
"

	read choice

	case ${choice} in
		eu | EU )
			DOWNLOAD_LINK="mega:///#!N0QEHLRB!g_Wy5dngt4xgVXtk1BhQaqSSRj0phjP6xMp776OSEo8"
			RIIVOLUTION_ZIP="Bravely_Second_Uncensored_EUR_MINI_Asia81.rar"
			RIIVOLUTION_DIR="Bravely_Second_Uncensored_EUR_MINI_Asia81/ExtractedRomFS"
		;;

		us | US )
			DOWNLOAD_LINK="mega:///#!9sx1QKRQ!A6qzCkvY9HmPGu4VIy1TiikTRgbE-vUho99LOYWxA84"
			RIIVOLUTION_ZIP="Bravely_Second_Uncensored_USA_MINI_Asia81.rar"
			RIIVOLUTION_DIR="Bravely_Second_Uncensored_USA_MINI_Asia81/ExtractedRomFS"
		;;

		* ) echo "invalid choice made, exiting!"
		    exit 75
		;;
	esac

	check_riivolution_patch

}

patch_romfs () {

	cp -r "${RIIVOLUTION_DIR}"/* romfs/

	}
