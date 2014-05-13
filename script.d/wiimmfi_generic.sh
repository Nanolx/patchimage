#!/bin/bash

DOWNLOAD_LINK="http://download.wiimm.de/wiimmfi/mkw-wiimmfi-patcher.7z"
GAME_TYPE="MKWIIMM"
GAME_NAME="Mario Kart Wiimmfi"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Patches Mario Kart Wii to use Wiimm's custom server

Source:			http://wiiki.wii-homebrew.com/Wiimmfi-Patcher
Base Image:		Mario Kart Wii (RMC?01)
Supported Versions:	EUR, JAP, USA
************************************************"

}

check_input_image_special () {

	if [[ ${IMAGE} ]]; then
		ask_input_image_wiimmfi ${PWD}
		GAMEDIR=${PWD}
	else
		ask_input_image_wiimmfi ${PATCHIMAGE_WBFS_DIR}
		GAMEDIR=${PATCHIMAGE_WBFS_DIR}
	fi

	echo -e "type ??????.wbfs (or ??????.iso):\n"
	read ID

}

download_wiimm () {

	return 0

}

patch_wiimm () {

	if [[ ! -f ${GAMEDIR}/${ID} ]]; then
		echo "unvalid game passed from user-input. exit"
		exit 1
	fi

	cp -v ${GAMEDIR}/${ID} . 2>/dev/null
	wit cp ${ID} --DEST wiimmfi-images/ --update --psel=data --wiimmfi -vv >/dev/null
	mv -v ./wiimmfi-images/${ID} "${PATCHIMAGE_GAME_DIR}"/
	rm -f ${ID}

	if [[ ${PATCHIMAGE_COVER_DOWNLOAD} == TRUE ]]; then
		echo "\n*** Z) download_covers"
		download_covers ${ID/.*}
	fi

	rmdir wiimmfi-images/

}
