#!/bin/bash

GAME_TYPE="MKWIIMM"
GAME_NAME="Mario Kart Wiimm"
ITEMS_BASE="http://riivolution.nanolx.org/mkwiimm_fonts"
FSZS="files/Scene/UI/Font.szs"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Custom Mario Kart Wii

Source:			http://wiiki.wii-homebrew.com/Wiimms_Mario_Kart_Fun
Base Image:		Mario Kart Wii (RMC?01)
Supported Versions:	EUR, JAP, USA
************************************************"

}

check_input_image_special () {

	check_input_image_mkwiimm
	ask_input_image_mkwiimm ${IMAGE%/*}
	echo -e "type RMC???.wbfs:\n"
	read ID

	if [[ ! -f ${IMAGE%/*}/${ID} ]]; then
		echo "wrong id from user-input given."
		exit 75
	fi

}

download_wiimm () {

	echo "Choose a font to use

orig		Original Mario Kart Wii Font"

	gawk -F \: '{print $1 "\t\t" $2}' < ${PATCHIMAGE_SCRIPT_DIR}/mkwiimm_fonts.db

	echo -e "\ntype ???.szs or orig"
	read FONT

	if [[ ${FONT} != orig ]]; then
		if [[ ! -f ${PATCHIMAGE_RIIVOLUTION_DIR}/${FONT} ]]; then
			wget -O ${PATCHIMAGE_RIIVOLUTION_DIR}/${FONT} \
				${ITEMS_BASE}/${FONT} &>/dev/null \
				|| (echo "download of ${FONT} failed." \
				&& rm ${PATCHIMAGE_RIIVOLUTION_DIR}/${FONT} \
				&& exit 57)
		fi
	fi

}

build_mkwiimm () {

	rm -rf workdir
	echo "*** 5) extracting image"
	${WIT} extract ${IMAGE%/*}/${ID} workdir -q || exit 51

	if [[ ! -f "${PATCHIMAGE_RIIVOLUTION_DIR}"/Font.szs_${ID/.*} ]]; then
		echo "*** 6) this is the first run, so backing up font.szs
(in ${PATCHIMAGE_RIIVOLUTION_DIR}) for future customizations"
		cp workdir/${FSZS} "${PATCHIMAGE_RIIVOLUTION_DIR}"/Font.szs_${ID/.*}
	else
		echo "*** 6) restoring original common.szs"
		cp "${PATCHIMAGE_RIIVOLUTION_DIR}"/Font.szs_${ID/.*} workdir/${FSZS}
	fi

	echo "*** 7) replacing font"
	cp "${PATCHIMAGE_RIIVOLUTION_DIR}"/${FONT} workdir/${FSZS}

	echo "*** 8) rebuilding game"
	echo "       (storing game in ${PATCHIMAGE_GAME_DIR}/${ID})"
	${WIT} cp -o -q -B workdir ${PATCHIMAGE_GAME_DIR}/${ID} || exit 51

	rm -rf workdir

}

patch_wiimm () {

	build_mkwiimm

}
