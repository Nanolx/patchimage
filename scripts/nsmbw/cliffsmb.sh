#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="http://www.mediafire.com/download/u9tdfcg5k3r2ro6/Cliff_Super_Mario_Brothers_Wiiv1.0.5.zip"
RIIVOLUTION_ZIP="Cliff_Super_Mario_Brothers_Wiiv1.0.5.zip"
RIIVOLUTION_DIR="Cliff"
GAMENAME="Cliff Super Mario Bros. Wii"
XML_SOURCE="${RIIVOLUTION_DIR}"
XML_FILE="${RIIVOLUTION_DIR}"/../XMLs/Cliff
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr
WBFS_MASK="SMN[PEJ]01"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Source:			http://rvlution.net/thread/4042-cliff-super-mario-bros-wii/
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

detect_game_version () {

	nsmbw_version
	GAMEID=SCL${REG_LETTER}01
	XML_FILE="${XML_FILE}"${REG_LETTER}.xml

}

place_files () {

	case ${VERSION} in
		EUR* )
			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU )
			for dir in "${LANGDIRS[@]}"; do
				cp "${RIIVOLUTION_DIR}"/MessageEN/Message.arc "${WORKDIR}"/files/EU/"${dir}"/Message/Message.arc
			done
			cp -r "${RIIVOLUTION_DIR}"/OpeningP/openingTitle.arc "${WORKDIR}"/files/EU/Layout/openingTitle/
		;;

		USAv* )
			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in "${LANGDIRS[@]}"; do
				cp "${RIIVOLUTION_DIR}"/MessageEN/Message.arc "${WORKDIR}"/files/US/"${dir}"/Message/Message.arc
			done
			cp -r "${RIIVOLUTION_DIR}"/OpeningE/openingTitle.arc "${WORKDIR}"/files/US/Layout/openingTitle/
		;;

		JPNv1 )
			cp "${RIIVOLUTION_DIR}"/MessageEN/Message.arc "${WORKDIR}"/files/JP/Message/Message.arc
			cp -r "${RIIVOLUTION_DIR}"/OpeningJ/openingTitle.arc "${WORKDIR}"/files/JP/Layout/openingTitle/
		;;
	esac

	cp -r "${RIIVOLUTION_DIR}"/Env "${WORKDIR}"/files/
	cp -r "${RIIVOLUTION_DIR}"/Layout "${WORKDIR}"/files/
	cp -r "${RIIVOLUTION_DIR}"/Object "${WORKDIR}"/files/
	cp "${RIIVOLUTION_DIR}"/Sound/stream/*.brstm "${WORKDIR}"/files/Sound/stream/
	cp "${RIIVOLUTION_DIR}"/Sound/*.brsar "${WORKDIR}"/files/Sound/
	cp "${RIIVOLUTION_DIR}"/Stage/*.arc "${WORKDIR}"/files/Stage/
	cp "${RIIVOLUTION_DIR}"/Stage/Texture/* "${WORKDIR}"/files/Stage/Texture/
	cp "${RIIVOLUTION_DIR}"/WorldMap/* "${WORKDIR}"/files/WorldMap/

}

dolpatch() {

	${WIT} dolpatch ${DOL}	\
		"802F148C=53756D6D53756E#7769696D6A3264" \
		"802F118C=53756D6D53756E#7769696D6A3264" \
		"802F0F8C=53756D6D53756E#7769696D6A3264" \
		xml="${PATCHIMAGE_PATCH_DIR}/NSMBW_AP.xml" -q

}
