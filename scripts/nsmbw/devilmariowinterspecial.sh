#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="http://riivolution.nanolx.org/Devil%20Mario%20Winter%20Special%20collabo%20Frozen.zip"
RIIVOLUTION_ZIP="Devil Mario Winter Special collabo Frozen.zip"
RIIVOLUTION_DIR="Devil MWSP_English/"
GAMENAME="Devil Mario Winter Special"
XML_SOURCE="${RIIVOLUTION_DIR}"
XML_FILE="${RIIVOLUTION_DIR}/../riivolution/Devil SMWSP-Eng.xml"
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr
WBFS_MASK="SMN[PEJ]01"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Source:			http://rvlution.net/thread/3233-devil-mario-winter-special/
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

detect_game_version () {

	nsmbw_version
	GAMEID=SMN${REG_LETTER}41

}

place_files () {


	NEW_DIRS=( "${WORKDIR}"/files/NewerRes "${WORKDIR}"/files/EU/NedEU/{Message,staffroll} )
	for dir in "${NEW_DIRS[@]}"; do
		mkdir -p "${dir}"
	done

	cp -r "${RIIVOLUTION_DIR}"/EU/EngEU/{m,M}essage

	case ${VERSION} in
		EUR* )
			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU NedEU )
			for dir in "${LANGDIRS[@]}"; do
				cp -r "${RIIVOLUTION_DIR}"/EU/EngEU/{Message,staffroll}/ "${WORKDIR}"/files/EU/"${dir}"/
			done
			cp "${RIIVOLUTION_DIR}"/OpeningP/* "${WORKDIR}"/files/EU/Layout/openingTitle/
		;;

		USAv* )
			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in "${LANGDIRS[@]}"; do
				cp -r "${RIIVOLUTION_DIR}"/EU/EngEU/{Message,staffroll}/ "${WORKDIR}"/files/US/"${dir}"/
			done
			cp "${RIIVOLUTION_DIR}"/OpeningE/* "${WORKDIR}"/files/US/Layout/openingTitle/
		;;

		JPNv1 )
			cp -r "${RIIVOLUTION_DIR}"/EU/EngEU/{Message,staffroll}/ "${WORKDIR}"/files/JP/
			cp "${RIIVOLUTION_DIR}"/OpeningJ/* "${WORKDIR}"/files/JP/Layout/openingTitle/
		;;
	esac

	cp "${RIIVOLUTION_DIR}"/Stage/Texture/* "${WORKDIR}"/files/Stage/Texture/
	cp "${RIIVOLUTION_DIR}"/NewerRes/* "${WORKDIR}"/files/NewerRes/
	cp "${RIIVOLUTION_DIR}"/Stage/*.arc "${WORKDIR}"/files/Stage/
	cp "${RIIVOLUTION_DIR}"/Env/* "${WORKDIR}"/files/Env/
	cp "${RIIVOLUTION_DIR}"/Sound/stream/* "${WORKDIR}"/files/Sound/stream/
	cp "${RIIVOLUTION_DIR}"/Sound/*.{brsar,brstm} "${WORKDIR}"/files/Sound/
	cp "${RIIVOLUTION_DIR}"/WorldMap/* "${WORKDIR}"/files/WorldMap/
	cp -r "${RIIVOLUTION_DIR}"/Object/ "${WORKDIR}"/files/Object/
	cp "${RIIVOLUTION_DIR}"/MovieDemo/* "${WORKDIR}"/files/MovieDemo/
	cp "${RIIVOLUTION_DIR}"/Layout/*.arc "${WORKDIR}"/files/Layout/

}

dolpatch () {

	cp "${XML_FILE}" "${XML_FILE}".new
	sed -e 's/80001800/803482C0/g' -i "${XML_FILE}".new
	XML_FILE="${XML_FILE}".new

	${WIT} dolpatch ${DOL} xml="${XML_FILE}" -s "${XML_SOURCE}" xml="${PATCHIMAGE_PATCH_DIR}/NewerSMBW-Loader.xml" -q
	${WIT} dolpatch ${DOL} xml="${PATCHIMAGE_PATCH_DIR}/NSMBW_AP.xml" -q

}
