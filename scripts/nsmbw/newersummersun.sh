#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="http://dirbaio.net/newer/Newer_Summer_Sun.zip"
SOUNDTRACK_LINK="http://dirbaio.net/newer/Newer_Summer_Sun_Soundtrack.zip"
SOUNDTRACK_ZIP="Newer_Summer_Sun_Soundtrack.zip"
RIIVOLUTION_ZIP="Newer_Summer_Sun.zip"
RIIVOLUTION_DIR="Newer Summer Sun"
GAMENAME="Newer Summer Sun"
XML_SOURCE="${RIIVOLUTION_DIR}"/SumSun/
XML_FILE="${RIIVOLUTION_DIR}"/riivolution/SumSunP.xml
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr
WBFS_MASK="SMN[PUJ]01"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Newer: Summer Sun is a short game with a hot theme, originally released
in Summer 2012. It features 23 new levels and some fresh music!

Source:			http://www.newerteam.com/specials.html
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

detect_game_version () {

	nsmbw_version

	GAMEID=SMN${REG_LETTER}06
	CUSTOM_BANNER=http://dl.dropboxusercontent.com/u/101209384/${GAMEID}.bnr

}

place_files () {

	NEW_DIRS=( "${WORKDIR}"/files/NewerRes "${WORKDIR}"/files/EU/NedEU )
	for dir in "${NEW_DIRS[@]}"; do
		mkdir -p "${dir}"
	done

	cp -r "${RIIVOLUTION_DIR}"/SumSun/EU/EngEU/{m,M}essage

	case ${VERSION} in
		EUR* )
			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU NedEU )
			for dir in "${LANGDIRS[@]}"; do
				cp -r "${RIIVOLUTION_DIR}"/SumSun/EU/EngEU/{Message,staffroll}/ "${WORKDIR}"/files/EU/"${dir}"/
			done
			cp "${RIIVOLUTION_DIR}"/SumSun/OpeningP/* "${WORKDIR}"/files/EU/Layout/openingTitle/
		;;

		USAv* )
			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in "${LANGDIRS[@]}"; do
				cp -r "${RIIVOLUTION_DIR}"/SumSun/EU/EngEU/{Message,staffroll}/ "${WORKDIR}"/files/US/"${dir}"/
			done
			cp "${RIIVOLUTION_DIR}"/SumSun/OpeningE/* "${WORKDIR}"/files/US/Layout/openingTitle/
		;;

		JPNv1 )
			cp -r "${RIIVOLUTION_DIR}"/SumSun/EU/EngEU/{Message,staffroll}/ "${WORKDIR}"/files/JP/
			cp "${RIIVOLUTION_DIR}"/SumSun/OpeningJ/* "${WORKDIR}"/files/JP/Layout/openingTitle/
		;;
	esac

	cp "${RIIVOLUTION_DIR}"/SumSun/Stage/Texture/* "${WORKDIR}"/files/Stage/Texture/
	cp "${RIIVOLUTION_DIR}"/SumSun/NewerRes/* "${WORKDIR}"/files/NewerRes/
	cp "${RIIVOLUTION_DIR}"/SumSun/Stage/*.arc "${WORKDIR}"/files/Stage/
	cp "${RIIVOLUTION_DIR}"/SumSun/Env/* "${WORKDIR}"/files/Env/
	cp "${RIIVOLUTION_DIR}"/SumSun/sound/stream/* "${WORKDIR}"/files/Sound/stream/
	cp "${RIIVOLUTION_DIR}"/SumSun/sound/*.brsar "${WORKDIR}"/files/Sound/
	cp "${RIIVOLUTION_DIR}"/SumSun/WorldMap/* "${WORKDIR}"/files/WorldMap/
	cp "${RIIVOLUTION_DIR}"/SumSun/Object/* "${WORKDIR}"/files/Object/
	cp "${RIIVOLUTION_DIR}"/SumSun/Layout/preGame.arc "${WORKDIR}"/files/Layout/preGame/pregame.arc
	cp "${RIIVOLUTION_DIR}"/SumSun/Layout/sequenceBG.arc "${WORKDIR}"/files/Layout/sequenceBG/sequenceBG.arc
	cp "${RIIVOLUTION_DIR}"/SumSun/Layout/sequenceBGTexture.arc "${WORKDIR}"/files/Layout/textures/sequenceBGTexture.arc

}

dolpatch () {

	cp "${XML_FILE}" "${XML_FILE}".new
	sed -e 's/80001800/803482C0/g' -i "${XML_FILE}".new
	XML_FILE="${XML_FILE}".new

	${WIT} dolpatch ${DOL} xml="${XML_FILE}" -s "${XML_SOURCE}" \
		"802F148C=53756D6D53756E#7769696D6A3264" \
		"802F118C=53756D6D53756E#7769696D6A3264" \
		"802F0F8C=53756D6D53756E#7769696D6A3264" \
		xml="${PATCHIMAGE_PATCH_DIR}/SummerSun-Loader.xml" -q

	${WIT} dolpatch ${DOL} xml="${PATCHIMAGE_PATCH_DIR}/NSMBW_AP.xml" -q

}
