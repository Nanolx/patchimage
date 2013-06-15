#!/bin/bash

WORKDIR=./nsmb.d
DOL=${WORKDIR}/sys/main.dol
RIIVOLUTION_ZIP=NewerSMBW.zip
RIIVOLUTION_DIR=NewerFiles
GAMENAME="Newer SMB"
XML=FALSE
XML_SOURCE=./"${RIIVOLUTION_DIR}"/NewerSMBW/
XML_FILE=./"${RIIVOLUTION_DIR}"/riivolution/NewerSMBW.xml

show_notes () {

echo -e
"************************************************
NewerSMB

Source:			http://www.newerteam.com/
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

check_input_image_special () {

	if [[ ! ${IMAGE} ]]; then
		if test -f ./SMN?01.wbfs; then
			IMAGE=./SMN?01.wbfs
		elif test -f ./SMN?01.iso; then
			IMAGE=./SMN?01.iso
		else
			echo -e "please specify image to use with --iso=<path>"
			exit 1
		fi
	fi

}

detect_game_version () {

	if [[ -f ${WORKDIR}/files/COPYDATE_LAST_2009-10-03_232911 ]]; then
		VERSION=EURv1
		PATCH=./patches/NewerSMB/EURv1.ppf
		REG_LETTER=P
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2010-01-05_152101 ]]; then
		VERSION=EURv2
		PATCH=./patches/NewerSMB/EURv2.ppf
		REG_LETTER=P
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2009-10-03_232303 ]]; then
		VERSION=USAv1
		PATCH=./patches/NewerSMB/USAv1.ppf
		REG_LETTER=E
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2010-01-05_143554 ]]; then
		VERSION=USAv2
		PATCH=./patches/NewerSMB/USAv2.ppf
		REG_LETTER=E
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2009-10-03_231655 ]]; then
		VERSION=JPNv1
		PATCH=./patches/NewerSMB/JPNv1.ppf
		REG_LETTER=J
	elif [[ ! ${VERSION} ]]; then
		echo -e "please specify your games version using --version={EURv1,EURv2,USAv1,USAv2,JPNv1}"
		exit 1
	fi

	GAMEID=SMN${REG_LETTER}02

}

place_files () {

	NEW_DIRS=( nsmb.d/files/LevelSamples nsmb.d/files/NewerRes nsmb.d/files/Sound/new/sfx nsmb.d/files/Maps )
	for dir in ${NEW_DIRS[@]}; do
		mkdir -p ${dir}
	done

	case ${VERSION} in
		EUR* )
			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU NedEU )
			for dir in ${LANGDIRS[@]}; do
				cp -r ./NewerFiles/NewerSMBW/{Font,Message}/ ./nsmb.d/files/EU/${dir}/
			done
			cp ./NewerFiles/NewerSMBW/OthersP/* ./nsmb.d/files/EU/Layout/openingTitle/
		;;

		USAv* )
			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in ${LANGDIRS[@]}; do
				cp -r ./NewerFiles/NewerSMBW/{Font,Message}/ ./nsmb.d/files/US/${dir}/
			done
			cp ./NewerFiles/NewerSMBW/OthersE/* ./nsmb.d/files/US/Layout/openingTitle/
		;;

		JPNv1 )
			cp ./NewerFiles/NewerSMBW/Font/* ./nsmb.d/files/JP/Font/
			cp ./NewerFiles/NewerSMBW/Message/* ./nsmb.d/files/JP/Message/
			cp ./NewerFiles/NewerSMBW/OthersJ/* ./nsmb.d/files/JP/Layout/openingTitle/
		;;
	esac

	cp ./NewerFiles/NewerSMBW/Tilesets/* ./nsmb.d/files/Stage/Texture/
	cp ./NewerFiles/NewerSMBW/TitleReplay/* ./nsmb.d/files/Replay/title/
	cp ./NewerFiles/NewerSMBW/BGs/* ./nsmb.d/files/Object/
	cp ./NewerFiles/NewerSMBW/SpriteTex/* ./nsmb.d/files/Object/
	cp ./NewerFiles/NewerSMBW/Layouts/* ./nsmb.d/files/Layout/
	cp -r ./NewerFiles/NewerSMBW/Music/*.er ./nsmb.d/files/Sound/new/
	cp ./NewerFiles/NewerSMBW/Music/sfx/* ./nsmb.d/files/Sound/new/sfx/
	cp ./NewerFiles/NewerSMBW/Music/stream/* ./nsmb.d/files/Sound/stream/
	cp ./NewerFiles/NewerSMBW/Music/rsar/* ./nsmb.d/files/Sound/
	cp ./NewerFiles/NewerSMBW/NewerRes/* ./nsmb.d/files/NewerRes/
	cp ./NewerFiles/NewerSMBW/LevelSamples/* ./nsmb.d/files/LevelSamples/
	cp ./NewerFiles/NewerSMBW/Others/charaChangeSelectContents.arc ./nsmb.d/files/Layout/charaChangeSelectContents/charaChangeSelectContents.arc
	cp ./NewerFiles/NewerSMBW/Others/characterChange.arc ./nsmb.d/files/Layout/characterChange/characterChange.arc
	cp ./NewerFiles/NewerSMBW/Others/continue.arc ./nsmb.d/files/Layout/continue/continue.arc
	cp ./NewerFiles/NewerSMBW/Others/controllerInformation.arc ./nsmb.d/files/Layout/controllerInformation/controllerInformation.arc
	cp ./NewerFiles/NewerSMBW/Others/corseSelectMenu.arc ./nsmb.d/files/Layout/corseSelectMenu/corseSelectMenu.arc
	cp ./NewerFiles/NewerSMBW/Others/corseSelectUIGuide.arc ./nsmb.d/files/Layout/corseSelectUIGuide/corseSelectUIGuide.arc
	cp ./NewerFiles/NewerSMBW/Others/dateFile.arc ./nsmb.d/files/Layout/dateFile/dateFile.arc
	cp ./NewerFiles/NewerSMBW/Others/dateFile_OLD.arc ./nsmb.d/files/Layout/dateFile/dateFile_OLD.arc
	cp ./NewerFiles/NewerSMBW/Others/easyPairing.arc ./nsmb.d/files/Layout/easyPairing/easyPairing.arc
	cp ./NewerFiles/NewerSMBW/Others/extensionControllerNunchuk.arc ./nsmb.d/files/Layout/extensionControllerNunchuk/extensionControllerNunchuk.arc
	cp ./NewerFiles/NewerSMBW/Others/extensionControllerYokomochi.arc ./nsmb.d/files/Layout/extensionControllerYokomochi/extensionControllerYokomochi.arc
	cp ./NewerFiles/NewerSMBW/Others/fileSelectBase.arc ./nsmb.d/files/Layout/fileSelectBase/fileSelectBase.arc
	cp ./NewerFiles/NewerSMBW/Others/fileSelectBase_OLD.arc ./nsmb.d/files/Layout/fileSelectBase/fileSelectBase_OLD.arc
	cp ./NewerFiles/NewerSMBW/Others/fileSelectPlayer.arc ./nsmb.d/files/Layout/fileSelectPlayer/fileSelectPlayer.arc
	cp ./NewerFiles/NewerSMBW/Others/gameScene.arc ./nsmb.d/files/Layout/gameScene/gameScene.arc
	cp ./NewerFiles/NewerSMBW/Others/infoWindow.arc ./nsmb.d/files/Layout/infoWindow/infoWindow.arc
	cp ./NewerFiles/NewerSMBW/Others/miniGameCannon.arc ./nsmb.d/files/Layout/miniGameCannon/miniGameCannon.arc
	cp ./NewerFiles/NewerSMBW/Others/miniGameWire.arc ./nsmb.d/files/Layout/miniGameWire/miniGameWire.arc
	cp ./NewerFiles/NewerSMBW/Others/pauseMenu.arc ./nsmb.d/files/Layout/pauseMenu/pauseMenu.arc
	cp ./NewerFiles/NewerSMBW/Others/pointResultDateFile.arc ./nsmb.d/files/Layout/pointResultDateFile/pointResultDateFile.arc
	cp ./NewerFiles/NewerSMBW/Others/pointResultDateFileFree.arc ./nsmb.d/files/Layout/pointResultDateFileFree/pointResultDateFileFree.arc
	cp ./NewerFiles/NewerSMBW/Others/preGame.arc ./nsmb.d/files/Layout/preGame/preGame.arc
	cp ./NewerFiles/NewerSMBW/Others/select_cursor.arc ./nsmb.d/files/Layout/select_cursor/select_cursor.arc
	cp ./NewerFiles/NewerSMBW/Others/sequenceBG.arc ./nsmb.d/files/Layout/sequenceBG/sequenceBG.arc
	cp ./NewerFiles/NewerSMBW/Others/staffCredit.arc ./nsmb.d/files/Layout/staffCredit/staffCredit.arc
	cp ./NewerFiles/NewerSMBW/Others/stockItem.arc ./nsmb.d/files/Layout/stockItem/stockItem.arc
	cp ./NewerFiles/NewerSMBW/Others/stockItemShadow.arc ./nsmb.d/files/Layout/stockItemShadow/stockItemShadow.arc
	cp ./NewerFiles/NewerSMBW/Others/yesnoWindow.arc ./nsmb.d/files/Layout/yesnoWindow/yesnoWindow.arc
	cp -r ./NewerFiles/NewerSMBW/Maps/* ./nsmb.d/files/Maps/
	cp ./NewerFiles/NewerSMBW/Stages/* ./nsmb.d/files/Stage/

}
