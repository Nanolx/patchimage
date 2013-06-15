#!/bin/bash
#
# create wbfs image from riivolution patch
#
# Christopher Roy Bratusek <nano@tuxfamily.org>
#
# License: GPL v3

source ./script.d/common.sh

optparse "${@}"

if [[ ! ${GAME} ]]; then
	ask_game
fi

case ${GAME} in

	A | NewerSMB )
		source ./script.d/newersmb.sh
	;;

	* )
		echo -e "specified Game ${GAME} not recognized"
		exit 1
	;;

esac

cleanup_prebuild
check_input_image
check_input_image_special
check_riivolution_patch

${WIT} extract "${IMAGE}" ${WORKDIR} --psel=DATA -vv || exit 1

detect_game_version
place_files

${PPF} a ${DOL} ${PATCH}

if [[ ${CUSTOMID} ]]; then
	${WIT} cp -v -B ${WORKDIR} ./${CUSTOMID}.wbfs -vv --disc-id=${CUSTOMID} ${TMD_OPTS} --name "${GAMENAME}"
else
	${WIT} cp -v -B ${WORKDIR} ./${GAMEID}.wbfs -vv --disc-id=${GAMEID} ${TMD_OPTS} --name "${GAMENAME}"
fi
