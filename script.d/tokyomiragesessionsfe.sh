#!/bin/bash

GAMENAME="Tokyo Mirage Sessions #FE Uncensored"
GAME_TYPE=DELTA

PATCH_FILES=( 000_map 010_character 030_etc 031_message 050_movie 999_lua )

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Source:			https://gbatemp.net/threads/tokyo-mirage-sessions-fe-restoration.429651/
Base Image:		Tokyo Mirage Sessions #FE
Supported Versions:	EUR, US
************************************************"

}

menu () {

	echo -e "\nTokyo Mirage Sessions #FE restoration patcher\n"

	if [[ ! ${XDELTA_PATH} ]]; then
		echo -e "Enter path to the directory containing the delta patches:\n"
		read XDELTA_PATH
	fi

	if [[ ! ${CPK_PATH} ]]; then
		echo -e "\nEnter path to the directory containing the game files (cpk):\n"
		read CPK_PATH
	fi

	if [[ ! -d ${XDELTA_PATH} ]]; then
		echo "PATH \"${XDELTA_PATH}\" does not exist!"
		exit 1
	elif [[ ! -f ${XDELTA_PATH}/patch_000_map.xdelta ]]; then
		echo "PATH \"${XDELTA_PATH}\" does not contain the xdelta patches!"
		exit 1
	elif [[ ! -d ${CPK_PATH} ]]; then
		echo "PATH \"${CPK_PATH}\" does not exist!"
		exit 1
	elif [[ ! -f ${CPK_PATH}/pack_000_map.cpk ]]; then
		echo "PATH \"${CPK_PATH}\" does not contain the game files (cpk)!"
		exit 1
	fi

}

patch () {

	echo -e "\n> Patching Files"
	for patch in ${PATCH_FILES[@]}; do
		echo ">> pack_${patch}.cpk"
		${XD3} -d -f -s ${CPK_PATH}/pack_${patch}.cpk \
			${XDELTA_PATH}/patch_${patch}.xdelta \
			${CPK_PATH}/pack_${patch}.cpk_new || exit 1

		mv ${CPK_PATH}/pack_${patch}.cpk_new \
			${CPK_PATH}/pack_${patch}.cpk
	done

	echo -e "\n< Done!\n"

}
