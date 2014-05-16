#!/bin/bash
#
# create wbfs image from riivolution patch
#
# Christopher Roy Bratusek <nano@tuxfamily.org>
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

	a | A | NewerSMB | NewerSMBW )
		source ${PATCHIMAGE_SCRIPT_DIR}/newersmb.sh
	;;

	b | B | NewerSummerSun )
		source ${PATCHIMAGE_SCRIPT_DIR}/newersummersun.sh
	;;

	c | C | ASMBW | AnotherSMBW )
		source ${PATCHIMAGE_SCRIPT_DIR}/anothersmb.sh
	;;

	d | D | HolidaySpecial | "Newer: Holiday Special" )
		source ${PATCHIMAGE_SCRIPT_DIR}/newerholiday.sh
	;;

	e | E | Cannon | "Cannon SMBW" )
		source ${PATCHIMAGE_SCRIPT_DIR}/cannon.sh
	;;

	f | F | ESBW | "Epic Super Bowser World" )
		source ${PATCHIMAGE_SCRIPT_DIR}/epicbowserworld.sh
	;;

	g | G | Koopa | "Koopa Country" )
		source ${PATCHIMAGE_SCRIPT_DIR}/koopacountry.sh
	;;

	h | H | NSMBW4 | "New Super Mario Bros. 4" )
		source ${PATCHIMAGE_SCRIPT_DIR}/nsmbw4.sh
	;;

	i | I | Retro | "Retro Remix" )
		source ${PATCHIMAGE_SCRIPT_DIR}/retroremix.sh
	;;

	j | J | WinterMoon | "Super Mario: Mushroom Adventure PLUS - Winter Moon" )
		source ${PATCHIMAGE_SCRIPT_DIR}/wintermoon.sh
	;;

	k | K | NSMBW3 | "NSMBW3: The Final Levels" )
		source ${PATCHIMAGE_SCRIPT_DIR}/nsmbw3.sh
	;;

	l | L | SMV | "Super Mario Vacation" )
		source ${PATCHIMAGE_SCRIPT_DIR}/summervacation.sh
	;;

	m | M | ASLM | "Awesomer Super Luigi Mini" )
		source ${PATCHIMAGE_SCRIPT_DIR}/awesomersuperluigi.sh
	;;

	n | N | Wiimmfi )
		source ${PATCHIMAGE_SCRIPT_DIR}/wiimmfi.sh
	;;

	o | O | Wiimmpatch )
		source ${PATCHIMAGE_SCRIPT_DIR}/wiimmfi_generic.sh
	;;

	p | P | Mkwiimm )
		source ${PATCHIMAGE_SCRIPT_DIR}/mkwiimm.sh
	;;

	r | R | Sykland )
		source ${PATCHIMAGE_SCRIPT_DIR}/skyland.sh
	;;

	s | S | Kirby )
		source ${PATCHIMAGE_SCRIPT_DIR}/kirbywii.sh
	;;

	t | T | RVLution )
		source ${PATCHIMAGE_SCRIPT_DIR}/rvlution.sh
	;;

	1 | ParallelWorlds | "The Legend of Zelda: Parallel Worlds" )
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
