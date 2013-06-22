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

# e preserved for canon smbw

	f | F | ParallelWorlds | "The Legend of Zelda: Parallel Worlds" )
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
		download_soundtrack
		cleanup_prebuild
		check_input_image
		check_input_image_special
		check_riivolution_patch

		${WIT} extract "${IMAGE}" ${WORKDIR} --psel=DATA -vv || exit 1

		detect_game_version
		place_files

		prepare_xml
		${WIT} dolpatch ${DOL} xml="${XML_FILE}" --source "${XML_SOURCE}" -q
		dolpatch_extra

		if [[ ${CUSTOMID} ]]; then
			${WIT} cp -v -B ${WORKDIR} ${CUSTOMID}.wbfs -vv --disc-id=${CUSTOMID} ${TMD_OPTS} --name "${GAMENAME}"
		else
			${WIT} cp -v -B ${WORKDIR} ${GAMEID}.wbfs -vv --disc-id=${GAMEID} ${TMD_OPTS} --name "${GAMENAME}"
		fi
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
