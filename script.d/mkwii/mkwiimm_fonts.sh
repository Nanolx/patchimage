#!/bin/bash

GAME_TYPE="WII_GENERIC"
GAME_NAME="Mario Kart Wiimm"
FSZS="files/Scene/UI/Font.szs"
WBFS_MASK="RMC[PUJ]01"

show_notes () {

echo -e \
"************************************************
${GAME_NAME}

Custom Mario Kart Wii

Source:			http://wiiki.wii-homebrew.com/Wiimms_Mario_Kart_Fun
Base Image:		Mario Kart Wii (RMC?01)
Supported Versions:	EUR, JAP, USA
************************************************"

}

check_input_image_special () {

	ask_input_image_mkwiimm
	echo -e "type ALL or RMC???.wbfs:\n"
	read ID

	if [[ -f ${PWD}/${ID} ]]; then
		GAMEDIR=${PWD}
	elif [[ -f ${PATCHIMAGE_WBFS_DIR}/${ID} ]]; then
		GAMEDIR=${PATCHIMAGE_WBFS_DIR}
	else	echo "invalid user input."
		exit 75
	fi

}

download_wiimm () {

	echo "Choose a font to use

orig		Original Mario Kart Wii Font"

	gawk -F \: '{print $1 "\t\t" $2}' < ${PATCHIMAGE_DATABASE_DIR}/mkwiimm_fonts.db

	echo -e "\ntype ???.szs or orig"
	read FONT

	if [[ ${FONT} != orig ]]; then
		if [[ ! -f ${PATCHIMAGE_DATA_DIR}/mkwiimm_fonts/${FONT} ]]; then
			echo "Font ${FONT} unknown"
			exit 75
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
	cp "${PATCHIMAGE_DATA_DIR}"/mkwiimm_fonts/${FONT} workdir/${FSZS}

	echo "*** 8) rebuilding game"
	echo "       (storing game in ${PATCHIMAGE_GAME_DIR}/${ID})"
	${WIT} cp -o -q -B workdir ${PATCHIMAGE_GAME_DIR}/${ID} || exit 51

	rm -rf workdir

}

pi_action () {

	download_wiimm
	build_mkwiimm

}
