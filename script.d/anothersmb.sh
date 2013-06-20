#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="http://dirbaio.net/newer/Another_Super_Mario_Brothers_Wii_2.0.zip"
SOUNDTRACK_LINK="http://dirbaio.net/newer/Another_Super_Mario_Bros_Wii_Soundtrack.zip"
SOUNDTRACK_ZIP="Another_Super_Mario_Bros_Wii_Soundtrack.zip"
RIIVOLUTION_ZIP="Another_Super_Mario_Brothers_Wii_2.0.zip"
RIIVOLUTION_DIR="Another"
GAMENAME="Another Super Mario Brothers Wii 2.0"
XML_SOURCE="${RIIVOLUTION_DIR}"
XML_FILE="Riivolution/Another.xml"

show_notes () {

echo -e
"************************************************
Another Super Mario Brothers Wii 2.0

Source:			http://www.newerteam.com/specials.html
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, USAv1, USAv2
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
		echo -e "please specify your games version using --version={EURv1,USAv1,USAv2}"
		exit 1
	fi

	GAMEID=SMN${REG_LETTER}04

	if [[ ${VERSION} == "EURv2" || ${VERSION} == "JPNv*" ]]; then
		echo -e "Version ${VERSION} is not supported!"
		exit 1
	fi

}

place_files () {

	NEW_DIRS=( ${WORKDIR}/files/AnotherRes ${WORKDIR}/files/Sample ${WORKDIR}/files/EU/NedEU/staffroll ${WORKDIR}/files/EU/NedEU/Message ${WORKDIR}/files/EU/NedEU/Font )
	for dir in ${NEW_DIRS[@]}; do
		mkdir -p ${dir}
	done

	case ${VERSION} in
		EURv* )

			cp "${RIIVOLUTION_DIR}"/Lang/EUENGLISH.arc ${WORKDIR}/files/EU/EngEU/Message/Message.arc
			cp "${RIIVOLUTION_DIR}"/Lang/EUFRENCH.arc ${WORKDIR}/files/EU/FraEU/Message/Message.arc
			cp "${RIIVOLUTION_DIR}"/Lang/EUGERMAN.arc ${WORKDIR}/files/EU/GerEU/Message/Message.arc
			cp "${RIIVOLUTION_DIR}"/Lang/EUITALIAN.arc ${WORKDIR}/files/EU/ItaEU/Message/Message.arc
			cp "${RIIVOLUTION_DIR}"/Lang/EUSPANISH.arc ${WORKDIR}/files/EU/SpaEU/Message/Message.arc

			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU NedEU )
			for dir in ${LANGDIRS[@]}; do
				cp "${RIIVOLUTION_DIR}"/Lang/staffroll.bin ${WORKDIR}/files/EU/${dir}/staffroll/
				cp "${RIIVOLUTION_DIR}"/Lang/mj2d00_PictureFont_32_RGBA8.brfnt ${WORKDIR}/files/EU/${dir}/Font/
			done
			cp "${RIIVOLUTION_DIR}"/Layout/OpeningP/* ${WORKDIR}/files/EU/Layout/openingTitle/

		;;

		USAv* )

			cp "${RIIVOLUTION_DIR}"/Lang/USENGLISH.arc ${WORKDIR}/files/US/EngUS/Message/Message.arc
			cp "${RIIVOLUTION_DIR}"/Lang/USFRENCH.arc ${WORKDIR}/files/US/FraUS/Message/Message.arc
			cp "${RIIVOLUTION_DIR}"/Lang/USSPANISH.arc ${WORKDIR}/files/US/SpaUS/Message/Message.arc

			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in ${LANGDIRS[@]}; do
				cp "${RIIVOLUTION_DIR}"/Lang/staffroll.bin ${WORKDIR}/files/US/${dir}/staffroll/
				cp "${RIIVOLUTION_DIR}"/Lang/mj2d00_PictureFont_32_RGBA8.brfnt ${WORKDIR}/files/US/${dir}/Font/
			done
			cp "${RIIVOLUTION_DIR}"/Layout/OpeningE/* ${WORKDIR}/files/US/Layout/openingTitle/
		;;
	esac

	cp "${RIIVOLUTION_DIR}"/Lang/Other/01-01_N_1.bin ${WORKDIR}/files/Replay/otehon/01-01_N_1.bin
	cp "${RIIVOLUTION_DIR}"/Lang/Other/01-02_N_1.bin ${WORKDIR}/files/Replay/otehon/01-02_N_1.bin
	cp "${RIIVOLUTION_DIR}"/Lang/Other/01-04_N_1.bin ${WORKDIR}/files/Replay/otehon/01-04_N_1.bin
	cp "${RIIVOLUTION_DIR}"/Lang/Other/01-06_N_1.bin ${WORKDIR}/files/Replay/otehon/01-06_N_1.bin
	cp "${RIIVOLUTION_DIR}"/Stage/*.arc ${WORKDIR}/files/Stage/
	cp "${RIIVOLUTION_DIR}"/Sound/BGM_HIKOUSEN_ROUKA.32.brstm ${WORKDIR}/files/Sound/stream/BGM_HIKOUSEN_ROUKA.32.brstm
	cp "${RIIVOLUTION_DIR}"/Sound/BGM_HIKOUSEN_ROUKA_FAST.32.brstm ${WORKDIR}/files/Sound/stream/BGM_HIKOUSEN_ROUKA_FAST.32.brstm
	cp "${RIIVOLUTION_DIR}"/Sound/kazan_tika_fast_lr.ry.32.brstm ${WORKDIR}/files/Sound/stream/kazan_tika_fast_lr.ry.32.brstm
	cp "${RIIVOLUTION_DIR}"/Sound/kazan_tika_lr.ry.32.brstm ${WORKDIR}/files/Sound/stream/kazan_tika_lr.ry.32.brstm
	cp "${RIIVOLUTION_DIR}"/Sound/wii_mj2d_sound.brsar ${WORKDIR}/files/Sound/wii_mj2d_sound.brsar
	cp "${RIIVOLUTION_DIR}"/Layout/controllerInformation.arc ${WORKDIR}/files/Layout/controllerInformation/controllerInformation.arc
	cp "${RIIVOLUTION_DIR}"/Layout/MultiCorseSelectTexture.arc ${WORKDIR}/files/Layout/textures/MultiCorseSelectTexture.arc
	cp "${RIIVOLUTION_DIR}"/Object/*.arc ${WORKDIR}/files/Object/
	cp "${RIIVOLUTION_DIR}"/WorldMap/* ${WORKDIR}/files/WorldMap/
	cp "${RIIVOLUTION_DIR}"/AnotherRes/* ${WORKDIR}/files/AnotherRes/
	cp "${RIIVOLUTION_DIR}"/Object/Background/* ${WORKDIR}/files/Object/
	cp "${RIIVOLUTION_DIR}"/Stage/Texture/* ${WORKDIR}/files/Stage/Texture/
	cp "${RIIVOLUTION_DIR}"/Sample/tobira.bti ${WORKDIR}/files/Sample/tobira.bti

}

prepare_xml () {

	cp "${XML_FILE}" "${XML_FILE}".new
	sed -e 's/80001800/803482C0/g' -i "${XML_FILE}".new
	XML_FILE="${XML_FILE}".new

}

dolpatch_extra () {

	${WIT} dolpatch ${DOL} xml="patches/AnotherSMB-Loader.xml"

}
