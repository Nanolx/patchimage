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

	if [[ ! ${IMAGE} ]]; then
		if test -f SMN?01.wbfs; then
			IMAGE=SMN?01.wbfs
		elif test -f SMN?01.iso; then
			IMAGE=SMN?01.iso
		else
			echo -e "please specify image to use with --iso=<path>"
			exit 1
		fi
	fi

}

detect_game_version () {


	if [[ -f ${WORKDIR}/files/COPYDATE_LAST_2009-10-03_232911 ]]; then
		VERSION=EURv1
		REG_LETTER=P
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2010-01-05_152101 ]]; then
		VERSION=EURv2
		REG_LETTER=P
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2009-10-03_232303 ]]; then
		VERSION=USAv1
		REG_LETTER=E
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2010-01-05_143554 ]]; then
		VERSION=USAv2
		REG_LETTER=E
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2009-10-03_231655 ]]; then
		VERSION=JPNv1
		REG_LETTER=J
	elif [[ ! ${VERSION} ]]; then
		echo -e "please specify your games version using --version={EURv1,EURv2,USAv1,USAv2,JPNv1}"
		exit 1
	fi

	XML_FILE="${XML_FILE}"${REG_LETTER}.xml
	GAMEID=SMN${REG_LETTER}07

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
	esac

	cp "${RIIVOLUTION_DIR}"/Sound/Stream/* ${WORKDIR}/files/Sound/stream/
	cp "${RIIVOLUTION_DIR}"/Layout/preGame/* ${WORKDIR}/files/Layout/preGame/
	cp "${RIIVOLUTION_DIR}"/Layout/textures/* ${WORKDIR}/files/Layout/textures/
	cp "${RIIVOLUTION_DIR}"/Sound/*.brsar ${WORKDIR}/files/Sound/
	cp "${RIIVOLUTION_DIR}"/WorldMap/* ${WORKDIR}/files/WorldMap/
	cp "${RIIVOLUTION_DIR}"/Object/* ${WORKDIR}/files/Object/

}

prepare_xml () {

	echo -ne

}

dolpatch_extra () {

	${WIT} dolpatch ${DOL} xml="patches/HolidaySpecial-Loader.xml"
	${WIT} dolpatch ${DOL} xml="patches/NSMBW_AP.xml"

}
