#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="https://ia903406.us.archive.org/0/items/new-super-mario-bros-wii-mod-archive/Original%20Versions/Newer%20Super%20Luigi%20Wii%20-%20Dark%20Moon%20V%201.2.0.zip"
RIIVOLUTION_ZIP="Newer Super Luigi Wii - Dark Moon V 1.2.0.zip"
RIIVOLUTION_DIR="DarkMoon"
GAMENAME="Newer Super Luigi Wii: Dark Moon"
GAME_TYPE=RIIVOLUTION
XML_SOURCE="${RIIVOLUTION_DIR}"
XML_FILE="${RIIVOLUTION_DIR}"/../riivolution/DarkMoon.xml
BANNER_LOCATION=${WORKDIR}/files/opening.bnr
WBFS_MASK="SMN[PEJ]01"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Newer Super Luigi Wii: Dark Moon is a fan-made sequel to Newer Super Mario Bros. Wii.
Freshened up from their last adventure, Mario and the gang decide to explore a small remote location called Evershade Isles.
However, in the midst of their expedition, Mario goes missing! Looks like it's up to Luigi to save the day!

Features:

    Luigi as the star of the show
    Wario as a playable character in multiplayer
    8 new unique levels
    24 tricky star coins to collect
    a shiny new map
    various recolored objects
    ...and much more!

http://horizonwii.net/?page=post&id=3473
https://youtu.be/WuCgPhKuASM

Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

detect_game_version () {

	nsmbw_version
	GAMEID=SMN${REG_LETTER}ZB

}

place_files () {

	NEW_DIRS=( "${WORKDIR}"/files/LevelSamples "${WORKDIR}"/files/NewerRes "${WORKDIR}"/files/Sound/new/sfx "${WORKDIR}"/files/Maps )
	for dir in "${NEW_DIRS[@]}"; do
		mkdir -p "${dir}"
	done

	case ${VERSION} in
		EUR* )
			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU NedEU )
			for dir in "${LANGDIRS[@]}"; do
				cp -r "${RIIVOLUTION_DIR}"/{Font,Message}/ "${WORKDIR}"/files/EU/"${dir}"/
			done
			cp "${RIIVOLUTION_DIR}"/OthersP/* "${WORKDIR}"/files/EU/Layout/openingTitle/
		;;

		USAv* )
			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in "${LANGDIRS[@]}"; do
				cp -r "${RIIVOLUTION_DIR}"/{Font,Message}/ "${WORKDIR}"/files/US/"${dir}"/
			done
			cp "${RIIVOLUTION_DIR}"/OthersE/* "${WORKDIR}"/files/US/Layout/openingTitle/
		;;

		JPNv1 )
			cp "${RIIVOLUTION_DIR}"/Font/* "${WORKDIR}"/files/JP/Font/
			cp "${RIIVOLUTION_DIR}"/Message/* "${WORKDIR}"/files/JP/Message/
			cp "${RIIVOLUTION_DIR}"/OthersJ/* "${WORKDIR}"/files/JP/Layout/openingTitle/
		;;
	esac

	cp "${RIIVOLUTION_DIR}"/Tilesets/* "${WORKDIR}"/files/Stage/Texture/
	cp "${RIIVOLUTION_DIR}"/TitleReplay/* "${WORKDIR}"/files/Replay/title/
	cp "${RIIVOLUTION_DIR}"/BGs/* "${WORKDIR}"/files/Object/
	cp "${RIIVOLUTION_DIR}"/SpriteTex/* "${WORKDIR}"/files/Object/
	cp "${RIIVOLUTION_DIR}"/Layouts/* "${WORKDIR}"/files/Layout/
	cp -r "${RIIVOLUTION_DIR}"/Music/*.er "${WORKDIR}"/files/Sound/new/
	cp "${RIIVOLUTION_DIR}"/Music/sfx/* "${WORKDIR}"/files/Sound/new/sfx/
	cp "${RIIVOLUTION_DIR}"/Music/stream/* "${WORKDIR}"/files/Sound/stream/
	cp "${RIIVOLUTION_DIR}"/Music/rsar/* "${WORKDIR}"/files/Sound/
	cp "${RIIVOLUTION_DIR}"/NewerRes/* "${WORKDIR}"/files/NewerRes/
	cp "${RIIVOLUTION_DIR}"/LevelSamples/* "${WORKDIR}"/files/LevelSamples/
	cp "${RIIVOLUTION_DIR}"/Others/charaChangeSelectContents.arc "${WORKDIR}"/files/Layout/charaChangeSelectContents/charaChangeSelectContents.arc
	cp "${RIIVOLUTION_DIR}"/Others/characterChange.arc "${WORKDIR}"/files/Layout/characterChange/characterChange.arc
	cp "${RIIVOLUTION_DIR}"/Others/continue.arc "${WORKDIR}"/files/Layout/continue/continue.arc
	cp "${RIIVOLUTION_DIR}"/Others/controllerInformation.arc "${WORKDIR}"/files/Layout/controllerInformation/controllerInformation.arc
	cp "${RIIVOLUTION_DIR}"/Others/corseSelectMenu.arc "${WORKDIR}"/files/Layout/corseSelectMenu/corseSelectMenu.arc
	cp "${RIIVOLUTION_DIR}"/Others/corseSelectUIGuide.arc "${WORKDIR}"/files/Layout/corseSelectUIGuide/corseSelectUIGuide.arc
	cp "${RIIVOLUTION_DIR}"/Others/dateFile.arc "${WORKDIR}"/files/Layout/dateFile/dateFile.arc
	cp "${RIIVOLUTION_DIR}"/Others/dateFile_OLD.arc "${WORKDIR}"/files/Layout/dateFile/dateFile_OLD.arc
	cp "${RIIVOLUTION_DIR}"/Others/easyPairing.arc "${WORKDIR}"/files/Layout/easyPairing/easyPairing.arc
	cp "${RIIVOLUTION_DIR}"/Others/extensionControllerNunchuk.arc "${WORKDIR}"/files/Layout/extensionControllerNunchuk/extensionControllerNunchuk.arc
	cp "${RIIVOLUTION_DIR}"/Others/extensionControllerYokomochi.arc "${WORKDIR}"/files/Layout/extensionControllerYokomochi/extensionControllerYokomochi.arc
	cp "${RIIVOLUTION_DIR}"/Others/fileSelectBase.arc "${WORKDIR}"/files/Layout/fileSelectBase/fileSelectBase.arc
	cp "${RIIVOLUTION_DIR}"/Others/fileSelectBase_OLD.arc "${WORKDIR}"/files/Layout/fileSelectBase/fileSelectBase_OLD.arc
	cp "${RIIVOLUTION_DIR}"/Others/fileSelectPlayer.arc "${WORKDIR}"/files/Layout/fileSelectPlayer/fileSelectPlayer.arc
	cp "${RIIVOLUTION_DIR}"/Others/gameScene.arc "${WORKDIR}"/files/Layout/gameScene/gameScene.arc
	cp "${RIIVOLUTION_DIR}"/Others/infoWindow.arc "${WORKDIR}"/files/Layout/infoWindow/infoWindow.arc
	cp "${RIIVOLUTION_DIR}"/Others/miniGameCannon.arc "${WORKDIR}"/files/Layout/miniGameCannon/miniGameCannon.arc
	cp "${RIIVOLUTION_DIR}"/Others/miniGameWire.arc "${WORKDIR}"/files/Layout/miniGameWire/miniGameWire.arc
	cp "${RIIVOLUTION_DIR}"/Others/pauseMenu.arc "${WORKDIR}"/files/Layout/pauseMenu/pauseMenu.arc
	cp "${RIIVOLUTION_DIR}"/Others/pointResultDateFile.arc "${WORKDIR}"/files/Layout/pointResultDateFile/pointResultDateFile.arc
	cp "${RIIVOLUTION_DIR}"/Others/pointResultDateFileFree.arc "${WORKDIR}"/files/Layout/pointResultDateFileFree/pointResultDateFileFree.arc
	cp "${RIIVOLUTION_DIR}"/Others/preGame.arc "${WORKDIR}"/files/Layout/preGame/preGame.arc
	cp "${RIIVOLUTION_DIR}"/Others/select_cursor.arc "${WORKDIR}"/files/Layout/select_cursor/select_cursor.arc
	cp "${RIIVOLUTION_DIR}"/Others/sequenceBG.arc "${WORKDIR}"/files/Layout/sequenceBG/sequenceBG.arc
	cp "${RIIVOLUTION_DIR}"/Others/staffCredit.arc "${WORKDIR}"/files/Layout/staffCredit/staffCredit.arc
	cp "${RIIVOLUTION_DIR}"/Others/stockItem.arc "${WORKDIR}"/files/Layout/stockItem/stockItem.arc
	cp "${RIIVOLUTION_DIR}"/Others/stockItemShadow.arc "${WORKDIR}"/files/Layout/stockItemShadow/stockItemShadow.arc
	cp "${RIIVOLUTION_DIR}"/Others/yesnoWindow.arc "${WORKDIR}"/files/Layout/yesnoWindow/yesnoWindow.arc
	cp -r "${RIIVOLUTION_DIR}"/Maps/* "${WORKDIR}"/files/Maps/
	cp "${RIIVOLUTION_DIR}"/Stages/* "${WORKDIR}"/files/Stage/

}


dolpatch () {

	cp "${XML_FILE}" "${XML_FILE}".new
	sed -e 's/80001800/803482C0/g' -i "${XML_FILE}".new
	XML_FILE="${XML_FILE}".new

	${WIT} dolpatch ${DOL} xml="${XML_FILE}" -s "${XML_SOURCE}" \
		xml="${PATCHIMAGE_PATCH_DIR}/NewerSMBW-Loader.xml" -q
	${WIT} dolpatch ${DOL} xml="${PATCHIMAGE_PATCH_DIR}/NSMBW_AP.xml" -q

}
