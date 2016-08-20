#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="https://www.sendspace.com/file/cky4rn"
RIIVOLUTION_ZIP="ChaSMBW_VrS_v0.2.zip"
RIIVOLUTION_DIR="VirtualChallenging"
GAMENAME="Challenging Super Mario Bros. Wii: Virtual Special"
GAME_TYPE=RIIVOLUTION
XML_SOURCE="${RIIVOLUTION_DIR}"
XML_FILE="${RIIVOLUTION_DIR}"/../riivolution/VirtualSpecial.xml
BANNER_LOCATION=${WORKDIR}/files/opening.bnr
WBFS_MASK="SMN[PEJ]01"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

This is a mini hack that has Virtual Day for all those
Computer Lovers who are waiting for Challenging!

Source:			http://rvlution.net/thread/2535-challenging-super-mario-bros-wii-virtual-special/
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

detect_game_version () {

	nsmbw_version
	GAMEID=SMN${REG_LETTER}ZC

}

place_files () {

	case ${VERSION} in
		EUR* )
			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU )
			for dir in "${LANGDIRS[@]}"; do
				cp "${RIIVOLUTION_DIR}"/Message/Message.arc "${WORKDIR}"/files/EU/"${dir}"/Message/Message.arc
				#cp "${RIIVOLUTION_DIR}"/Layout/wiiStrap.arc "${WORKDIR}"/files/EU/"${dir}"/Layout/wiiStrap/
			done
			cp -r "${RIIVOLUTION_DIR}"/OpeningP/openingTitle.arc "${WORKDIR}"/files/EU/Layout/openingTitle/
		;;

		USAv* )
			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in "${LANGDIRS[@]}"; do
				cp "${RIIVOLUTION_DIR}"/Message/Message.arc "${WORKDIR}"/files/US/"${dir}"/Message/Message.arc
				cp "${RIIVOLUTION_DIR}"/Layout/wiiStrap.arc "${WORKDIR}"/files/US/"${dir}"/Layout/wiiStrap/
			done
			cp -r "${RIIVOLUTION_DIR}"/OpeningE/openingTitle.arc "${WORKDIR}"/files/US/Layout/openingTitle/
		;;

		JPNv1 )
			cp "${RIIVOLUTION_DIR}"/Message/Message.arc "${WORKDIR}"/files/JP/Message/Message.arc
			#cp "${RIIVOLUTION_DIR}"/Layout/wiiStrap.arc "${WORKDIR}"/files/JP/Layout/wiiStrap/
			cp -r "${RIIVOLUTION_DIR}"/OpeningJ/openingTitle.arc "${WORKDIR}"/files/JP/Layout/openingTitle/
		;;
	esac

	cp -r "${RIIVOLUTION_DIR}"/FuncInfo "${WORKDIR}"/files/
	cp "${RIIVOLUTION_DIR}"/Sound/stream/*.brstm "${WORKDIR}"/files/Sound/stream/
	cp "${RIIVOLUTION_DIR}"/Sound/*.brsar "${WORKDIR}"/files/Sound/
	cp "${RIIVOLUTION_DIR}"/Stage/*.arc "${WORKDIR}"/files/Stage/
	cp "${RIIVOLUTION_DIR}"/Stage/Texture/* "${WORKDIR}"/files/Stage/Texture/
	cp "${RIIVOLUTION_DIR}"/WorldMap/* "${WORKDIR}"/files/WorldMap/
	cp "${RIIVOLUTION_DIR}"/Layout/sequenceBGTexture.arc \
		"${WORKDIR}"/files/Layout/textures/sequenceBGTexture.arc

	for file in charaChangeSelectContents corseSelectUIGuide gameScene \
		MultiCourseSelect MultiCourseSelectContents pointResult \
		pointResultDateFile pointResultDateFileFree preGame sequenceBG; do
		cp "${RIIVOLUTION_DIR}"/Layout/"${file}".arc \
			"${WORKDIR}"/files/Layout/"${file}"/"${file}".arc
	done

}

dolpatch () {

	cp "${XML_FILE}" "${XML_FILE}".new
	sed -e 's/80001800/803482C0/g' -i "${XML_FILE}".new
	XML_FILE="${XML_FILE}".new

	${WIT} dolpatch ${DOL} xml="${XML_FILE}" -s "${XML_SOURCE}" \
		xml="${PATCHIMAGE_PATCH_DIR}/NewerSMBW-Loader.xml" -q
	${WIT} dolpatch ${DOL} xml="${PATCHIMAGE_PATCH_DIR}/NSMBW_AP.xml" -q

}
