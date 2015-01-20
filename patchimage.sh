#!/bin/bash
#
# create wbfs image from riivolution patch
#
# Christopher Roy Bratusek <nano@jpberlin.de>
#
# License: GPL v3

if [[ -d ${PWD}/script.d ]]; then
	PATCHIMAGE_SCRIPT_DIR=${PWD}/script.d
	PATCHIMAGE_PATCH_DIR=${PWD}/patches
	PATCHIMAGE_TOOLS_DIR=${PWD}/tools
else
	PATCHIMAGE_SCRIPT_DIR=/usr/share/patchimage/script.d
	PATCHIMAGE_PATCH_DIR=/usr/share/patchimage/patches
	PATCHIMAGE_TOOLS_DIR=/usr/share/patchimage/tools
fi

PATCHIMAGE_RIIVOLUTION_DIR=${PWD}
PATCHIMAGE_WBFS_DIR=${PWD}
PATCHIMAGE_AUDIO_DIR=${PWD}
PATCHIMAGE_GAME_DIR=${PWD}
PATCHIMAGE_COVER_DIR=${PWD}

if [[ -e $HOME/.patchimage.rc ]]; then
	source $HOME/.patchimage.rc
fi

source ${PATCHIMAGE_SCRIPT_DIR}/common.sh
check_directories

setup_tools

optparse "${@}"

if [[ ! ${GAME} ]]; then
	ask_game
fi

case ${GAME} in

	NSMB1 | NewerSMB | NewerSMBW )
		source ${PATCHIMAGE_SCRIPT_DIR}/newersmb.sh
	;;

	NSMB2 | NewerSummerSun )
		source ${PATCHIMAGE_SCRIPT_DIR}/newersummersun.sh
	;;

	NSMB3 | ASMBW | AnotherSMBW )
		source ${PATCHIMAGE_SCRIPT_DIR}/anothersmb.sh
	;;

	NSMB4 | HolidaySpecial | "Newer: Holiday Special" )
		source ${PATCHIMAGE_SCRIPT_DIR}/newerholiday.sh
	;;

	NSMB5 | Cannon | "Cannon SMBW" )
		source ${PATCHIMAGE_SCRIPT_DIR}/cannon.sh
	;;

	NSMB6 | ESBW | "Epic Super Bowser World" )
		source ${PATCHIMAGE_SCRIPT_DIR}/epicbowserworld.sh
	;;

	NSMB7 | Koopa | "Koopa Country" )
		source ${PATCHIMAGE_SCRIPT_DIR}/koopacountry.sh
	;;

	NSMB8 | "New Super Mario Bros. 4" )
		source ${PATCHIMAGE_SCRIPT_DIR}/nsmbw4.sh
	;;

	NSMB9 | Retro | "Retro Remix" )
		source ${PATCHIMAGE_SCRIPT_DIR}/retroremix.sh
	;;

	NSMB10 | WinterMoon | "Super Mario: Mushroom Adventure PLUS - Winter Moon" )
		source ${PATCHIMAGE_SCRIPT_DIR}/wintermoon.sh
	;;

	NSMB11 | NSMBW3 | "NSMBW3: The Final Levels" )
		source ${PATCHIMAGE_SCRIPT_DIR}/nsmbw3.sh
	;;

	NSMB12 | SMV | "Super Mario Vacation" )
		source ${PATCHIMAGE_SCRIPT_DIR}/summervacation.sh
	;;

	NSMB13 | ASLM | "Awesomer Super Luigi Mini" )
		source ${PATCHIMAGE_SCRIPT_DIR}/awesomersuperluigi.sh
	;;

	NSMB14 | Sykland )
		source ${PATCHIMAGE_SCRIPT_DIR}/skyland.sh
	;;

	NSMB15 | RVLution )
		source ${PATCHIMAGE_SCRIPT_DIR}/rvlution.sh
	;;

	NSMB16 | Midi )
		source ${PATCHIMAGE_SCRIPT_DIR}/midissupermariowii.sh
	;;

	NSMB17 | DarkUmbra )
		source ${PATCHIMAGE_SCRIPT_DIR}/darkumbrasmb.sh
	;;

	NSMB18 | NewerApocalypse )
		source ${PATCHIMAGE_SCRIPT_DIR}/newerapocalypse.sh
	;;

	NSMB19 | LuigisSuperYoshiBros )
		source ${PATCHIMAGE_SCRIPT_DIR}/luigissuperyoshibros.sh
	;;

	MKW1 | Wiimmfi )
		source ${PATCHIMAGE_SCRIPT_DIR}/wiimmfi.sh
	;;

	MKW2 | Wiimmpatch )
		source ${PATCHIMAGE_SCRIPT_DIR}/wiimmfi_generic.sh
	;;

	MKW3 | Mkwiimm )
		source ${PATCHIMAGE_SCRIPT_DIR}/mkwiimm.sh
	;;

	MKW4 | MkwiimmItems )
		source ${PATCHIMAGE_SCRIPT_DIR}/mkwiimm_items.sh
	;;

	MKW5 | MkwiimmFonts )
		source ${PATCHIMAGE_SCRIPT_DIR}/mkwiimm_fonts.sh
	;;

	KAW1 | Kirby )
		source ${PATCHIMAGE_SCRIPT_DIR}/kirbywii.sh
	;;

	ZEL1 | ParallelWorlds | "The Legend of Zelda: Parallel Worlds" )
		source ${PATCHIMAGE_SCRIPT_DIR}/parallelworlds.sh
	;;

	* )
		echo -e "specified Game ${GAME} not recognized"
		exit 9
	;;

esac

case ${GAME_TYPE} in
	"RIIVOLUTION" )
		show_notes
		rm -rf ${WORKDIR}
		if [[ ${PATCHIMAGE_SOUNDTRACK_DOWNLOAD} == TRUE ]]; then
			echo -e "\n*** A) download_soundtrack"
			download_soundtrack
			if [[ ${ONLY_SOUNDTRACK} == TRUE ]]; then
				exit 0
			fi
		fi

		echo -e "\n*** 1) check_input_image"
		check_input_image
		echo "*** 2) check_input_image_special"
		check_input_image_special
		echo "*** 3) check_riivolution_patch"
		check_riivolution_patch

		echo "*** 4) extract game"
		${WIT} extract ${IMAGE} ${WORKDIR} --psel=DATA -q || exit 51

		echo "*** 5) detect_game_version"
		detect_game_version
		rm -f ${GAMEID}.wbfs ${CUSTOMID}.wbfs
		echo "*** 6) place_files"
		place_files || exit 45

		echo "*** 7) download_banner"
		download_banner
		echo "*** 8) apply_banner"
		apply_banner

		echo "*** 9) dolpatch"
		dolpatch

		if [[ ${CUSTOMID} ]]; then
			GAMEID=${CUSTOMID}
		fi

		if [[ ${PATCHIMAGE_SHARE_SAVE} == "TRUE" ]]; then
			TMD_OPTS=""
		else
			TMD_OPTS="--tt-id=K"
		fi

		echo "*** 10) rebuild and store game"
		${WIT} cp -o -q --disc-id=${GAMEID} ${TMD_OPTS} --name "${GAMENAME}" \
			-B ${WORKDIR} "${PATCHIMAGE_GAME_DIR}"/${GAMEID}.wbfs || exit 51

		echo "*** 12) remove workdir"
		rm -rf ${WORKDIR}

		echo -e "\n >>> ${GAMENAME} saved as: ${PATCHIMAGE_GAME_DIR}/${GAMEID}.wbfs\n"

		if [[ ${PATCHIMAGE_COVER_DOWNLOAD} == TRUE ]]; then
			echo -e "\n*** Z) download_covers"
			download_covers ${GAMEID}
		fi

	;;

	"MKWIIMM")
		show_notes

		echo -e "\n*** 1) check_input_image"
		check_input_image
		echo -e "\n*** 2) check_input_image_special"
		check_input_image_special
		echo -e "\n*** 3) download_wiimm"
		download_wiimm
		echo -e "\n*** 4) patch_wiimm"
		patch_wiimm
	;;

	"WII_GENERIC")
		show_notes

		echo -e "\n*** 1) check_input_image"
		check_input_image
		echo -e "\n*** 2) pi_action"
		pi_action
	;;

	"IPS" )
		show_notes
		check_input_rom

		if [[ -f ${PATCH} ]]; then
			ext=${ROM/*.}
			cp "${ROM}" "${GAMENAME}.${ext}"
			${IPS} a "${PATCH}" "${GAMENAME}.${ext}" || exit 51
		else
			echo -e "error: patch (${PATCH}) could not be found"
		fi
	;;

esac
