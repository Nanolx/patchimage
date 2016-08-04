#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="http://www.nanolx.org/riivolution/Retro%20Remix.rar"
RIIVOLUTION_ZIP="Retro Remix.rar"
RIIVOLUTION_DIR="Retro Remix"
GAMENAME="New Super Mario Bros. Wii Retro Remix"
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr

show_notes () {

echo -e \
"************************************************
${GAMENAME}

The Original Adventure is back!
Join Mario in his Bowser-bashing classic quest - Again!
Bowser has once again invaded the Mushroom Kingdom
and kidnapped Princess Peach. It's up to you to save her.

Source:			?
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

check_input_image_special () {

	check_input_image_nsmb

}

detect_game_version () {

	nsmbw_version

	GAMEID=MRR${REG_LETTER}01

}

place_files () {

	case ${VERSION} in
		EURv* )
			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU NedEU )
			for dir in ${LANGDIRS[@]}; do
				cp -r "${RIIVOLUTION_DIR}"/US/EngUS/Message/ ${WORKDIR}/files/EU/${dir}/
			done
			cp ${PATCHIMAGE_PATCH_DIR}/openingTitle_retromix.arc ${WORKDIR}/files/EU/Layout/openingTitle/openingTitle.arc
		;;

		USAv* )
			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in ${LANGDIRS[@]}; do
				cp -r "${RIIVOLUTION_DIR}"/US/EngUS/Message/ ${WORKDIR}/files/US/${dir}/
			done
			cp ${PATCHIMAGE_PATCH_DIR}/openingTitle_retromix.arc ${WORKDIR}/files/US/Layout/openingTitle/openingTitle.arc
		;;

		JPNv* )
			cp "${RIIVOLUTION_DIR}"/US/EngUS/Message/* ${WORKDIR}/files/JP/Message/
			#cp "${RIIVOLUTION_DIR}"/US/Layout/openingTitle/openingTitle.arc ${WORKDIR}/files/JP/Layout/openingTitle/
		;;
	esac

	cp "${RIIVOLUTION_DIR}"/Layout/MultiCorseSelect/MultiCorseSelect.arc ${WORKDIR}/files/Layout/MultiCourseSelect/MultiCourseSelect.arc
	cp -r "${RIIVOLUTION_DIR}"/{Layout,MovieDemo,Object,Sound,Stage,WorldMap}/ ${WORKDIR}/files/
	rm -rf ${WORKDIR}/files/Layout/MultiCorseSelect/

}

dolpatch () {

	echo -n

}
