#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="http://www.nanolx.org/riivolution/Cannon_Super_Mario_Bros._Wii_v1.1.zip"
RIIVOLUTION_ZIP="Cannon_Super_Mario_Bros._Wii_v1.1.zip"
RIIVOLUTION_DIR="Cannon_Super_Mario_Bros._Wii_v1.1"
GAMENAME="Cannon Super Mario Bros."
XML_SOURCE="${RIIVOLUTION_DIR}"/Cannon/
XML_FILE="${RIIVOLUTION_DIR}"/riivolution/CannonP.xml
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr
WBFS_MASK="SMN[PEJ]01"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

- 14 full new levels divided over 3 worlds
- Over 50 new goodies and retextured objects
- Many custom music composed over almost all levels
- And of course some custom tilesets

Source:			http://www.rvlution.net/forums/viewtopic.php?f=20&t=1080
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

detect_game_version () {

	nsmbw_version

	GAMEID=SMN${REG_LETTER}04
	CUSTOM_BANNER=http://dl.dropboxusercontent.com/u/101209384/${GAMEID}.bnr

}

place_files () {

	NEW_DIRS=( "${WORKDIR}"/files/NewerRes )
	for dir in "${NEW_DIRS[@]}"; do
		mkdir -p "${dir}"
	done

	case ${VERSION} in
		EUR* )
			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU NedEU )
			for dir in "${LANGDIRS[@]}"; do
				cp -r "${RIIVOLUTION_DIR}"/Cannon/MessageEN/* "${WORKDIR}"/files/EU/"${dir}"/
			done
			cp "${RIIVOLUTION_DIR}"/Cannon/OpeningP/* "${WORKDIR}"/files/EU/Layout/openingTitle/
		;;

		USAv* )
			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in "${LANGDIRS[@]}"; do
				cp -r "${RIIVOLUTION_DIR}"/Cannon/MessageEN/* "${WORKDIR}"/files/US/"${dir}"/
			done
			cp "${RIIVOLUTION_DIR}"/Cannon/OpeningE/* "${WORKDIR}"/files/US/Layout/openingTitle/
		;;

		JPNv1 )
			cp -r "${RIIVOLUTION_DIR}"/Cannon/MessageEN/* "${WORKDIR}"/files/JP/
			cp "${RIIVOLUTION_DIR}"/Cannon/OpeningJ/* "${WORKDIR}"/files/JP/Layout/openingTitle/
		;;
	esac

	cp "${RIIVOLUTION_DIR}"/Cannon/Stage/Texture/* "${WORKDIR}"/files/Stage/Texture/
	cp "${RIIVOLUTION_DIR}"/Cannon/NewerRes/* "${WORKDIR}"/files/NewerRes/
	cp "${RIIVOLUTION_DIR}"/Cannon/Stage/*.arc "${WORKDIR}"/files/Stage/
	cp "${RIIVOLUTION_DIR}"/Cannon/Env/* "${WORKDIR}"/files/Env/
	cp "${RIIVOLUTION_DIR}"/Cannon/Sound/Stream/* "${WORKDIR}"/files/Sound/stream/
	cp "${RIIVOLUTION_DIR}"/Cannon/Sound/*.brsar "${WORKDIR}"/files/Sound/
	cp "${RIIVOLUTION_DIR}"/Cannon/WorldMap/* "${WORKDIR}"/files/WorldMap/
	cp "${RIIVOLUTION_DIR}"/Cannon/Object/* "${WORKDIR}"/files/Object/
	cp "${RIIVOLUTION_DIR}"/Cannon/MovieDemo/* "${WORKDIR}"/files/MovieDemo/
	cp -r "${RIIVOLUTION_DIR}"/Cannon/Layout/ "${WORKDIR}"/files/

}

dolpatch () {

	cp "${XML_FILE}" "${XML_FILE}".new
	sed -e 's/80001800/803482C0/g' -i "${XML_FILE}".new
	XML_FILE="${XML_FILE}".new

	${WIT} dolpatch ${DOL} xml="${XML_FILE}" -s "${XML_SOURCE}" \
		"802F148C=53756D6D53756E#7769696D6A3264" \
		"802F118C=53756D6D53756E#7769696D6A3264" \
		"802F0F8C=53756D6D53756E#7769696D6A3264" \
		xml="${PATCHIMAGE_PATCH_DIR}/Cannon-Loader.xml" -q

	${WIT} dolpatch ${DOL} xml="${PATCHIMAGE_PATCH_DIR}/NSMBW_AP.xml" -q

}

