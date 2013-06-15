#!/bin/bash

WORKDIR=./nsmb.d
DOL=${WORKDIR}/sys/main.dol
RIIVOLUTION_ZIP=Newer_Summer_Sun.zip
RIIVOLUTION_DIR="Newer Summer Sun"
GAMENAME="Newer Summer Sun"
XML=TRUE
XML_SOURCE=./"${RIIVOLUTION_DIR}"/SumSun/
XML_FILE=./"${RIIVOLUTION_DIR}"/riivolution/SumSun

show_notes () {

echo -e
"************************************************
Newer Summer Sun

Source:			http://www.newerteam.com/specials.html
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

check_input_image_special () {

	if [[ ! ${IMAGE} ]]; then
		if test -f ./SMN?01.wbfs; then
			IMAGE=./SMN?01.wbfs
		elif test -f ./SMN?01.iso; then
			IMAGE=./SMN?01.iso
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
	GAMEID=SMN${REG_LETTER}02

}

place_files () {

	NEW_DIRS=(  )
	for dir in ${NEW_DIRS[@]}; do
		mkdir -p ${dir}
	done

	case ${VERSION} in
		EUR* )


		USAv* )

		;;

		JPNv1 )

		;;
	esac



}
