#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="https://www.dropbox.com/s/d2rb358ljcq21k5/Skyland.zip"
RIIVOLUTION_ZIP="Skyland.zip"
RIIVOLUTION_DIR="Skyland/Skyland"
GAMENAME="Super Mario Skyland"
XML_SOURCE="${RIIVOLUTION_DIR}"
XML_FILE="${RIIVOLUTION_DIR}"/../riivolution/Skyland.xml
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr
WBFS_MASK="SMN[PUJ]01"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Super Mario Skyland is an Mini-Hack based on World 7 of NSMBWII.
The goal of it was to replace every level including the ambush ones.
The difficulty has been increased also so you might consider to die
harder then in the Original. Even it was not tested in Multiplayer
it may work or not.

Source:			http://rvlution.net/thread/2153-super-mario-skyland/
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

detect_game_version () {

	nsmbw_version
	GAMEID=SMN${REG_LETTER}ZY

}

place_files () {

	cp "${RIIVOLUTION_DIR}"/Stage/*.arc "${WORKDIR}"/files/Stage/
	cp "${RIIVOLUTION_DIR}"/Stage/Texture/* "${WORKDIR}"/files/Stage/Texture/
	cp "${RIIVOLUTION_DIR}"/Sound/*.brsar "${WORKDIR}"/files/Sound/
	cp "${RIIVOLUTION_DIR}"/Sound/Stream/* "${WORKDIR}"/files/Sound/stream/

}


dolpatch () {

	${WIT} dolpatch ${DOL} \
		"802F148C=53756D6D53756E#7769696D6A3264" \
		"802F118C=53756D6D53756E#7769696D6A3264" \
		"802F0F8C=53756D6D53756E#7769696D6A3264" \
		xml="${PATCHIMAGE_PATCH_DIR}/NSMBW_AP.xml" -q

}

