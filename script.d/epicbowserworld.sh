#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="http://www.nanolx.org/riivolution/Epic_Super_Bowser_World_v1.00.zip"
RIIVOLUTION_ZIP="Epic_Super_Bowser_World_v1.00.zip"
RIIVOLUTION_DIR="Epic_Super_Bowser_World_v1.00"
GAMENAME="Epic Super Bowser World"
XML_SOURCE="${RIIVOLUTION_DIR}"/ESBW/
XML_FILE="${RIIVOLUTION_DIR}"/riivolution/ESBWP.xml
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Epic Super Bowser World

Source:			http://rvlution.net/forums/viewtopic.php?f=20&t=1222#p15952
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

	GAMEID=SMN${REG_LETTER}08

}

place_files () {

	NEW_DIRS=( ${WORKDIR}/files/NewerRes )
	for dir in ${NEW_DIRS[@]}; do
		mkdir -p ${dir}
	done

	cp -r "${RIIVOLUTION_DIR}"/ESBW/EU/EngEU/{m,M}essage

	case ${VERSION} in
		EUR* )
			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU NedEU )
			for dir in ${LANGDIRS[@]}; do
				cp -r "${RIIVOLUTION_DIR}"/ESBW/EU/EngEU/{Message,staffroll}/ ${WORKDIR}/files/EU/${dir}/
				cp -r "${RIIVOLUTION_DIR}"/ESBW/Font/ ${WORKDIR}/files/EU/${dir}/
			done
			cp "${RIIVOLUTION_DIR}"/ESBW/OpeningP/* ${WORKDIR}/files/EU/Layout/openingTitle/
		;;

		USAv* )
			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in ${LANGDIRS[@]}; do
				cp -r "${RIIVOLUTION_DIR}"/ESBW/EU/EngEU/{Message,staffroll}/ ${WORKDIR}/files/US/${dir}/
				cp -r "${RIIVOLUTION_DIR}"/ESBW/Font/ ${WORKDIR}/files/US/${dir}/
			done
			cp "${RIIVOLUTION_DIR}"/ESBW/OpeningE/* ${WORKDIR}/files/US/Layout/openingTitle/
		;;

		JPNv1 )
			cp -r "${RIIVOLUTION_DIR}"/ESBW/EU/EngEU/{Message,staffroll}/ ${WORKDIR}/files/JP/
			cp -r "${RIIVOLUTION_DIR}"/ESBW/Font/ ${WORKDIR}/files/JP/
			cp "${RIIVOLUTION_DIR}"/ESBW/OpeningJ/* ${WORKDIR}/files/JP/Layout/openingTitle/
		;;
	esac

	cp "${RIIVOLUTION_DIR}"/ESBW/Stage/Texture/* ${WORKDIR}/files/Stage/Texture/
	cp "${RIIVOLUTION_DIR}"/ESBW/NewerRes/* ${WORKDIR}/files/NewerRes/
	cp "${RIIVOLUTION_DIR}"/ESBW/Stage/*.arc ${WORKDIR}/files/Stage/
	cp "${RIIVOLUTION_DIR}"/ESBW/Env/* ${WORKDIR}/files/Env/
	cp "${RIIVOLUTION_DIR}"/ESBW/Sound/stream/* ${WORKDIR}/files/Sound/stream/
	cp "${RIIVOLUTION_DIR}"/ESBW/Sound/*.brsar ${WORKDIR}/files/Sound/
	cp "${RIIVOLUTION_DIR}"/ESBW/WorldMap/* ${WORKDIR}/files/WorldMap/
	cp "${RIIVOLUTION_DIR}"/ESBW/Object/* ${WORKDIR}/files/Object/
	cp "${RIIVOLUTION_DIR}"/ESBW/MovieDemo/* ${WORKDIR}/files/MovieDemo/
	cp -r "${RIIVOLUTION_DIR}"/ESBW/Layout/ ${WORKDIR}/files/

}


dolpatch() {

	cp "${XML_FILE}" "${XML_FILE}".new
	sed -e 's/80001800/803482C0/g' -i "${XML_FILE}".new
	XML_FILE="${XML_FILE}".new

	${WIT} dolpatch ${DOL} xml="${XML_FILE}" -s "${XML_SOURCE}" \
		"802F148C=53756D6D53756E#7769696D6A3264" \
		"802F118C=53756D6D53756E#7769696D6A3264" \
		"802F0F8C=53756D6D53756E#7769696D6A3264" \
		xml="patches/EpicSuperBowserWorld-Loader.xml" -q

	${WIT} dolpatch ${DOL} xml="patches/NSMBW_AP.xml" -q

}
