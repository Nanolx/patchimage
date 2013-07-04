#!/bin/bash

TMD_OPTS="--tt-id=K"
TMP_FILES=(Another nsmb.d XmasNewer NewerFiles "Newer Summer Sun" \
ZPW_1.1.ips Epic_Super_Bowser_World_v1.00 \
Koopa riivolution "Readme*" "*.txt" )

setup_tools () {

	if [[ $(uname -m) == "x86_64" ]]; then
		WIT=tools/wit.64
		PPF=tools/applyppf3.64
		IPS=tools/uips.64
	else
		WIT=tools/wit.32
		PPF=tools/applyppf3.32
		IPS=tools/uips.32
	fi

}

cleanup () {

	rm -rf ${TMP_FILES[@]} *.wbfs *.bnr

}

ask_game () {

# ####
# E: preserved for Canon SMBW
# ###

echo -e \
"************************************************
patchimage.sh

Enter Letter for the Game you want to create:
A	NewerSMB
B	Newer Summer Sun
C	AnotherSMB
D	Newer: Holiday Special
E	Cannon Super Mario Bros.
F	Epic Super Bowser World
G	Koopa Country

 1	The Legend of Zelda: Parallel Worlds
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

download_banner () {

	if [[ ${DL_BANNER} == "TRUE" ]]; then
		if [[ ${CUSTOM_BANNER} ]]; then
			wget "${CUSTOM_BANNER}" -O ${GAMEID}-custom-banner.bnr
			BANNER=${GAMEID}-custom-banner.bnr
		else
			echo "no custom banner for ${GAMENAME} available, not modifying"
		fi
	fi

}

apply_banner () {

	if [[ ${BANNER} != "" ]]; then
		if [[ -e ${BANNER} ]]; then
			cp "${BANNER}" "${BANNER_LOCATION}"
		else
			echo "specified banner ${BANNER} does not exist, not modifying"
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
		if [[ ${DOWNLOAD_LINK} ]]; then
			if [[ ! -f ${RIIVOLUTION_ZIP} ]]; then
				wget ${DOWNLOAD_LINK} -O ${RIIVOLUTION_ZIP}
				unzip ${RIIVOLUTION_ZIP} >/dev/null
			fi
		else
			echo "no download link for ${GAMENAME} available."
			exit 1
		fi
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
				ln -sf "${ISO_PATH}" BASE.${ISO_EXT}
				IMAGE=BASE.${ISO_EXT}
			else
				echo -e "ISO not found"
				exit 1
			fi
		;;

		--rom* )
			ROM_PATH=${1/*=}
			ROM_EXT=${ROM_PATH//*./}

			if [[ -e "${ROM_PATH}" ]]; then
				ln -sf "${ROM_PATH}" BASE.${ROM_EXT}
				IMAGE=BASE.${ROM_EXT}
			else
				echo -e "ROM not found"
				exit 1
			fi
		;;

		--riivolution* )
			RIIVOLUTION=${1/*=}
			if [[ -e "${RIIVOLUTION}" ]]; then
				if [[ "${RIIVOLUTION}" == *.zip ]]; then
					unzip "${RIIVOLUTION}" >/dev/null
				elif [[ "${RIIVOLUTION}" == *.rar ]]; then
					unrar e "${RIIVOLUTION}" >/dev/null
				fi
			else
				echo -e "Riivolution patch ${RIIVOLUTION} not found."
				exit 1
			fi
		;;

		--patch*  )
			PATCH=${1/*=}
			if [[ -e "${PATCH}" ]]; then
				if [[ "${PATCH}" == *.zip ]]; then
					unzip "${PATCH}" >/dev/null
				elif [[ "${PATCH}" == *.rar ]]; then
					unrar x "${PATCH}" >/dev/null
				fi
			else
				echo -e "PATCH patch ${PATCH} not found."
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

		--clean )
			cleanup
			exit $?
		;;

		--banner=* )
			BANNER=${1/*=}
			BANNER_EXT=${BANNER//*./}
			if [[ ${BANNER_EXT} != "bnr" ]]; then
				echo "given banner (${BANNER}) is not a .bnr file!"
				exit 1
			fi
		;;

		--download-banner )
			DL_BANNER=TRUE
		;;

		"" | --help )
			echo -e "create wbfs images from riivolution patches.\n
***** using this script is only allowed, if you own an original copy of the game.
***** if you don't, no one can be blamed but you. Shame on you.\n
--game={NewerSMB;NewerSummerSun;AnotherSMB;HolidaySpecial;ParallelWorlds}
					| specify game you want to create
--iso/--rom=/home/test/<Image>		| specify which ISO/ROM to use for building
--riivolution/--patch=<Patch>		| specify path to Riivolution/Patch files
--version=EURv1,EURv2,USAv1,USAv2,JPNv1	| specify your game version
--customdid=SMNP02			| specify a custom ID to use for the game
--sharesave				| let modified game share savegame with original game
--clean					| cleanup the build-directory
--download				| download riivolution patchfiles
--soundtrack				| download soundtrack (if available) and exit
--banner=<banner.bnr>			| use a custom banner (riivolution games)
--download-banner			| download a custom banner (if available)"
			exit 0
		;;
	esac
	shift
	xcount=$(($xcount+1))
done

}
