#!/bin/bash

TMD_OPTS="--ticket-id=K --tmd-id=K"

setup_tools () {

	if [[ $(uname -m) == "x86_64" ]]; then
		WIT=tools/wit.64
	else
		WIT=tools/wit.32
	fi

}

cleanup_prebuild () {

	rm -rf ${WORKDIR}
	rm -f ./*.wbfs

}

cleanup () {

	rm  -f *.{iso,wbfs} NewerSMB.zip
	rm -rf NewerFiles nsmb.d

}

ask_game () {

echo -e \
"************************************************
patchimage.sh

Enter Letter for the Game you want to create:
A	NewerSMB
B	Newer Summer Sun
C	AnotherSMB
D	Newer: Holiday Special
"

read GAME

}

download_soundtrack () {

	if [[ ${SOUNDTRACK} ]]; then
		if [[ ${SOUNDTRACK_LINK} ]]; then
			wget "${SOUNDTRACK_LINK}" -O ${SOUNDTRACK_ZIP}
			exit 0
		else
			echo -e "no soundtrack for ${GAME} available."
			exit 1
		fi
	fi

}

check_input_image () {

	if [[ ! ${IMAGE} ]]; then
		if [[ -f BASE.wbfs ]]; then
			IMAGE=BASE.wbfs
		elif [[ -f BASE.iso ]]; then
			IMAGE=BASE.iso
		else
			echo -e "please specify image to use with --iso=<path>"
			exit 1
		fi
	fi

}

check_riivolution_patch () {

	if [[ ${DOWNLOAD} ]]; then
		wget ${DOWNLOAD_LINK} -O ${RIIVOLUTION_ZIP}
		unzip ${RIIVOLUTION_ZIP} >/dev/null
	elif [[ -f ${RIIVOLUTION_ZIP} && ! -d "${RIIVOLUTION_DIR}" ]]; then
		unzip ${RIIVOLUTION_ZIP} >/dev/null
	elif [[ ! -d "${RIIVOLUTION_DIR}" ]]; then
		echo -e "please specify zip to use with --riivolution=<path>"
		exit 1
	fi

}

optparse () {

xcount=0
pcount=$#

while [[ $xcount -lt $pcount ]]; do
	case $1 in

		--iso* )
			ISO_PATH=${1/*=}
			ISO_EXT=${ISO_PATH//*./}

			if [[ -e "${ISO_PATH}" ]]; then
				ln -sf "${ISO_PATH}" ./BASE.${ISO_EXT}
				IMAGE=BASE.${ISO_EXT}
			else
				echo -e "ISO not found"
				exit 1
			fi
		;;

		--riivolution* )
			RIIVOLUTION=${1/*=}
			if [[ -e "${RIIVOLUTION}" ]]; then
				unzip "${RIIVOLUTION}" >/dev/null
			else
				echo -e "Riivolution patch ${RIIVOLUTION} not found."
				exit 1
			fi
		;;

		--customid* )
			CUSTOMID=${1/*=}
			if [[ ${#CUSTOMID} != 6 ]]; then
				echo -e "CustomID ${CUSTOMID} needs to have 6 digits"
				exit 1
			fi
		;;

		--download )
			DOWNLOAD=TRUE
		;;

		--soundtrack )
			SOUNDTRACK=TRUE
		;;

		--version=* )
			VERSION=${1/*=}
			case ${VERSION} in
				EURv1 )
					REG_LETTER=P
				;;

				EURv2 )
					REG_LETTER=P
				;;

				USAv1 )
					REG_LETTER=E
				;;

				USAv2 )
					REG_LETTER=E
				;;

				JPNv1 )
					REG_LETTER=J
				;;

				* )
					echo -e "unrecognized game version: ${VERSION}"
					exit 1
				;;
			esac
		;;

		--sharesave )
			TMD_OPTS=""
		;;

		--game* )
			GAME=${1/*=}
		;;

		"" | --help )
			echo -e "create wbfs images from riivolution patches.\n
***** using this script is only allowed, if you own an original copy of the game.
***** if you don't, no one can be blamed but you. Shame on you.\n
--game={NewerSMB;NewerSummerSun;AnotherSMB;HolidaySpecial}
					| specify game you want to create
--iso=/home/test/<Image>.wbfs		| specify which ISO to use for building
--riivolution=/home/test/<Patch>.zip	| specify path to Riivolution files
--version=EURv1,EURv2,USAv1,USAv2,JPNv1	| specify your game version
--customdid=SMNP02			| specify a custom ID to use for the game
--sharesave				| let modified game share savegame with original game
--clean					| cleanup the build-directory
--download				| download riivolution patchfiles
--soundtrack				| download soundtrack (if available) and exit"
			exit 0
		;;
	esac
	shift
	xcount=$(($xcount+1))
done

}
