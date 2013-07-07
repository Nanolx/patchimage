#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="http://nanolx.org/riivolution/New%20Super%20Mario%20Bros.%20Wii%204%20made%20by%20Orange-Yoshi3.3.zip"
RIIVOLUTION_ZIP="New Super Mario Bros. Wii 4 made by Orange-Yoshi3.3.zip"
RIIVOLUTION_DIR="nsmb"
GAMENAME="New Super Mario Bros. 4"
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr

show_notes () {

echo -e \
"************************************************
${GAMENAME}

This hack includes 16 new levels in 4 worlds (1, 5, 8 & 9) as well as a
new titlescreen with logo (made by max31) and custom music.

Source:			http://www.rvlution.net/forums/viewtopic.php?f=53&t=1501
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

	nsmbw_version

	GAMEID=SMN${REG_LETTER}11

}

place_files () {

	case ${VERSION} in
		EURv* )
			patches/openingTitle_nsmbw4.arc ${WORKDIR}/files/EU/Layout/openingTitle/openingTitle.arc
		;;

		USAv* )
			patches/openingTitle_nsmbw4.arc ${WORKDIR}/files/US/Layout/openingTitle/openingTitle.arc
		;;

#		JPNv* )
#			cp "${RIIVOLUTION_DIR}"/openingTitle.arc ${WORKDIR}/files/JP/Layout/openingTitle/
#		;;
	esac

	cp "${RIIVOLUTION_DIR}"/*.brstm ${WORKDIR}/files/Sound/stream/
	cp "${RIIVOLUTION_DIR}"/0*.arc ${WORKDIR}/files/Stage/
	cp "${RIIVOLUTION_DIR}"/*.brsar ${WORKDIR}/files/Sound/
	cp "${RIIVOLUTION_DIR}"/bgA*.arc ${WORKDIR}/files/Object/
	# fix
	cp patches/05-04.arc ${WORKDIR}/files/Stage/


}

dolpatch () {

	${WIT} dolpatch ${DOL}	\
		"802F148C=53756D6D53756E#7769696D6A3264" \
		"802F118C=53756D6D53756E#7769696D6A3264" \
		"802F0F8C=53756D6D53756E#7769696D6A3264" \
		xml="patches/NSMBW_AP.xml" -q

}
