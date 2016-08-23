#!/bin/bash

GAME_TYPE="GENERIC"
GAMENAME="New Super Mario Bros. Wii"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Custom New Super Mario Bros. Wii

Source:			Various
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EUR, JAP, USA
************************************************"

}

check_input_image_special () {

	ask_input_image_nsmb

	echo -e "type ??????.wbfs or ??????.iso:\n"
	read -er ID

	if [[ -f ${PWD}/${ID} ]]; then
		GAMEDIR="${PWD}"
	elif [[ -f ${PATCHIMAGE_WBFS_DIR}/${ID} ]]; then
		GAMEDIR="${PATCHIMAGE_WBFS_DIR}"
	else	echo "invalid user input."
		exit 75
	fi

}

pi_action () {

	if [[ -f ${HOME}/.patchimage.choice ]]; then
		echo "Your choices from last time can be re-used."
		echo "y (yes) or n (no)"
		read -er choice

		[[ ${choice} == y ]] && source "${HOME}"/.patchimage.choice
	fi

	if [[ ${choosenplayers[@]} == "" ]]; then
		echo -e "Choose a Player to add to the game\n"
		gawk -F : '{print $1 "\t\t" $2 "\t\t" $3}' < "${PATCHIMAGE_DATABASE_DIR}"/nsmbw_characters.db
		echo -e "\ntype ???.arc (only one per slot (second column) possible, space separated)
or type 'restore' to only restore original characters.
"
		read -er PLAYERS
	fi

	rm -rf workdir

	echo -e "\n*** 3) extracting image"
	"${WIT}" extract "${GAMEDIR}"/"${ID}" --psel=data -d workdir -q || exit 51

	if [[ ${PLAYERS[@]} == *restore* ]]; then
		for backup in Mario.arc Luigi.arc Kinopio.arc koopa.arc; do
			echo "*** 4) restoring original: ${backup}"
			cp "${PATCHIMAGE_RIIVOLUTION_DIR}"/"${backup}" workdir/files/Object/
		done

		echo "*** 5) rebuilding game"
		echo "       (storing game in ${PATCHIMAGE_GAME_DIR}/${ID})"
		"${WIT}" cp -o -q -B workdir "${PATCHIMAGE_GAME_DIR}"/"${ID}" || exit 51
	else
		for player in "${PLAYERS[@]}"; do
			if [[ ! -f "${PATCHIMAGE_DATA_DIR}"/nsmbw_characters/${player} ]]; then
				echo "unkown character ${player}"
				exit 75
			fi
			slot=$(gawk -F : "/^${player}/"'{print $2}' "${PATCHIMAGE_DATABASE_DIR}"/nsmbw_characters.db)
			choosenplayers=( ${choosenplayers[@]} ${player}:${slot} )
		done

		echo "${choosenplayers[@]}"
		echo "choosenplayers=( ${choosenplayers[*]} )" > "${HOME}"/.patchimage.choice

		for backup in Mario.arc Luigi.arc Kinopio.arc koopa.arc; do
			if [[ ! -f "${PATCHIMAGE_RIIVOLUTION_DIR}/${backup}" ]]; then
				echo "*** 4) first run, backing up original: ${backup}"
				cp workdir/files/Object/"${backup}" "${PATCHIMAGE_RIIVOLUTION_DIR}"
			else
				echo "*** 4) restoring original: ${backup}"
				cp "${PATCHIMAGE_RIIVOLUTION_DIR}"/"${backup}" workdir/files/Object/
			fi
		done

		echo "*** 5) replacing characters"
		for player in "${choosenplayers[@]}"; do
			cp "${PATCHIMAGE_DATA_DIR}"/nsmbw_characters/"${player/:*}" \
				workdir/files/Object/"${player/*:}"
		done

		echo "*** 6) rebuilding game"
		echo "       (storing game in ${PATCHIMAGE_GAME_DIR}/${ID})"
		"${WIT}" cp -o -q -B workdir "${PATCHIMAGE_GAME_DIR}"/"${ID}" || exit 51
	fi

	rm -rf workdir
}
