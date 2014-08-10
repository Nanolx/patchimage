#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="http://riivolution.nanolx.org/DUSMBAE%20Riivo%20Release%20Pack%20rev1.rar"
RIIVOLUTION_ZIP="DUSMBAE Riivo Release Pack rev1.rar"
RIIVOLUTION_DIR="DUSMBAE Riivo Release Pack"
GAMENAME="DarkUmbra SMB Anniversary Edition"
XML_SOURCE="${RIIVOLUTION_DIR}"
XML_FILE="${RIIVOLUTION_DIR}"/dusmbaePAL.xml
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Source:			http://rvlution.net/thread/2232-darkumbra-smb-anniversary-edition-rev1/
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2
************************************************"

}

check_input_image_special () {

	check_input_image_nsmb

}

detect_game_version () {

	nsmbw_version
	GAMEID=SMN${REG_LETTER}DU

	if [[ ${VERSION} != EUR* ]]; then
		echo "only PAL games supported by this hack."
		exit 81
	fi

}

place_files () {


	cp -r "${RIIVOLUTION_DIR}"/dusmbae/files/ ${WORKDIR}/

}


dolpatch() {

	${WIT} dolpatch ${DOL}	\
		"802F148C=53756D6D53756E#7769696D6A3264" \
		"802F118C=53756D6D53756E#7769696D6A3264" \
		"802F0F8C=53756D6D53756E#7769696D6A3264" \
		xml="${PATCHIMAGE_PATCH_DIR}/NSMBW_AP.xml" -q

}
