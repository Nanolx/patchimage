#!/bin/bash

GAMENAME="Tokyo Mirage Sessions #FE Uncensored"
GAME_TYPE=DELTA

PATCH_FILES=( 000_map 010_character 030_etc 031_message 050_movie 999_etc_om 999_lua )

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

	echo -e "\nTokyo Mirage Sessions #FE restoration patcher"

	status=3

	if [[ ! ${XDELTA_PATH} ]]; then
		echo -e "\nEnter path to the directory containing the delta patches:\n"
		read XDELTA_PATH || exit 75
	else	status=4
	fi

	if [[ ! ${CPK_PATH} ]]; then
		echo -e "\nEnter path to the directory containing the game files (cpk):\n"
		read CPK_PATH || exit 75
	else	status=4
	fi

	if [[ ! -d ${XDELTA_PATH} ]]; then
		echo "PATH \"${XDELTA_PATH}\" does not exist!"
		exit 21
	elif [[ ! -f ${XDELTA_PATH}/patch_000_map.xdelta ]]; then
		echo "PATH \"${XDELTA_PATH}\" does not contain the xdelta patches!"
		exit 21
	elif [[ ! -d ${CPK_PATH} ]]; then
		echo "PATH \"${CPK_PATH}\" does not exist!"
		exit 15
	elif [[ ! -f ${CPK_PATH}/pack_000_map.cpk ]]; then
		echo "PATH \"${CPK_PATH}\" does not contain the game files (cpk)!"
		exit 15
	fi

	echo ">>> status: ${status}"

}

patch () {

	if [[ -d ${PWD}/TMSxFE-Uncensored ]]; then
		echo -e "\nremoving old files"
		rm -rf ${PWD}/TMSxFE-Uncensored
	fi

	echo -e "\n> copying cpk files"
	mkdir ${PWD}/TMSxFE-Uncensored
	for file in ${PATCH_FILES[@]}; do
		cp ${CPK_PATH}/pack_${file}.cpk \
			${PWD}/TMSxFE-Uncensored
	done

	cur=0
	all=${#PACH_FILES[@]}
	echo -e "\n> Patching Files"
	for patch in ${PATCH_FILES[@]}; do
		cur=$((cur+1))
		echo ">> [${cur}/${all}] pack_${patch}.cpk"
		${XD3} -d -f -s ${PWD}/TMSxFE-Uncensored/pack_${patch}.cpk \
			${XDELTA_PATH}/patch_${patch}.xdelta \
			${PWD}/TMSxFE-Uncensored/pack_${patch}.cpk_new || exit 51

		mv ${PWD}/TMSxFE-Uncensored/pack_${patch}.cpk_new \
			${PWD}/TMSxFE-Uncensored/pack_${patch}.cpk
	done

	echo -e "\n< Done patching
<< Find your modified cpk files in:
	\n\t${PWD}/TMSxFE-Uncensored

Copy your complete dump (content, code, meta folders) to your SD-Card in

	<sd-card-path>/wiiu/games/Tokyo Mirage Sessions FE [ASEP01]

then copy the modified cpk files into

	<sd-card-path>/wiiu/games/Tokyo Mirage Sessions FE [ASEP01]/content/Pack/

keep a copy of the unmodified cpk files, in case the patches are being updated!
"

}
