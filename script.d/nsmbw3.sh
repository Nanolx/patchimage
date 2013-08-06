#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="https://www.dropbox.com/s/rvuwd8ztl44g18y/NSMBW3_The%20final%20levels.zip"
RIIVOLUTION_ZIP="NSMBW3_The final levels.zip"
RIIVOLUTION_DIR="NSMBW3"
GAMENAME="NSMBW3: The Final Levels"
XML_SOURCE="${RIIVOLUTION_DIR}"
XML_FILE="${RIIVOLUTION_DIR}"/../riivolution/NSMBW3.XML
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=""

show_notes () {

echo -e \
"************************************************
${GAMENAME}

NSMBW Hack featuring a bunch of new levels.

Source:			http://www.rvlution.net/forums/viewtopic.php?f=53&t=1673
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

check_input_image_special () {

	if [[ ! ${IMAGE} ]]; then
		if test -f SMN?01.wbfs; then
			IMAGE=$(eval echo SMN?01.wbfs)
		elif test -f SMN?01.iso; then
			IMAGE=$(eval echo SMN?01.iso)
		else
			echo -e "please specify image to use with --iso=<path>"
			exit 1
		fi
	fi

}

detect_game_version () {

	nsmbw_version

	GAMEID=SFL${REG_LETTER}01
	if [[ ${VERSION} != EURv* ]]; then
		echo -e "Versions other than PAL won't show the correct title-screen."
	fi

}

place_files () {

	NEW_DIRS=( ${WORKDIR}/files/EU/NedEU/{Message,Layout} )
	for dir in ${NEW_DIRS[@]}; do
		mkdir -p ${dir}
	done

	case ${VERSION} in
		EUR* )
			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU NedEU )
			for dir in ${LANGDIRS[@]}; do
				cp -r "${RIIVOLUTION_DIR}"/EU/EngEU/{Message,Layout} ${WORKDIR}/files/EU/${dir}/
			done
			cp "${RIIVOLUTION_DIR}"/EU/Layout/openingtitle/* ${WORKDIR}/files/EU/Layout/openingTitle/openingTitle.arc
		;;

		USAv* )
			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in ${LANGDIRS[@]}; do
				cp -r "${RIIVOLUTION_DIR}"/EU/EngEU/{Message,Layout} ${WORKDIR}/files/EU/${dir}/
			done
		;;

		JPNv1 )
			cp -r "${RIIVOLUTION_DIR}"/EU/EngEU/{Message,Layout} ${WORKDIR}/files/JP/
		;;
	esac

	cp -r "${RIIVOLUTION_DIR}"/Stage/ ${WORKDIR}/files/

}


dolpatch() {

	cp "${XML_FILE}" "${XML_FILE}".new
	sed -e 's/80001800/803482C0/g' -i "${XML_FILE}".new
	XML_FILE="${XML_FILE}".new

	${WIT} dolpatch ${DOL} xml="${XML_FILE}" -s "${XML_SOURCE}" #\
#		"802F148C=53756D6D53756E#7769696D6A3264" \
#		"802F118C=53756D6D53756E#7769696D6A3264" \
#		"802F0F8C=53756D6D53756E#7769696D6A3264" \
#		xml="patches/KoopaCountry-Loader.xml" -q

	${WIT} dolpatch ${DOL} xml="patches/NSMBW_AP.xml" -q

}
