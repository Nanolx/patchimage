#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="http://download858.mediafire.com/d8ceavb0izvg/vf7p9pu8bqxohuo/GSGBW+v1.0.2.zip"
RIIVOLUTION_ZIP="GSGBW v1.0.2.zip"
RIIVOLUTION_DIR="GSGBW/Ghostly"
GAMENAME="Ghostly Super Ghost Boos. Wii"
XML_SOURCE="${RIIVOLUTION_DIR}"
XML_FILE="${RIIVOLUTION_DIR}/../riivolution/Ghostly"
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr
WBFS_MASK="SMN[PEJ]01"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Source:			http://rvlution.net/thread/3606-ghostly-super-ghost-boos-wii-out-now/
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

detect_game_version () {

	nsmbw_version
	GAMEID=SMN${REG_LETTER}65
	XML_FILE="${XML_FILE}${REG_LETTER}.xml"

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
				cp "${RIIVOLUTION_DIR}"/MessageEN/* "${WORKDIR}"/files/EU/"${dir}"/Message/
			done
			cp "${RIIVOLUTION_DIR}"/OpeningP/* "${WORKDIR}"/files/EU/Layout/openingTitle/
		;;

		USAv* )
			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in "${LANGDIRS[@]}"; do
				cp "${RIIVOLUTION_DIR}"/MessageEN/* "${WORKDIR}"/files/US/"${dir}"/Message/
			done
			cp "${RIIVOLUTION_DIR}"/OpeningE/* "${WORKDIR}"/files/US/Layout/openingTitle/
		;;

		JPNv1 )
			cp "${RIIVOLUTION_DIR}"/MessageEN/* "${WORKDIR}"/files/JP/Message/
			cp "${RIIVOLUTION_DIR}"/OpeningJ/* "${WORKDIR}"/files/JP/Layout/openingTitle/
		;;
	esac

	cp -r "${RIIVOLUTION_DIR}"/Env/ "${WORKDIR}"/files/
	cp -r "${RIIVOLUTION_DIR}"/Layout/ "${WORKDIR}"/files/
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

	${WIT} dolpatch ${DOL} xml="${PATCHIMAGE_PATCH_DIR}/NSMBW_AP.xml" -q

}
