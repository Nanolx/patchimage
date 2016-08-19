#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="https://www.dropbox.com/s/nby77snj423imzx/Remixed%20v1.5.zip"
RIIVOLUTION_ZIP="Remixed v1.5.zip"
RIIVOLUTION_DIR="Remixed v1.5/remixed"
GAMENAME="Remixed Super Mario Bros. Wii"
XML_SOURCE="${RIIVOLUTION_DIR}"
XML_FILE="${RIIVOLUTION_DIR}/../riivolution/NSMBtemplate.xml"
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr
WBFS_MASK="SMN[PEJ]01"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Source:			http://rvlution.net/thread/3645-remixed-super-mario-bros-wii/
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

detect_game_version () {

	nsmbw_version
	GAMEID=SMN${REG_LETTER}60

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
				cp "${RIIVOLUTION_DIR}"/US/EngUS/Message/* "${WORKDIR}"/files/EU/"${dir}"/Message/
				cp "${RIIVOLUTION_DIR}"/US/EngUS/Font/* "${WORKDIR}"/files/EU/"${dir}"/Font/
				cp "${RIIVOLUTION_DIR}"/US/EngUS/staffroll/* "${WORKDIR}"/files/EU/"${dir}"/staffroll/
			done
			cp "${RIIVOLUTION_DIR}"/US/Layout/openingTitle/* "${WORKDIR}"/files/EU/Layout/openingTitle/
		;;

		USAv* )
			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in "${LANGDIRS[@]}"; do
				cp "${RIIVOLUTION_DIR}"/US/EngUS/Message/* "${WORKDIR}"/files/US/"${dir}"/Message/
				cp "${RIIVOLUTION_DIR}"/US/EngUS/Font/* "${WORKDIR}"/files/US/"${dir}"/Font/
				cp "${RIIVOLUTION_DIR}"/US/EngUS/staffroll/* "${WORKDIR}"/files/US/"${dir}"/staffroll/
			done
			cp "${RIIVOLUTION_DIR}"/US/Layout/openingTitle/* "${WORKDIR}"/files/US/Layout/openingTitle/
		;;

		JPNv1 )
			cp "${RIIVOLUTION_DIR}"/US/Layout/openingTitle/* "${WORKDIR}"/files/JP/Layout/openingTitle/
			cp "${RIIVOLUTION_DIR}"/US/EngUS/Message/* "${WORKDIR}"/files/JP/Message/
			cp "${RIIVOLUTION_DIR}"/US/EngUS/Font/* "${WORKDIR}"/files/JP/Font/
			cp "${RIIVOLUTION_DIR}"/US/EngUS/staffroll/* "${WORKDIR}"/files/JP/staffroll/
		;;
	esac

	cp -r "${RIIVOLUTION_DIR}"/Layout/ "${WORKDIR}"/files/
	cp -r "${RIIVOLUTION_DIR}"/US/EngUS/Layout/ "${WORKDIR}"/files/
	cp -r "${RIIVOLUTION_DIR}"/Object/ "${WORKDIR}"/files/
	cp "${RIIVOLUTION_DIR}"/Sound/Stream/* "${WORKDIR}"/files/Sound/stream/
	cp "${RIIVOLUTION_DIR}"/Sound/*.brsar "${WORKDIR}"/files/Sound/
	cp "${RIIVOLUTION_DIR}"/Stage/Texture/* "${WORKDIR}"/files/Stage/Texture/
	cp "${RIIVOLUTION_DIR}"/Stage/*.arc "${WORKDIR}"/files/Stage/
	cp "${RIIVOLUTION_DIR}"/WorldMap/* "${WORKDIR}"/files/WorldMap/

}

dolpatch () {

	cp "${XML_FILE}" "${XML_FILE}".new
	sed -e 's/80001800/803482C0/g' -i "${XML_FILE}".new
	XML_FILE="${XML_FILE}".new

	${WIT} dolpatch ${DOL} xml="${XML_FILE}" -s "${XML_SOURCE}" \
		xml="${PATCHIMAGE_PATCH_DIR}/NewerSMBW-Loader.xml" -q
	${WIT} dolpatch ${DOL} xml="${PATCHIMAGE_PATCH_DIR}/NSMBW_AP.xml" -q

}
