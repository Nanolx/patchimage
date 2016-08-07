#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="http://www.mediafire.com/download/wsob4c27urgkl62/MLGLuigiWii.zip"
RIIVOLUTION_ZIP="MLGLuigiWii.zip"
RIIVOLUTION_DIR="MLGLuigiWii/MLGLuigi"
GAMENAME="MLG Super Luigi Wii"
XML_SOURCE="${RIIVOLUTION_DIR}"
XML_FILE="${RIIVOLUTION_DIR}"/../riivolution/MLGLuigiE.xml
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr
WBFS_MASK="SMN[PUJ]01"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Story: As soon as Mario, Luigi, and their friends arrived with Peach safe and
sound from destroying Bowser’s world they saw all the way back in World 6 a rift
opening up. Then on World 1 a rift opened up and sucked up both Mario and Peach.

From there a wild void spread through the land changing the layouts and worlds
as everyone knows it. Now its up to Luigi to save Mario and Peach.

Along with a new friend.

This hacks includes:
 * 3 remodeled worlds with brand new themes.
 * 1 reused tileset from an old hack everyone loves (ESBW)
 * Minecraft tileset
 * Play as MLG Luigi as P1 and Void Luigi (P2,3,4)
 * Retextured sprites and objects
 * Along with collecting star coins. Can you find the secret keys in each level?
 * Tons of brand new levels and challenges as well
 * Remakes of old school levels

Source:			http://rvlution.net/thread/4538-mlg-super-luigi-bros-wii/
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

detect_game_version () {

	nsmbw_version
	GAMEID=SLB${REG_LETTER}01

}

place_files () {

	NEW_DIRS=( "${WORKDIR}"/files/EU/NedEU/{Message,staffroll,Font}
		"${WORKDIR}"/files/EU/PolEU/{Message,staffroll,Font}
		"${WORKDIR}"/files/NewerRes )
	for dir in "${NEW_DIRS[@]}"; do
		mkdir -p "${dir}"
	done

	case ${VERSION} in
		EUR* )
			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU NedEU PolEU )
			for dir in "${LANGDIRS[@]}"; do
				cp "${RIIVOLUTION_DIR}"/EU/EngEU/message/Message.arc "${WORKDIR}"/files/EU/"${dir}"/Message/Message.arc
				cp "${RIIVOLUTION_DIR}"/EU/EngEU/staffroll/staffroll.bin "${WORKDIR}"/files/EU/"${dir}"/staffroll/staffroll.bin
				cp "${RIIVOLUTION_DIR}"/Font/* "${WORKDIR}"/files/EU/"${dir}"/Font/
			done
			cp -r "${RIIVOLUTION_DIR}"/OpeningE/openingTitle.arc "${WORKDIR}"/files/EU/Layout/openingTitle/
		;;

		USAv* )
			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in "${LANGDIRS[@]}"; do
				cp "${RIIVOLUTION_DIR}"/EU/EngEU/message/Message.arc "${WORKDIR}"/files/US/"${dir}"/Message/Message.arc
				cp "${RIIVOLUTION_DIR}"/EU/EngEU/staffroll/staffroll.bin "${WORKDIR}"/files/US/"${dir}"/staffroll/staffroll.bin
				cp "${RIIVOLUTION_DIR}"/Font/* "${WORKDIR}"/files/US/"${dir}"/Font/
			done
			#cp -r "${RIIVOLUTION_DIR}"/OpeningE/openingTitle.arc "${WORKDIR}"/files/US/Layout/openingTitle/
		;;

		JPNv1 )
			cp "${RIIVOLUTION_DIR}"/EU/EngEU/message/Message.arc "${WORKDIR}"/files/JP/Message/Message.arc
			cp "${RIIVOLUTION_DIR}"/EU/EngEU/staffroll/staffroll.bin "${WORKDIR}"/files/JP/staffroll/staffroll.bin
			cp "${RIIVOLUTION_DIR}"/Font/* "${WORKDIR}"/files/JP/Font/
			#cp -r "${RIIVOLUTION_DIR}"/OpeningE/openingTitle.arc "${WORKDIR}"/files/JP/Layout/openingTitle/
		;;
	esac

	cp "${RIIVOLUTION_DIR}"/Env/* "${WORKDIR}"/files/Env/
	cp -r "${RIIVOLUTION_DIR}"/Layout/* "${WORKDIR}"/files/Layout/
	cp "${RIIVOLUTION_DIR}"/MovieDemo/* "${WORKDIR}"/files/MovieDemo/
	cp -r "${RIIVOLUTION_DIR}"/NewerRes/* "${WORKDIR}"/files/NewerRes/
	cp "${RIIVOLUTION_DIR}"/Object/* "${WORKDIR}"/files/Object/
	cp "${RIIVOLUTION_DIR}"/Sound/stream/*.brstm "${WORKDIR}"/files/Sound/stream/
	cp "${RIIVOLUTION_DIR}"/Sound/*.brsar "${WORKDIR}"/files/Sound/
	cp "${RIIVOLUTION_DIR}"/Stage/*.arc "${WORKDIR}"/files/Stage/
	cp "${RIIVOLUTION_DIR}"/Stage/Texture/* "${WORKDIR}"/files/Stage/Texture/
	cp "${RIIVOLUTION_DIR}"/WorldMap/* "${WORKDIR}"/files/WorldMap/

}


dolpatch () {

	cp "${XML_FILE}" "${XML_FILE}".new
	sed -e 's/80001800/803482C0/g' -i "${XML_FILE}".new
	XML_FILE="${XML_FILE}".new

	${WIT} dolpatch ${DOL} xml="${XML_FILE}" -s "${XML_SOURCE}" \
		xml="${PATCHIMAGE_PATCH_DIR}/NewerSMBW-Loader.xml" -q
	${WIT} dolpatch ${DOL} xml="${PATCHIMAGE_PATCH_DIR}/NSMBW_AP.xml" -q

}

