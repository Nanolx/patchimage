#!/bin/bash

GAME_TYPE="MKWIIMM"
GAME_NAME="Mario Kart Wiimm"
ITEMS_BASE="http://riivolution.nanolx.org/mkwiimm_karts"

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

	check_input_image_mkwiimm
	ask_input_image_mkwiimm ${IMAGE%/*}
	echo -e "type RMC???.wbfs:\n"
	read ID

	if [[ ! -f ${IMAGE%/*}/${ID} ]]; then
		echo "wrong id from user-input given."
		exit 75
	fi

}

ask_slot () {

	echo -e "\nFirst choose a vehicle to be replaced\n"
	gawk -F \: '{print $1 "\t\t" $2}' < ${PATCHIMAGE_SCRIPT_DIR}/mkwiimm_vehicles.db
	echo -e "\ntype in ??_??? as in first column\n"
	read VEHICLE

	echo -e "\nNow choose a character to be replaced\n"
	gawk -F \: '{print $1 "\t\t" $2}' < ${PATCHIMAGE_SCRIPT_DIR}/mkwiimm_characters.db
	echo -e "\ntype in -?? as in first column\n"
	read CHARACTER

	choosenkarts=( ${choosenkarts[@]} ${kart}:${VEHICLE}${CHARACTER} )

}

download_wiimm () {

	if [[ -f ${HOME}/.patchimage.choice ]]; then
		echo "Your choices from last time can be re-used."
		echo "y (yes) or n (no)"
		read choice

		if [[ ${choice} == y ]]; then
			source ${HOME}/.patchimage.choice
		fi
	fi

	if [[ ${choosenkarts[@]} == "" ]]; then
		echo -e "Choose a character to add to the game\n"

		gawk -F \: '{print $1 "\t\t" $2}' < ${PATCHIMAGE_SCRIPT_DIR}/mkwiimm_karts.db

		echo -e "\ntype ???.szs (multiple possible, space separated)"
		read KART

		for kart in ${KART[@]}; do
			if [[ ! -f ${PATCHIMAGE_RIIVOLUTION_DIR}/mkwiimm_kart_${kart} ]]; then
				wget -O ${PATCHIMAGE_RIIVOLUTION_DIR}/mkwiimm_kart_${kart} \
					${ITEMS_BASE}/${kart} &>/dev/null \
					|| (echo "download of ${kart} failed." \
					&& rm ${PATCHIMAGE_RIIVOLUTION_DIR}/${KART} \
					&& exit 57)
			fi
		done

		echo ${choosenkarts[@]}
		echo "choosenkarts=( ${choosenkarts[@]} )" > ${HOME}/.patchimage.choice
	fi

}

build_mkwiimm () {

	rm -rf workdir
	echo "*** 5) extracting image"
	${WIT} extract ${IMAGE%/*}/${ID} workdir -q || exit 51

	if [[ ! -d "${PATCHIMAGE_RIIVOLUTION_DIR}"/${ID/.*}_SZS ]]; then
		echo "*** 6) this is the first run, so backing up original files
(in ${PATCHIMAGE_RIIVOLUTION_DIR}) for future customizations"
		mkdir "${PATCHIMAGE_RIIVOLUTION_DIR}"/${ID/.*}_SZS
		cp workdir/files/Race/Kart/* \
			"${PATCHIMAGE_RIIVOLUTION_DIR}"/${ID/.*}_SZS
	else
		echo "*** 6) restoring original files"
		cp "${PATCHIMAGE_RIIVOLUTION_DIR}"/${ID/.*}_SZS/* \
			workdir/files/Race/Kart/
	fi

	echo "*** 7) replacing kart(s)"
	for kart in ${choosenkarts[@]}; do
		source=${kart/*:}
		dest=${kart/:*}
		echo "       old: ${dest}.szs	new: ${source}"
		cp "${PATCHIMAGE_RIIVOLUTION_DIR}"/mkwiimm_kart_${source} \
			workdir/files/Race/Kart/${dest}.szs
		cp "${PATCHIMAGE_RIIVOLUTION_DIR}"/mkwiimm_kart_${source} \
			workdir/files/Race/Kart/${dest}_2.szs
		cp "${PATCHIMAGE_RIIVOLUTION_DIR}"/mkwiimm_kart_${source} \
			workdir/files/Race/Kart/${dest}_4.szs
	done

	echo "*** 8) rebuilding game"
	echo "       (storing game in ${PATCHIMAGE_GAME_DIR}/${ID})"
	${WIT} cp -o -q -B workdir ${PATCHIMAGE_GAME_DIR}/${ID} || exit 51

	rm -rf workdir

}

patch_wiimm () {

	build_mkwiimm

}
