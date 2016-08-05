#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="https://docs.google.com/uc?id=0B0P-eSDZCIexTXdHZm5Xbk9HbEU&export=download"
RIIVOLUTION_ZIP="WinterMoon.rar"
RIIVOLUTION_DIR="WinterMoon"
GAMENAME="SMMA+: Winter Moon"
XML_SOURCE="${RIIVOLUTION_DIR}"
XML_FILE="${RIIVOLUTION_DIR}"/../riivolution/WinterMoon.xml
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr
WBFS_MASK="SMN[PUJ]01"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

9 new levels:
4 from the full game (modified to fit the special's
theme) and 5 completely new and exclusive to the special.

Custom music:
Including both music from past Mario games and new music!

Custom backgrounds:
New backgrounds exclusive for the special!

Custom tilesets:
Including both all-new and retextured tilesets!

Source:			http://www.rvlution.net/forums/viewtopic.php?f=53&t=1707
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

detect_game_version () {

	nsmbw_version

	GAMEID=SMM${REG_LETTER}02

}

place_files () {

	NEW_DIRS=( ${WORKDIR}/files/EU/NedEU/Message ${WORKDIR}/files/EU/PolEU/Message ${WORKDIR}/files/Sample/)
	for dir in ${NEW_DIRS[@]}; do
		mkdir -p ${dir}
	done

	case ${VERSION} in
		EUR* )
			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU NedEU PolEU )
			for dir in ${LANGDIRS[@]}; do
				cp "${RIIVOLUTION_DIR}"/Others/Text.arc ${WORKDIR}/files/EU/${dir}/Message/Message.arc
			done
			#cp "${RIIVOLUTION_DIR}"/Others/Title/Logo.arc ${WORKDIR}/files/EU/Layout/openingTitle/openingTitle.arc
		;;

		USAv* )
			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in ${LANGDIRS[@]}; do
				cp "${RIIVOLUTION_DIR}"/Others/Text.arc ${WORKDIR}/files/US/${dir}/Message/Message.arc
			done
			cp "${RIIVOLUTION_DIR}"/Others/Title/Logo.arc ${WORKDIR}/files/US/Layout/openingTitle/openingTitle.arc
		;;

		JPNv1 )
			cp "${RIIVOLUTION_DIR}"/Others/Text.arc ${WORKDIR}/files/JP/
			#cp "${RIIVOLUTION_DIR}"/Others/Title/Logo.arc ${WORKDIR}/files/JP/Layout/openingTitle/openingTitle.arc
		;;
	esac

	cp "${RIIVOLUTION_DIR}"/Levels/*.arc ${WORKDIR}/files/Stage/
	cp "${RIIVOLUTION_DIR}"/Tilesets/* ${WORKDIR}/files/Stage/Texture/
	cp "${RIIVOLUTION_DIR}"/Backgrounds/* ${WORKDIR}/files/Object/
	cp "${RIIVOLUTION_DIR}"/Music/BRSTM/* ${WORKDIR}/files/Sound/stream/
	cp "${RIIVOLUTION_DIR}"/Music/BRSAR/* ${WORKDIR}/files/Sound/
	cp "${RIIVOLUTION_DIR}"/Map/* ${WORKDIR}/files/WorldMap/
	cp "${RIIVOLUTION_DIR}"/Others/Env/NwrXmas_env.arc ${WORKDIR}/files/Env/Env_world.arc
	cp "${RIIVOLUTION_DIR}"/Others/Title/Level.arc ${WORKDIR}/files/Stage/01-40.arc
	cp "${RIIVOLUTION_DIR}"/Others/UI/MMTex.arc ${WORKDIR}/files/Layout/textures/sequenceBGTexture.arc
	cp "${RIIVOLUTION_DIR}"/Others/UI/MM.arc ${WORKDIR}/files/Layout/sequenceBG/sequenceBG.arc
	cp "${RIIVOLUTION_DIR}"/Others/UI/MMMain.arc ${WORKDIR}/files/Layout/dateFile/dateFile.arc
	cp "${RIIVOLUTION_DIR}"/Others/UI/Banners.arc ${WORKDIR}/files/Layout/preGame/preGame.arc
	cp "${RIIVOLUTION_DIR}"/Others/UI/Players.arc ${WORKDIR}/files/Layout/fileSelectPlayer/fileSelectPlayer.arc
	cp "${RIIVOLUTION_DIR}"/Sample/tobira.bti ${WORKDIR}/files/Sample/tobira.bti

}


dolpatch () {

	${WIT} dolpatch ${DOL}	\
		"802F148C=53756D6D53756E#7769696D6A3264" \
		"802F118C=53756D6D53756E#7769696D6A3264" \
		"802F0F8C=53756D6D53756E#7769696D6A3264" \
		xml="${PATCHIMAGE_PATCH_DIR}/NSMBW_AP.xml" -q

}

