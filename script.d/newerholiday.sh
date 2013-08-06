#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="http://dirbaio.net/newer/Newer_Super_Mario_Bros._Wii_HS.zip"
SOUNDTRACK_LINK="http://dirbaio.net/newer/Newer_Holiday_Special_Soundtrack.zip"
SOUNDTRACK_ZIP="Newer_Holiday_Special_Soundtrack.zip"
RIIVOLUTION_ZIP="Newer_Super_Mario_Bros._Wii_HS.zip"
RIIVOLUTION_DIR="XmasNewer"
GAMENAME="Newer: Holiday Special"
XML_SOURCE="${RIIVOLUTION_DIR}"
XML_FILE="riivolution/Xmas"
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Newer: Holiday Special is a frosty adventure created to celebrate
Christmas 2011. Explore 8 of the coldest levels you'll ever see, set
to chilly music and new, icy textures!

Source:			http://www.newerteam.com/specials.html
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

check_input_image_special () {

	check_input_image_nsmb

}

detect_game_version () {

	nsmbw_version

	XML_FILE="${XML_FILE}"${REG_LETTER}.xml
	GAMEID=SMN${REG_LETTER}07
	CUSTOM_BANNER=http://dl.dropboxusercontent.com/u/101209384/${GAMEID}.bnr

}

place_files () {

	NEW_DIRS=( ${WORKDIR}/files/EU/NedEU/Message )
	for dir in ${NEW_DIRS[@]}; do
		mkdir -p ${dir}
	done

	case ${VERSION} in
		EURv* )

			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU NedEU )
			for dir in ${LANGDIRS[@]}; do
				cp "${RIIVOLUTION_DIR}"/MessageEN/* ${WORKDIR}/files/EU/${dir}/Message/
			done
			cp "${RIIVOLUTION_DIR}"/OpeningP/* ${WORKDIR}/files/EU/Layout/openingTitle/

		;;

		USAv* )

			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in ${LANGDIRS[@]}; do
				cp "${RIIVOLUTION_DIR}"/MessageEN/* ${WORKDIR}/files/US/${dir}/Message/
			done
			cp "${RIIVOLUTION_DIR}"/OpeningE/* ${WORKDIR}/files/US/Layout/openingTitle/
		;;

		JPNv* )
			cp "${RIIVOLUTION_DIR}"/MessageEN/* ${WORKDIR}/files/JP/Message/
			cp "${RIIVOLUTION_DIR}"/OpeningJ/* ${WORKDIR}/files/JP/Layout/openingTitle/
		;;
	esac

	cp "${RIIVOLUTION_DIR}"/Sound/Stream/* ${WORKDIR}/files/Sound/stream/
	cp "${RIIVOLUTION_DIR}"/Layout/preGame/* ${WORKDIR}/files/Layout/preGame/
	cp "${RIIVOLUTION_DIR}"/Layout/textures/* ${WORKDIR}/files/Layout/textures/
	cp "${RIIVOLUTION_DIR}"/Sound/*.brsar ${WORKDIR}/files/Sound/
	cp "${RIIVOLUTION_DIR}"/WorldMap/* ${WORKDIR}/files/WorldMap/
	cp "${RIIVOLUTION_DIR}"/Object/* ${WORKDIR}/files/Object/

}

dolpatch () {

	${WIT} dolpatch ${DOL} xml="${XML_FILE}" -s "${XML_SOURCE}" \
		"802F148C=53756D6D53756E#7769696D6A3264" \
		"802F118C=53756D6D53756E#7769696D6A3264" \
		"802F0F8C=53756D6D53756E#7769696D6A3264" \
		xml="${PATCHIMAGE_PATCH_DIR}/HolidaySpecial-Loader.xml" -q
	${WIT} dolpatch ${DOL} xml="${PATCHIMAGE_PATCH_DIR}/NSMBW_AP.xml" -q

}
