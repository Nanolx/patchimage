#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="http://riivolution.nanolx.org/Riivolution%20Other%20WorldR%20v1.01.zip"
RIIVOLUTION_ZIP="Riivolution Other WorldR v1.01.zip"
RIIVOLUTION_DIR="Riivolution Other WorldR/Other World/"
GAMENAME="New Super Mario Bros. Wii - Other World"
XML_SOURCE="${RIIVOLUTION_DIR}"
XML_FILE="${RIIVOLUTION_DIR}/../riivolution/OtherWorld"
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr

show_notes () {

echo -e \
"************************************************
${GAMENAME}

- Some Custom Tilesets of file depot
- Custom level 1-1 to 7 tower
- Custom tilesets

Source:			http://rvlution.net/thread/3019-new-super-mario-bros-wii-other-world/
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

check_input_image_special () {

	check_input_image_nsmb

}

detect_game_version () {

	nsmbw_version
	GAMEID=SMN${REG_LETTER}31
	XML_FILE="${XML_FILE}${REG_LETTER}.xml"

}

place_files () {


	NEW_DIRS=( ${WORKDIR}/files/NewerRes ${WORKDIR}/files/EU/NedEU/Message )
	for dir in ${NEW_DIRS[@]}; do
		mkdir -p ${dir}
	done

	case ${VERSION} in
		EURv* )

			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU NedEU )
			for dir in ${LANGDIRS[@]}; do
				cp "${RIIVOLUTION_DIR}"/MessageEN/* ${WORKDIR}/files/EU/${dir}/Message/
			done
			cp "${RIIVOLUTION_DIR}"/OpeningP/* ${WORKDIR}/files/EU/Layout/openingTitle/

		;;

		USAv* )

			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in ${LANGDIRS[@]}; do
				cp "${RIIVOLUTION_DIR}"/MessageEN/* ${WORKDIR}/files/US/${dir}/Message/
			done
			cp "${RIIVOLUTION_DIR}"/OpeningE/* ${WORKDIR}/files/US/Layout/openingTitle/
		;;

		JPNv* )
			cp "${RIIVOLUTION_DIR}"/MessageEN/* ${WORKDIR}/files/JP/Message/
			cp "${RIIVOLUTION_DIR}"/OpeningJ/* ${WORKDIR}/files/JP/Layout/openingTitle/
		;;
	esac

	cp "${RIIVOLUTION_DIR}"/Stage/Texture/* ${WORKDIR}/files/Stage/Texture/
	cp "${RIIVOLUTION_DIR}"/NewerRes/* ${WORKDIR}/files/NewerRes/
	cp "${RIIVOLUTION_DIR}"/Stage/*.arc ${WORKDIR}/files/Stage/
	cp "${RIIVOLUTION_DIR}"/Env/* ${WORKDIR}/files/Env/
	cp "${RIIVOLUTION_DIR}"/MovieDemo/* ${WORKDIR}/files/MovieDemo/
	cp -r "${RIIVOLUTION_DIR}"/Layout/* ${WORKDIR}/files/Layout/

}

dolpatch () {

	cp "${XML_FILE}" "${XML_FILE}".new
	sed -e 's/80001800/803482C0/g' -i "${XML_FILE}".new
	XML_FILE="${XML_FILE}".new

	${WIT} dolpatch ${DOL} xml="${XML_FILE}" -s "${XML_SOURCE}" xml="${PATCHIMAGE_PATCH_DIR}/NewerSMBW-Loader.xml" -q
	${WIT} dolpatch ${DOL} xml="${PATCHIMAGE_PATCH_DIR}/NSMBW_AP.xml" -q

}
