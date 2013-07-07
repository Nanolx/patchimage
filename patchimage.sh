#!/bin/bash
#
# create wbfs image from riivolution patch
#
# Christopher Roy Bratusek <nano@tuxfamily.org>
#
# License: GPL v3

source script.d/common.sh
setup_tools

optparse "${@}"

if [[ ! ${GAME} ]]; then
	ask_game
fi

case ${GAME} in

	a | A | NewerSMB | NewerSMBW )
		source script.d/newersmb.sh
	;;

	b | B | NewerSummerSun )
		source script.d/newersummersun.sh
	;;

	c | C | ASMBW | AnotherSMBW )
		source script.d/anothersmb.sh
	;;

	d | D | HolidaySpecial | "Newer: Holiday Special" )
		source script.d/newerholiday.sh
	;;

	e | E | Cannon | "Cannon SMBW" )
		source script.d/cannon.sh
	;;

	f | F | ESBW | "Epic Super Bowser World" )
		source script.d/epicbowserworld.sh
	;;

	g | G | Koopa | "Koopa Country" )
		source script.d/koopacountry.sh
	;;

	h | H | NSMB4 | "New Super Mario Bros. 4" )
		source script.d/nsmbw4.sh
	;;

	i | I | Retro | "Retro Remix" )
		source script.d/retroremix.sh
	;;

	1 | ParallelWorlds | "The Legend of Zelda: Parallel Worlds" )
		source script.d/parallelworlds.sh
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

		${WIT} extract "${IMAGE}" ${WORKDIR} --psel=DATA -vv || exit 1

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

		if [[ -d ${PATCHIMAGE_WBFS_DIR} ]]; then
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
