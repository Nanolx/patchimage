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

source ${PATCHIMAGE_SCRIPT_DIR}/common.sh
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

	1 | ParallelWorlds | "The Legend of Zelda: Parallel Worlds" )
		source ${PATCHIMAGE_SCRIPT_DIR}/parallelworlds.sh
	;;

	* )
		echo -e "specified Game ${GAME} not recognized"
		exit 1
	;;

esac

case ${GAME_TYPE} in
	"RIIVOLUTION" )
		show_notes
		rm -rf ${WORKDIR}
		download_soundtrack
		check_input_image
		check_input_image_special
		check_riivolution_patch

		${WIT} extract ${IMAGE} ${WORKDIR} --psel=DATA -vv || exit 1

		detect_game_version
		rm -f ${GAMEID}.wbfs ${CUSTOMID}.wbfs
		place_files

		download_banner
		apply_banner

		dolpatch

		if [[ ${CUSTOMID} ]]; then
			GAMEID = ${CUSTOMID}
		fi

		if [[ ${PATCHIMAGE_SHARE_SAVE} == "TRUE" ]]; then
			TMD_OPTS=""
		else
			TMD_OPTS="--tt-id=K"
		fi

		${WIT} cp -v -B ${WORKDIR} ${GAMEID}.wbfs -vv --disc-id=${GAMEID} ${TMD_OPTS} --name "${GAMENAME}" || exit 1

		if [[ -d ${PATCHIMAGE_WBFS_DIR} && ${PATCHIMAGE_WBFS_DIR} != . ]]; then
			mv ${GAMEID}.wbfs "${PATCHIMAGE_WBFS_DIR}"/
		fi

		echo -e "\n >>> ${GAMENAME} saved as:\n >>> ${PATCHIMAGE_WBFS_DIR}/${GAMEID}.wbfs"

	;;

	"IPS" )
		show_notes
		check_input_rom

		if [[ -f ${PATCH} ]]; then
			ext=${ROM/*.}
			cp "${ROM}" "${GAMENAME}.${ext}"
			${IPS} a "${PATCH}" "${GAMENAME}.${ext}"
		else
			echo -e "error: patch (${PATCH}) could not be found"
		fi
	;;
esac
