#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="http://riivolution.nanolx.org/Epic_Super_Bowser_World_v1.00.zip"
RIIVOLUTION_ZIP="Epic_Super_Bowser_World_v1.00.zip"
RIIVOLUTION_DIR="Epic_Super_Bowser_World_v1.00"
GAMENAME="Epic Super Bowser World"
XML_SOURCE="${RIIVOLUTION_DIR}"/ESBW/
XML_FILE="${RIIVOLUTION_DIR}"/riivolution/ESBW
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
	GAMEID=SMN${REG_LETTER}08

}

place_files () {

	NEW_DIRS=( ${WORKDIR}/files/NewerRes )
	for dir in ${NEW_DIRS[@]}; do
		mkdir -p ${dir}
	done

	case ${VERSION} in
		EUR* )
			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU NedEU )
			for dir in ${LANGDIRS[@]}; do
				cp -r "${RIIVOLUTION_DIR}"/ESBW/EU/EngEU/{message,staffroll}/ ${WORKDIR}/files/EU/${dir}/
				cp -r "${RIIVOLUTION_DIR}"/ESBW/Font/ ${WORKDIR}/files/EU/${dir}/
			done
			cp "${RIIVOLUTION_DIR}"/ESBW/OpeningP/* ${WORKDIR}/files/EU/Layout/openingTitle/
		;;

		USAv* )
			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in ${LANGDIRS[@]}; do
				cp -r "${RIIVOLUTION_DIR}"/ESBW/EU/EngEU/{message,staffroll}/ ${WORKDIR}/files/US/${dir}/
				cp -r "${RIIVOLUTION_DIR}"/ESBW/Font/ ${WORKDIR}/files/US/${dir}/
			done
			cp "${RIIVOLUTION_DIR}"/ESBW/OpeningE/* ${WORKDIR}/files/US/Layout/openingTitle/
		;;

		JPNv1 )
			cp -r "${RIIVOLUTION_DIR}"/ESBW/EU/EngEU/{message,staffroll}/ ${WORKDIR}/files/JP/
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
		xml="patches/EpicSuperBowserWorld-Loader.xml" -q

}
