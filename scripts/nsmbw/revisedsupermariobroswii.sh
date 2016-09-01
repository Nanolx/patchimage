#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="https://www.dropbox.com/s/0hrmxz3gh7b3b1q/RSMBW%20Version%201.1.zip"
RIIVOLUTION_ZIP="RSMBW Version 1.1.zip"
RIIVOLUTION_DIR="rsmbw"
GAMENAME="Revised Super Mario Bros. Wii"
XML_SOURCE="${RIIVOLUTION_DIR}/"
XML_FILE="${RIIVOLUTION_DIR}/../riivolution/RSMBW.xml"
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr
WBFS_MASK="SMN[PEJ]01"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Source:			http://rvlution.net/thread/4579-revised-super-mario-bros-wii/
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

detect_game_version () {

	nsmbw_version
	GAMEID=SMN${REG_LETTER}69
}

place_files () {

	NEW_DIRS=( "${WORKDIR}"/files/EU/NedEU/{Message,Font,staffroll} )
	for dir in "${NEW_DIRS[@]}"; do
		mkdir -p "${dir}"
	done

	case ${VERSION} in
		EUR* )
			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU NedEU )
			for dir in "${LANGDIRS[@]}"; do
				cp "${RIIVOLUTION_DIR}"/Lang/EUENGLISH.arc "${WORKDIR}"/files/EU/"${dir}"/Message/Message.arc
			done
		;;

		USAv* )
			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in "${LANGDIRS[@]}"; do
				cp "${RIIVOLUTION_DIR}"/Lang/USENGLISH.arc "${WORKDIR}"/files/US/"${dir}"/Message/Message.arc
				cp "${RIIVOLUTION_DIR}"/staffroll/staffroll.bin "${WORKDIR}"/files/US/"${dir}"/staffroll/
			done
			cp "${RIIVOLUTION_DIR}"/Layout/openingTitle.arc "${WORKDIR}"/files/US/Layout/openingTitle/
		;;

		JPNv1 )
			cp "${RIIVOLUTION_DIR}"/Layout/openingTitle.arc "${WORKDIR}"/files/JP/Layout/openingTitle/
		;;
	esac

	cp -r "${RIIVOLUTION_DIR}"/Object/ "${WORKDIR}"/files/
	cp "${RIIVOLUTION_DIR}"/Sound/*.brsar "${WORKDIR}"/files/Sound/
	cp "${RIIVOLUTION_DIR}"/Stage/Texture/* "${WORKDIR}"/files/Stage/Texture/
	cp "${RIIVOLUTION_DIR}"/Stage/*.arc "${WORKDIR}"/files/Stage/

}

dolpatch () {

	cp "${XML_FILE}" "${XML_FILE}".new
	sed -e 's/80001800/803482C0/g' -i "${XML_FILE}".new
	XML_FILE="${XML_FILE}".new

	${WIT} dolpatch ${DOL} xml="${PATCHIMAGE_PATCH_DIR}/NSMBW_AP.xml" -q

}
