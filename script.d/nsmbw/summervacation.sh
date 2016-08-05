#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="https://dl.dropboxusercontent.com/u/90984778/Super_Mario_Vacation_v1.00.zip"
RIIVOLUTION_ZIP="Super_Mario_Vacation_v1.00.zip"
RIIVOLUTION_DIR="Super_Mario_Vacation_v1.00"
GAMENAME="Super Mario Vacation"
XML_SOURCE="${RIIVOLUTION_DIR}"/Vacation
XML_FILE="${RIIVOLUTION_DIR}"/riivolution/Vacation
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr
WBFS_MASK="SMN[PUJ]01"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

NSMBW Hack featuring 7 new and one old level.

Source:			http://rvlution.net/forums/viewtopic.php?f=53&t=1839
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

detect_game_version () {

	nsmbw_version

	XML_FILE="${XML_FILE}"${REG_LETTER}.xml
	GAMEID=SMV${REG_LETTER}01

}

place_files () {

	NEW_DIRS=( ${WORKDIR}/files/EU/NedEU/Message )
	for dir in ${NEW_DIRS[@]}; do
		mkdir -p ${dir}
	done

	case ${VERSION} in
		EUR* )
			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU NedEU )
			for dir in ${LANGDIRS[@]}; do
				cp -r "${RIIVOLUTION_DIR}"/Vacation/Message ${WORKDIR}/files/EU/${dir}/
			done
			cp "${RIIVOLUTION_DIR}"/Vacation/OpeningP/* ${WORKDIR}/files/EU/Layout/openingTitle/openingTitle.arc
		;;

		USAv* )
			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in ${LANGDIRS[@]}; do
				cp -r "${RIIVOLUTION_DIR}"/Vacation/Message ${WORKDIR}/files/US/${dir}/
			done
			cp "${RIIVOLUTION_DIR}"/Vacation/OpeningE/* ${WORKDIR}/files/US/Layout/openingTitle/openingTitle.arc
		;;

		JPNv1 )
			cp -r "${RIIVOLUTION_DIR}"/Vacation/Message ${WORKDIR}/files/JP/
			cp "${RIIVOLUTION_DIR}"/Vacation/OpeningJ/* ${WORKDIR}/files/JP/Layout/openingTitle/openingTitle.arc
		;;
	esac

	cp -r "${RIIVOLUTION_DIR}"/Vacation/{Env,Layout,Object,Sound,Stage,WorldMap} ${WORKDIR}/files/

}


dolpatch () {

	${WIT} dolpatch ${DOL}	\
		"802F148C=53756D6D53756E#7769696D6A3264" \
		"802F118C=53756D6D53756E#7769696D6A3264" \
		"802F0F8C=53756D6D53756E#7769696D6A3264" \
		xml="${PATCHIMAGE_PATCH_DIR}/NSMBW_AP.xml" -q

}

