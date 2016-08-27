#!/bin/bash

GAMENAME="Bravely Second Uncensored"
GAME_TYPE=HANS
HANS_MULTI_SOURCE=TRUE

ROM_MASK_EUR="*000400000017[bB][bB]00*cxi"
ROM_MASK_USA="*000400000017[bB][aA]00*cxi"

UNP_EXTRA_ARGS="-pAsia81"

DATA="${PATCHIMAGE_DATA_DIR}/BravelySecondUncensored/"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Source:			https://gbatemp.net/threads/released-bravely-default-second-uncensored.391715/
Base ROM:		Bravely Second
Supported Versions:	US, EU
************************************************"

}

check_input_rom_special () {

	GAME_VERSION=EUR
	ROM_MASK=${ROM_MASK_EUR}
	echo "<< trying EUR game version"
	check_input_rom

	if [[ ! ${ROM} ]]; then
		GAME_VERSION=USA
		ROM_MASK=${ROM_MASK_USA}
		echo "<< trying USA game version"
		check_input_rom
	fi

	if [[ ! ${ROM} ]]; then
		echo -e "\nneither EUR nor USA version of Bravely Second found."
		exit 15
	fi

	case ${GAME_VERSION} in
		EUR )
			echo ">> found EUR game version"
			ROMFS="0017BB00.romfs"
			DOWNLOAD_LINK="https://mega.nz/#!N0QEHLRB!g_Wy5dngt4xgVXtk1BhQaqSSRj0phjP6xMp776OSEo8"
			RIIVOLUTION_ZIP="Bravely_Second_Uncensored_EUR_MINI_Asia81.rar"
			RIIVOLUTION_DIR="Bravely_Second_Uncensored_EUR_MINI_Asia81/ExtractedRomFS"
		;;

		USA )
			echo ">> found USA game version"
			ROMFS="0017BA00.romfs"
			DOWNLOAD_LINK="https://mega.nz/#!9sx1QKRQ!A6qzCkvY9HmPGu4VIy1TiikTRgbE-vUho99LOYWxA84"
			RIIVOLUTION_ZIP="Bravely_Second_Uncensored_USA_MINI_Asia81.rar"
			RIIVOLUTION_DIR="Bravely_Second_Uncensored_USA_MINI_Asia81/ExtractedRomFS"
		;;
	esac

}

check_hans_files () {

	check_riivolution_patch

}

patch_romfs () {

	cp -r "${RIIVOLUTION_DIR}"/* romfs/

	}
