#!/bin/bash

GAME_TYPE="MKWIIMM"
GAME_NAME="Mario Kart Wiimm"

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

	check_input_image_kirby

}

download_wiimm () {

	echo "Choose a Mario Kart Wiimm Distribution

ALL	Build all distributions."
	gawk -F \: 'NR>1 {print $1 "\t" $2}' < script.d/mkwiimm.db
	echo "
type in ALL or an ID"
	read ID

}

build_mkwiimm () {

		DIST=$(gawk -F \: "/^${1}/"'{print $2}' < ${PATCHIMAGE_SCRIPT_DIR}/mkwiimm.db)
		DOWNLOAD=$(gawk -F \: "/^${1}/"'{print $3}' < ${PATCHIMAGE_SCRIPT_DIR}/mkwiimm.db)
		FILENAME=$(gawk -F \: "/^${1}/"'{split($3, a, "/") ; print a[3]}' < ${PATCHIMAGE_SCRIPT_DIR}/mkwiimm.db)

		if [[ ${FILENAME} != mkw* ]]; then
			echo "wrong ID passed from user-input, exiting."
			exit 1
		fi

		rm -rf ${FILENAME/.7z}

		if [[ -f ${PATCHIMAGE_RIIVOLUTION_DIR}/${FILENAME} ]]; then
			${UNP} ${PATCHIMAGE_RIIVOLUTION_DIR}/${FILENAME} >/dev/null
		elif [[ -f ${PWD}/${FILENAME} ]]; then
			${UNP} ${PWD}/${FILENAME} >/dev/null
		else
			wget -O ${PATCHIMAGE_RIIVOLUTION_DIR}/${FILENAME} ${DOWNLOAD}
			${UNP} ${PATCHIMAGE_RIIVOLUTION_DIR}/${FILENAME} >/dev/null
		fi

		cd ${FILENAME/.7z}
		ln -s ${IMAGE} .

		REG=$(gawk '/^RMC/{print $3}' <(wit ll ${IMAGE}))

		case $REG in
			PAL)	REG=P	;;
			NTSC-J)	REG=J	;;
			NTSC-U)	REG=E	;;
		esac
		chmod +x *.sh

		cp -r ${PATCHIMAGE_SCRIPT_DIR}/../override/* ${PWD}/bin/

		if [[ ${MKWIIMM_GAME_LANG} && ${MKWIIMM_MSG_LANG} && ${MKWIIMM_OWN_SAVE} ]]; then
			echo "LANGUAGE=${MKWIIMM_GAME_LANG}
MSGLANG=${MKWIIMM_MSG_LANG}
ISOMODE=wbfs
SPLITISO=
PRIV_SAVEGAME=${MKWIIMM_OWN_SAVE}" > ${PWD}/config.def

			echo "creating >${DIST}<, stand by..."
			./create-image.sh -a --dest=${PWD}/RMC${REG}${ID}.wbfs >/dev/null
		else
			echo "creating >${DIST}<"
			./create-image.sh --dest=${PWD}/RMC${REG}${ID}.wbfs
		fi

		echo "patching >${DIST}< to use custom server..."
		${WIT} cp ${PWD}/RMC${REG}${ID}.wbfs --DEST \
			${PATCHIMAGE_GAME_DIR}/RMC${REG}${ID}.wbfs \
			--update --psel=data --wiimmfi >/dev/null

		echo "cleaning up workdir..."
		cd ..
		rm -rf ${FILENAME/.7z}

		if [[ ${PATCHIMAGE_COVER_DOWNLOAD} == TRUE ]]; then
			echo -e "\n*** Z) download_covers"
			download_covers RMC${REG}${ID}
		fi

}

patch_wiimm () {

	if [[ ${ID} == ALL ]]; then
		for ID in {06..24}; do
			build_mkwiimm ${ID}
		done
	else

		build_mkwiimm ${ID}

	fi
}
