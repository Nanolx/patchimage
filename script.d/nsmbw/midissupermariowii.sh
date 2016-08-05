#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="http://www.nanolx.org/riivolution/MSBWii.rar"
RIIVOLUTION_ZIP="MSMBWii.zip"
RIIVOLUTION_DIR="msmbwiijala"
GAMENAME="Midi's Super Mario Wii - Just A Little Adventure"
XML_SOURCE="${RIIVOLUTION_DIR}"
XML_FILE="${RIIVOLUTION_DIR}"/../riivolution/MSMBWIIJALA.xml
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr
WBFS_MASK="SMN[PUJ]01"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Source:			http://rvlution.net/thread/2016-midi-s-super-mario-wii-just-a-little-adventure/
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

detect_game_version () {

	nsmbw_version

	GAMEID=SMN${REG_LETTER}MI

}

place_files () {


	case ${VERSION} in
		USAv* )
			cp "${RIIVOLUTION_DIR}"/Title/US/openingTitle.arc ${WORKDIR}/files/US/Layout/openingTitle/
		;;
	esac

	cp -r "${RIIVOLUTION_DIR}"/Texture/ ${WORKDIR}/files/Stage/
	cp -r "${RIIVOLUTION_DIR}"/AnotherRes/ ${WORKDIR}/files/
	cp "${RIIVOLUTION_DIR}"/*.arc ${WORKDIR}/files/Stage/

}


dolpatch() {

	cp "${XML_FILE}" "${XML_FILE}".new
	sed -e 's/80001800/803482C0/g' -i "${XML_FILE}".new
	XML_FILE="${XML_FILE}".new

	${WIT} dolpatch ${DOL} xml="${XML_FILE}" -s "${XML_SOURCE}" xml="${PATCHIMAGE_PATCH_DIR}/AnotherSMB-Loader.xml" -q
	${WIT} dolpatch ${DOL} xml="${PATCHIMAGE_PATCH_DIR}/NSMBW_AP.xml" -q

}
