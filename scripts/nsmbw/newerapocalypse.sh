#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="http://nanolx.org/riivolution/NewerApocalypse%201.0.zip"
RIIVOLUTION_ZIP="NewerApocalypse 1.0.zip"
RIIVOLUTION_DIR="NewerApocalypse"
GAMENAME="Newer Apocalypse"
XML_SOURCE="${RIIVOLUTION_DIR}"
XML_FILE="${RIIVOLUTION_DIR}"/../riivolution/NewerApocalypse.xml
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr
WBFS_MASK="SMN[PEJ]01"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Newer Apocalypse takes place about two Years after Newer.

Recently, strange Events occured in the Area of Newer Island. Rifts were spotted around Sky Mountain, Rubble Ruins and
Goldwood Forest and Sakura Village was evacuated. Freezeflame Glacier began to melt and the Crystal Caverns were flooded
with Lava due to the Volcano erupting without Pause. Princess Peach decides to travel to Yoshi's Island to find out what is wrong.

After no one has heard anything from the Princess for two Weeks, Mario and Friends rush to Yoshi's Island suspecting Bowser
to be the Culprit. But upon reaching the once wonderful Paradise, they find a dark and gloomy World. The entire Island was clad
in Fog and the Water seemed to be Blood. Mario didn't hesitate to head off into the Fog to find his beloved Princess not knowing
what would await him.

Source:			http://rvlution.net/thread/2507-newer-apocalypse/
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

detect_game_version () {

	nsmbw_version
	GAMEID=SMN${REG_LETTER}ZA

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

	${WIT} dolpatch ${DOL} xml="${XML_FILE}" -s "${XML_SOURCE}" xml="${PATCHIMAGE_PATCH_DIR}/NewerSMBW-Loader.xml" -q
	${WIT} dolpatch ${DOL} xml="${PATCHIMAGE_PATCH_DIR}/NSMBW_AP.xml" -q

}
