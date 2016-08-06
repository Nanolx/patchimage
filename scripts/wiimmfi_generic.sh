#!/bin/bash

DOWNLOAD_LINK="http://download.wiimm.de/wiimmfi/patcher/wiimmfi-patcher-v3.7z"
GAME_TYPE="GENERIC"
GAMENAME="Mario Kart Wiimmfi"

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

	ask_input_image_wiimmfi

	echo -e "type ??????.wbfs (or ??????.iso):\n"
	read -r ID

	if [[ -f ${PWD}/${ID} ]]; then
		GAMEDIR="${PWD}"
	elif [[ -f ${PATCHIMAGE_WBFS_DIR}/${ID} ]]; then
		GAMEDIR="${PATCHIMAGE_WBFS_DIR}"
	else	echo "invalid user input."
		exit 75
	fi

}

pi_action () {

	cp -v "${GAMEDIR}"/"${ID}" . 2>/dev/null
	"${WIT}" cp -o "${ID}" --DEST "${PATCHIMAGE_GAME_DIR}"/"${ID}" \
		--update --psel=data --wiimmfi >/dev/null || \
		( echo "wiimmfi-ing the images failed." && exit 69 )
	rm -f "${ID}"

	if [[ ${PATCHIMAGE_COVER_DOWNLOAD} == TRUE ]]; then
		echo -e "\n*** Z) download_covers"
		download_covers "${ID/.*}"
	fi

}
