#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="https://www.dropbox.com/s/t3b3fvycm1ufu46/AwesomerSLM.zip"
RIIVOLUTION_ZIP="AwesomerSLM.zip"
RIIVOLUTION_DIR="AwesomerSLM"
GAMENAME="Awesomer Super Luigi Mini"
XML_SOURCE="${RIIVOLUTION_DIR}"/AwesomerSLM
XML_FILE="${RIIVOLUTION_DIR}"/riivolution/ASLMriivo.xml
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr
WBFS_MASK="SMN[PUJ]01"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

1: Custom Levels for World 1
2: World 1's map will be world 4's
3: Joietyfull64's NSMBU tilesets
4: Custom logo.

Source:			http://rvlution.net/forums/viewtopic.php?f=53&t=1851
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

detect_game_version () {

	nsmbw_version

	GAMEID=SMN${REG_LETTER}12

}

place_files () {

	NEW_DIRS=( ${WORKDIR}/files/EU/NedEU/Message ${WORKDIR}/files/EU/PolEU/Message ${WORKDIR}/files/Sample/)
	for dir in ${NEW_DIRS[@]}; do
		mkdir -p ${dir}
	done

	case ${VERSION} in
		EUR* )
			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU NedEU PolEU )
			for dir in ${LANGDIRS[@]}; do
				cp "${RIIVOLUTION_DIR}"/AwesomerSLM/MessageEN/Message/Message.arc ${WORKDIR}/files/EU/${dir}/Message/Message.arc
			done
		;;

		USAv* )
			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in ${LANGDIRS[@]}; do
				cp "${RIIVOLUTION_DIR}"/AwesomerSLM/MessageEN/Message/Message.arc ${WORKDIR}/files/US/${dir}/Message/Message.arc
			done
			cp -r "${RIIVOLUTION_DIR}"/AwesomerSLM/OpeningUS/openingTitle/ ${WORKDIR}/files/US/Layout/
		;;

		JPNv1 )
			cp "${RIIVOLUTION_DIR}"/AwesomerSLM/MessageEN/Message/Message.arc ${WORKDIR}/files/JP/
		;;
	esac

	cp -r "${RIIVOLUTION_DIR}"/AwesomerSLM/Stages/* ${WORKDIR}/files/Stage/
	cp "${RIIVOLUTION_DIR}"/AwesomerSLM/Sound/*.brstm ${WORKDIR}/files/Sound/stream/
	cp "${RIIVOLUTION_DIR}"/AwesomerSLM/Sound/BRSAR/* ${WORKDIR}/files/Sound/
	cp -r "${RIIVOLUTION_DIR}"/AwesomerSLM/Object/ ${WORKDIR}/files/Object/
	#cp -r "${RIIVOLUTION_DIR}"/AwesomerSLM/Layout/ ${WORKDIR}/files/

}


dolpatch () {

	${WIT} dolpatch ${DOL}	\
		"802F148C=53756D6D53756E#7769696D6A3264" \
		"802F118C=53756D6D53756E#7769696D6A3264" \
		"802F0F8C=53756D6D53756E#7769696D6A3264" \
		xml="${PATCHIMAGE_PATCH_DIR}/NSMBW_AP.xml" -q

}

