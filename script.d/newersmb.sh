#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="http://newerteam.com/getNewerFile.php"
SOUNDTRACK_LINK="http://dirbaio.net/newer/NewerSoundtrack.zip"
SOUNDTRACK_ZIP="NewerSoundtrack.zip"
RIIVOLUTION_ZIP="NewerSMBW.zip"
RIIVOLUTION_DIR="NewerFiles"
GAMENAME="Newer SMB"
XML_SOURCE="${RIIVOLUTION_DIR}"/NewerSMBW/
XML_FILE="${RIIVOLUTION_DIR}"/riivolution/NewerSMBW.xml
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr

}

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Newer is a full unofficial sequel to New Super Mario Bros. Wii, crafted
over the span of 3 years by a team of devoted Nintendo fans. Playable
legally on any homebrew-enabled Wii; no piracy or hardware mods needed.

Source:			http://www.newerteam.com/
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

check_input_image_special () {

	if [[ ! ${IMAGE} ]]; then
		if test -f SMN?01.wbfs; then
			IMAGE=SMN?01.wbfs
		elif test -f SMN?01.iso; then
			IMAGE=SMN?01.iso
		else
			echo -e "please specify image to use with --iso=<path>"
			exit 1
		fi
	fi

}

detect_game_version () {

	if [[ -f ${WORKDIR}/files/COPYDATE_LAST_2009-10-03_232911 ]]; then
		VERSION=EURv1
		REG_LETTER=P
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2010-01-05_152101 ]]; then
		VERSION=EURv2
		REG_LETTER=P
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2009-10-03_232303 ]]; then
		VERSION=USAv1
		REG_LETTER=E
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2010-01-05_143554 ]]; then
		VERSION=USAv2
		REG_LETTER=E
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2009-10-03_231655 ]]; then
		VERSION=JPNv1
		REG_LETTER=J
	elif [[ ! ${VERSION} ]]; then
		echo -e "please specify your games version using --version={EURv1,EURv2,USAv1,USAv2,JPNv1}"
		exit 1
	fi

	GAMEID=SMN${REG_LETTER}03
	CUSTOM_BANNER=http://dl.dropboxusercontent.com/u/101209384/${GAMEID}.bnr

}

place_files () {

	NEW_DIRS=( ${WORKDIR}/files/LevelSamples ${WORKDIR}/files/NewerRes ${WORKDIR}/files/Sound/new/sfx ${WORKDIR}/files/Maps )
	for dir in ${NEW_DIRS[@]}; do
		mkdir -p ${dir}
	done

	case ${VERSION} in
		EUR* )
			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU NedEU )
			for dir in ${LANGDIRS[@]}; do
				cp -r "${RIIVOLUTION_DIR}"/NewerSMBW/{Font,Message}/ ${WORKDIR}/files/EU/${dir}/
			done
			cp "${RIIVOLUTION_DIR}"/NewerSMBW/OthersP/* ${WORKDIR}/files/EU/Layout/openingTitle/
		;;

		USAv* )
			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in ${LANGDIRS[@]}; do
				cp -r "${RIIVOLUTION_DIR}"/NewerSMBW/{Font,Message}/ ${WORKDIR}/files/US/${dir}/
			done
			cp "${RIIVOLUTION_DIR}"/NewerSMBW/OthersE/* ${WORKDIR}/files/US/Layout/openingTitle/
		;;

		JPNv1 )
			cp "${RIIVOLUTION_DIR}"/NewerSMBW/Font/* ${WORKDIR}/files/JP/Font/
			cp "${RIIVOLUTION_DIR}"/NewerSMBW/Message/* ${WORKDIR}/files/JP/Message/
			cp "${RIIVOLUTION_DIR}"/NewerSMBW/OthersJ/* ${WORKDIR}/files/JP/Layout/openingTitle/
		;;
	esac

	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Tilesets/* ${WORKDIR}/files/Stage/Texture/
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/TitleReplay/* ${WORKDIR}/files/Replay/title/
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/BGs/* ${WORKDIR}/files/Object/
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/SpriteTex/* ${WORKDIR}/files/Object/
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Layouts/* ${WORKDIR}/files/Layout/
	cp -r "${RIIVOLUTION_DIR}"/NewerSMBW/Music/*.er ${WORKDIR}/files/Sound/new/
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Music/sfx/* ${WORKDIR}/files/Sound/new/sfx/
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Music/stream/* ${WORKDIR}/files/Sound/stream/
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Music/rsar/* ${WORKDIR}/files/Sound/
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/NewerRes/* ${WORKDIR}/files/NewerRes/
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/LevelSamples/* ${WORKDIR}/files/LevelSamples/
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/charaChangeSelectContents.arc ${WORKDIR}/files/Layout/charaChangeSelectContents/charaChangeSelectContents.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/characterChange.arc ${WORKDIR}/files/Layout/characterChange/characterChange.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/continue.arc ${WORKDIR}/files/Layout/continue/continue.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/controllerInformation.arc ${WORKDIR}/files/Layout/controllerInformation/controllerInformation.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/corseSelectMenu.arc ${WORKDIR}/files/Layout/corseSelectMenu/corseSelectMenu.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/corseSelectUIGuide.arc ${WORKDIR}/files/Layout/corseSelectUIGuide/corseSelectUIGuide.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/dateFile.arc ${WORKDIR}/files/Layout/dateFile/dateFile.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/dateFile_OLD.arc ${WORKDIR}/files/Layout/dateFile/dateFile_OLD.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/easyPairing.arc ${WORKDIR}/files/Layout/easyPairing/easyPairing.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/extensionControllerNunchuk.arc ${WORKDIR}/files/Layout/extensionControllerNunchuk/extensionControllerNunchuk.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/extensionControllerYokomochi.arc ${WORKDIR}/files/Layout/extensionControllerYokomochi/extensionControllerYokomochi.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/fileSelectBase.arc ${WORKDIR}/files/Layout/fileSelectBase/fileSelectBase.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/fileSelectBase_OLD.arc ${WORKDIR}/files/Layout/fileSelectBase/fileSelectBase_OLD.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/fileSelectPlayer.arc ${WORKDIR}/files/Layout/fileSelectPlayer/fileSelectPlayer.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/gameScene.arc ${WORKDIR}/files/Layout/gameScene/gameScene.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/infoWindow.arc ${WORKDIR}/files/Layout/infoWindow/infoWindow.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/miniGameCannon.arc ${WORKDIR}/files/Layout/miniGameCannon/miniGameCannon.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/miniGameWire.arc ${WORKDIR}/files/Layout/miniGameWire/miniGameWire.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/pauseMenu.arc ${WORKDIR}/files/Layout/pauseMenu/pauseMenu.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/pointResultDateFile.arc ${WORKDIR}/files/Layout/pointResultDateFile/pointResultDateFile.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/pointResultDateFileFree.arc ${WORKDIR}/files/Layout/pointResultDateFileFree/pointResultDateFileFree.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/preGame.arc ${WORKDIR}/files/Layout/preGame/preGame.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/select_cursor.arc ${WORKDIR}/files/Layout/select_cursor/select_cursor.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/sequenceBG.arc ${WORKDIR}/files/Layout/sequenceBG/sequenceBG.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/staffCredit.arc ${WORKDIR}/files/Layout/staffCredit/staffCredit.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/stockItem.arc ${WORKDIR}/files/Layout/stockItem/stockItem.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/stockItemShadow.arc ${WORKDIR}/files/Layout/stockItemShadow/stockItemShadow.arc
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Others/yesnoWindow.arc ${WORKDIR}/files/Layout/yesnoWindow/yesnoWindow.arc
	cp -r "${RIIVOLUTION_DIR}"/NewerSMBW/Maps/* ${WORKDIR}/files/Maps/
	cp "${RIIVOLUTION_DIR}"/NewerSMBW/Stages/* ${WORKDIR}/files/Stage/

}

prepare_xml () {

	cp "${XML_FILE}" "${XML_FILE}".new
	sed -e 's/80001800/803482C0/g' -i "${XML_FILE}".new
	XML_FILE="${XML_FILE}".new

}

dolpatch_extra () {

	${WIT} dolpatch ${DOL} xml="patches/NewerSMBW-Loader.xml" -q
	${WIT} dolpatch ${DOL} xml="patches/NSMBW_AP.xml" -q

}
