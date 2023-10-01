#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="https://ia803406.us.archive.org/0/items/new-super-mario-bros-wii-mod-archive/Original%20Versions/Luigi%27s%20Super%20Yoshi%20Bros.zip"
RIIVOLUTION_ZIP="Luigi's Super Yoshi Bros.zip"
RIIVOLUTION_DIR="LSYB"
GAMENAME="Luigis Super Yoshi Bros."
XML_SOURCE="${RIIVOLUTION_DIR}"
XML_FILE="${RIIVOLUTION_DIR}"/LSYB
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr
WBFS_MASK="SMN[PEJ]01"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Luigi's Super Yoshi Bros. is a mini NSMBW hack that features:
- Only 1 World
- Some Custom Tilesets

Source:			http://rvlution.net/thread/1967-luigi-s-super-yoshi-bros/
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv1, JPNv1
************************************************"

}

detect_game_version () {

	nsmbw_version
	GAMEID=SMN${REG_LETTER}YL
	XML_FILE="${XML_FILE}"${REG_LETTER}.xml

}

place_files () {

	cp -r "${RIIVOLUTION_DIR}"/{Env,Layout,Object,Stage,WorldMap} "${WORKDIR}"/files

	NEW_DIRS=( "${WORKDIR}"/files/EU/NedEU/Message )
	for dir in "${NEW_DIRS[@]}"; do
		mkdir -p "${dir}"
	done

	case ${VERSION} in
		EURv* )

			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU NedEU )
			for dir in "${LANGDIRS[@]}"; do
				cp "${RIIVOLUTION_DIR}"/MessageEN/* "${WORKDIR}"/files/EU/"${dir}"/Message/
			done
			cp "${RIIVOLUTION_DIR}"/OpeningP/* "${WORKDIR}"/files/EU/Layout/openingTitle/

		;;

		USAv* )

			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in "${LANGDIRS[@]}"; do
				cp "${RIIVOLUTION_DIR}"/MessageEN/* "${WORKDIR}"/files/US/"${dir}"/Message/
			done
			cp "${RIIVOLUTION_DIR}"/OpeningE/* "${WORKDIR}"/files/US/Layout/openingTitle/
		;;

		JPNv* )
			cp "${RIIVOLUTION_DIR}"/MessageEN/* "${WORKDIR}"/files/JP/Message/
			cp "${RIIVOLUTION_DIR}"/OpeningJ/* "${WORKDIR}"/files/JP/Layout/openingTitle/
		;;
	esac

}

dolpatch() {

	${WIT} dolpatch ${DOL}	\
		"802F148C=53756D6D53756E#7769696D6A3264" \
		"802F118C=53756D6D53756E#7769696D6A3264" \
		"802F0F8C=53756D6D53756E#7769696D6A3264" \
		xml="${PATCHIMAGE_PATCH_DIR}/NSMBW_AP.xml" -q

}
