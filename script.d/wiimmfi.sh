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

	check_input_image_mkwiimm
	ask_input_image_mkwiimm ${IMAGE%/*}
	echo -e "type ALL or RMC???.wbfs:\n"
	read ID

}

download_wiimm () {

	mkdir -p "${HOME}/.patchimage/tools/"
	cd ${HOME}/.patchimage/tools
	rm -rf wiimmfi-patcher/ *.7z*
	wget "${DOWNLOAD_LINK}"
	${UNP} mkw-wiimmfi-patcher.7z >/dev/null
	mv mkw-wiimmfi-patcher*/ wiimmfi-patcher
	chmod +x wiimmfi-patcher/*.sh
	rm *.7z
}

patch_wiimm () {

	cd ${HOME}/.patchimage/tools/wiimmfi-patcher/

	if [[ ${ID} == ALL ]]; then
		for image in ${IMAGE%/*}/RMC???.{iso,wbfs}; do
			if [[ -e ${image} ]]; then
				ln -s "${image}" .
			fi
		done

			./create-image.sh >/dev/null
			mv -v ./wiimmfi-images/* "${PATCHIMAGE_GAME_DIR}"/

	else
		if [[ ! -f ${IMAGE%/*}/${ID} ]]; then
			echo "unvalid game passed from user-input. exit"
			exit 1
		fi

		ln -s ${IMAGE%/*}/${ID} .
		./create-image.sh >/dev/null
		mv -v ./wiimmfi-images/${ID} "${PATCHIMAGE_GAME_DIR}"/
	fi

	rm -rf ${HOME}/.patchimage/tools/wiimfi-patcher/
}
