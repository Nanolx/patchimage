#!/bin/bash

GAME_TYPE="MKWIIMM"
GAMENAME="Mario Kart Wiimm"
DOWNLOAD_LINK="http://download.wiimm.de/wiimmfi/patcher/mkw-wiimmfi-patcher-v3.7z"
WBFS_MASK="RMC[PEJ]01"

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

download_wiimm () {

	echo "Choose a Mario Kart Wiimm Distribution

ALL	Build all distributions."
	gawk -F : 'NR>1 {print $1 "\t" $2}' < "${PATCHIMAGE_DATABASE_DIR}"/mkwiimm.db
	echo "
type in ALL or an ID (multiple separated by space)"
	read -r ID

}

wiimmfi () {

	mkdir -p "${HOME}/.patchimage/tools/"
	cd "${HOME}"/.patchimage/tools
	rm -rf wiimmfi-patcher/ ./*.7z*
	wget "${DOWNLOAD_LINK}" &>/dev/null || ( echo "something went wrong downloading ${DOWNLOAD_LINK}" && exit 57 )
	"${UNP}" mkw-wiimmfi-patcher.7z >/dev/null || ( echo "something went wrong extracting files" && exit 63 )
	mv mkw-wiimmfi-patcher*/ wiimmfi-patcher
	chmod +x wiimmfi-patcher/*.sh
	cd wiimmfi-patcher/

	ln -s "${1}" .
	./patch-wiimmfi.sh >/dev/null || exit 51
	echo "*** 7) storing game in ${PATCHIMAGE_GAME_DIR}/${1##*/}"
	mv ./wiimmfi-images/"${1##*/}" "${PATCHIMAGE_GAME_DIR}"/

	rm -rf "${HOME}"/.patchimage/tools/*

}

mkwiimm_distfiles () {

	if [[ -f ${PATCHIMAGE_RIIVOLUTION_DIR}/${FILENAME} ]]; then
		echo "*** 4) extracting mkwiimm files"
		"${UNP}" "${PATCHIMAGE_RIIVOLUTION_DIR}"/"${FILENAME}" >/dev/null || \
			( echo "something went wrong extracting files" && exit 63 )
	elif [[ -f ${PWD}/${FILENAME} ]]; then
		echo "*** 4) extracting mkwiimm files"
		"${UNP}" "${PWD}"/"${FILENAME}" >/dev/null || \
			( echo "something went wrong extracting files" && exit 63 )
	else
		echo "*** 4) downloading and extracting mkwiimm files"
		wget -O "${PATCHIMAGE_RIIVOLUTION_DIR}"/"${FILENAME}" "${DOWNLOAD}" >/dev/null || \
			( echo "something went wrong downloading ${DOWNLOAD}" && exit 57 )
		"${UNP}" "${PATCHIMAGE_RIIVOLUTION_DIR}"/"${FILENAME}" >/dev/null || \
			( echo "something went wrong extracting files" && exit 63 )
	fi

}

mkwiimm_build_olddist () {

	if [[ ${MKWIIMM_MSG_LANG} && ${MKWIIMM_OWN_SAVE} ]]; then
		echo "LANGUAGE=${MKWIIMM_MSG_LANG}
MSGLANG=${MKWIIMM_MSG_LANG}
ISOMODE=wbfs
SPLITISO=
PRIV_SAVEGAME=${MKWIIMM_OWN_SAVE}" > "${PWD}"/config.def
		echo "*** 5) creating >${DIST}< (can take some time)"
		./create-image.sh -a --dest="${XD}/RMC${REG}${MY_ID}".wbfs >/dev/null || exit 51
	else
		echo "*** 5) creating >${DIST}< (can take some time)"
		./create-image.sh --dest="${XD}/RMC${REG}${MY_ID}".wbfs || exit 51
	fi

}

mkwiimm_build_newdist () {

	if [[ ${MKWIIMM_MSG_LANG} && ${MKWIIMM_OWN_SAVE} && ${MKWIIMM_CTRENAME} && ${MKWIIMM_CTREORDER} ]]; then
		echo "LANGUAGE=${MKWIIMM_MSG_LANG}
MSGLANG1=-
MSGLANG2=E
TRACKLANG=x,${MKWIIMM_MSG_LANG}
CTRENAME=${MKWIIMM_CTRENAME}
REORDER=${MKWIIMM_CTREORDER}
ISOMODE=wbfs
SPLITISO=
PRIV_SAVEGAME=${MKWIIMM_OWN_SAVE}" > "${PWD}"/config.def

		echo "*** 5) creating >${DIST}< (can take some time)"
		./create-image.sh -a --dest="${XD}/RMC${REG}${MY_ID}".wbfs >/dev/null || exit 51
	else
		echo "*** 5) creating >${DIST}< (can take some time)"
		./create-image.sh --dest="${XD}/RMC${REG}${MY_ID}".wbfs || exit 51
	fi

}

build_mkwiimm () {

	MY_ID=${1}
	DIST=$(gawk -F : "/^${MY_ID}/"'{print $2}' < "${PATCHIMAGE_DATABASE_DIR}"/mkwiimm.db)
	DOWNLOAD=$(gawk -F : "/^${MY_ID}/"'{print $3}' < "${PATCHIMAGE_DATABASE_DIR}"/mkwiimm.db)
	FILENAME=$(gawk -F : "/^${MY_ID}/"'{split($3, a, "/") ; print a[3]}' < "${PATCHIMAGE_DATABASE_DIR}"/mkwiimm.db)

	if [[ ${FILENAME} != mkw* ]]; then
		echo "wrong ID passed from user-input, exiting."
		exit 75
	fi

	rm -rf "${FILENAME/.7z}"
	mkwiimm_distfiles
	cd "${FILENAME/.7z}"

	REG=$(gawk '/^RMC/{print $3}' <("${WIT}" ll "${IMAGE}"))

	case ${REG} in
		PAL)	REG=P	;;
		NTSC-J)	REG=J	;;
		NTSC-U)	REG=E	;;
	esac

	ln -s "${IMAGE}" .
	chmod +x ./*.sh

	[[ ${MKWIIMM_OVERRIDE_SZS} == "TRUE" ]] && cp -r "${PATCHIMAGE_OVERRIDE_DIR}"/* "${PWD}"/bin/

	if [[ ${MY_ID} -lt 27 ]]; then
		mkwiimm_build_olddist
	else	mkwiimm_build_newdist
	fi

	if [[ ${MY_ID} -lt 23 ]]; then
		echo "*** 6) patching >${DIST}< to use custom server"
		wiimmfi "${XD}/RMC${REG}${MY_ID}".wbfs || (echo "something went wrong wiimmfi-ing ${XD}/RMC${REG}${MY_ID}.wbfs" && exit 69)
		echo "*** 7) storing game"
	else	echo "*** 6) storing game"
	fi

	cd "${XD}"

	echo "       ${DIST} saved as ${PATCHIMAGE_GAME_DIR}/RMC${REG}${MY_ID}.wbfs"
	mv "RMC${REG}${MY_ID}".wbfs \
		"${PATCHIMAGE_GAME_DIR}/RMC${REG}${MY_ID}".wbfs || exit 51

	if [[ ${MY_ID} -lt 23 ]]; then
		echo "*** 8) cleaning up workdir"
	else
		echo "*** 7) cleaning up workdir"
	fi

	rm -rf "${FILENAME/.7z}"

	if [[ ${PATCHIMAGE_COVER_DOWNLOAD} == TRUE ]]; then
		echo -e "*** Z) download_covers\n"
		download_covers "RMC${REG}${MY_ID}"
	fi

}

patch_wiimm () {

	XD="${PWD}"
	if [[ ${ID} == ALL ]]; then
		for ID in {06..32}; do
			build_mkwiimm "${ID}"
		done
	else
		for game in ${ID[@]}; do
			build_mkwiimm "${game}"
		done
	fi
}
