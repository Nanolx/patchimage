#!/bin/bash

DOWNLOAD_LINK="http://download.wiimm.de/wiimmfi/mkw-wiimmfi-patcher.7z"
GAME_TYPE="MKWIIMM"

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
	IMAGE_DIR=${IMAGE%/*}

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
	for image in "${IMAGE_DIR}"/RMC???.iso "${IMAGE_DIR}"/RMC???.wbfs; do
		if [[ -e ${image} ]]; then
			cp -v "${image}" .
			./create-image.sh >/dev/null
			mv -v ./wiimmfi-images/${image##*/} "${PATCHIMAGE_GAME_DIR}/"
			rm ${image##*/}
		fi
	done
	rm -rf ${HOME}/.patchimage/tools/wiimfi-patcher/
}
