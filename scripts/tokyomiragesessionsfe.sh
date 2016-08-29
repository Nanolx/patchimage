#!/bin/bash

GAMENAME="Tokyo Mirage Sessions #FE Restoration"
GAME_TYPE=DELTA

PATCH_FILES=( 000_map 010_character 030_etc 031_message 050_movie 999_etc_om 999_lua )

DOWNLOAD_LINKS=( "patch_000_map.xdelta+https://drive.google.com/uc?id=0BxykxdPQq3oZM0ViV2ZlQkFjSk0&export=download"
		 "patch_010_character.xdelta+https://drive.google.com/uc?id=0BxykxdPQq3oZSzZzNVd4ejZYalE&export=download"
		 "patch_030_etc.xdelta+https://drive.google.com/uc?id=0BxykxdPQq3oZNEZfN1hqOHVYZ0E&export=download"
		 "patch_031_message.xdelta+https://drive.google.com/uc?id=0BxykxdPQq3oZTDlRdzlkUno3ZXM&export=download"
		 "patch_050_move.xdelta+https://drive.google.com/uc?id=0BxykxdPQq3oZNU5kNlh2d1VRQzQ&export=download"
		 "patch_999_etc_om.xdelta+https://drive.google.com/uc?id=0BxykxdPQq3oZN2VxTERFY2JPUFU&export=download"
		 "patch_999_lua.xdelta+https://drive.google.com/uc?id=0BxykxdPQq3oZUERRR0w2Nnl2YUk&export=download" )

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

	status=8

	if [[ ${PATCHIMAGE_RIIVOLUTION_DOWNLOAD} != TRUE ]]; then

		if [[ ! ${XDELTA_PATH} ]]; then
			if [[ -d ${PATCHIMAGE_RIIVOLUTION_DIR}/TMSFE_Restoration ]]; then
				XDELTA_PATH=${PATCHIMAGE_RIIVOLUTION_DIR}/TMSFE_Restoration
			else
				echo -e "\nEnter path to the directory containing the delta patches:\n"
				read -er XDELTA_PATH || exit 75
			fi
		else	status=9
		fi

		if [[ ! -d ${XDELTA_PATH} ]]; then
			echo "PATH \"${XDELTA_PATH}\" does not exist!"
			exit 21
		fi

	else
		echo -e "\nDownloading required files, ~1.9 Gigabyte. This will take a while.\n"
		for delta in ${DOWNLOAD_LINKS[@]}; do
			DL_NAME=${delta/+*}
			DL_LINK=${delta/*+}
			[[ ! -d ${PATCHIMAGE_RIIVOLUTION_DIR}/TMSFE_Restoration ]] && \
				mkdir ${PATCHIMAGE_RIIVOLUTION_DIR}/TMSFE_Restoration
			if [[ ! -f ${PATCHIMAGE_RIIVOLUTION_DIR}/TMSFE_Restoration/${DL_NAME} ]]; then
				${GDOWN} "${DL_LINK}" \
					"${PATCHIMAGE_RIIVOLUTION_DIR}/TMSFE_Restoration/${DL_NAME}"__tmp || \
					( rm "${PATCHIMAGE_RIIVOLUTION_DIR}/TMSFE_Restoration/${DL_NAME}"__tmp && \
						echo -e "\nDownload failed!" && exit 57 )
				mv "${PATCHIMAGE_RIIVOLUTION_DIR}/TMSFE_Restoration/${DL_NAME}"__tmp \
					"${PATCHIMAGE_RIIVOLUTION_DIR}/TMSFE_Restoration/${DL_NAME}"
			fi

			XDELTA_PATH="${PATCHIMAGE_RIIVOLUTION_DIR}/TMSFE_Restoration"
		done
	fi

	for file in ${PATCH_FILES[@]}; do
		if [[ ! -f ${XDELTA_PATH}/patch_${file}.xdelta ]]; then
			echo "Patch file patch_${file}.xdelta does not exist!"
			exit 75
		fi
	done

	if [[ ! ${CPK_PATH} ]]; then
		echo -e "\nEnter path to the directory containing the game files (cpk):\n"
		read -er CPK_PATH || exit 75
	else	status=9
	fi

	if [[ ! -d ${CPK_PATH} ]]; then
		echo "PATH \"${CPK_PATH}\" does not exist!"
		exit 15
	fi

	[[ -f ${CPK_PATH}/pack_000_map.cpk ]] && CPK_PATH=${CPK_PATH}
	[[ -f ${CPK_PATH}/vol/content/Pack/pack_000_map.cpk ]] && CPK_PATH=${CPK_PATH}/vol/content/Pack/

	for file in ${PATCH_FILES[@]}; do
		if [[ ! -f ${CPK_PATH}/pack_${file}.cpk ]]; then
			echo "Original file pack_${file}.cpk does not exist!"
			exit 75
		fi
	done

	echo ">>> status: ${status}"

}

patch () {

	if [[ -d ${PWD}/TMSxFE-Restoration-Build ]]; then
		echo -e "\nremoving old files"
		rm -rf "${PWD}"/TMSxFE-Restoration-Build
	fi

	all=${#PATCH_FILES[@]}

	echo -e "\n> copying cpk files"
	mkdir "${PWD}"/TMSxFE-Restoration-Build

	cur=0
	for file in "${PATCH_FILES[@]}"; do
		cur=$((cur+1))
		echo ">> [${cur}/${all}] pack_${file}.cpk"
		cp "${CPK_PATH}"/pack_"${file}".cpk \
			"${PWD}"/TMSxFE-Restoration-Build
	done

	cur=0
	echo -e "\n> Patching Files"
	for patch in "${PATCH_FILES[@]}"; do
		cur=$((cur+1))
		echo ">> [${cur}/${all}] pack_${patch}.cpk"
		"${XD3}" -d -f -s "${PWD}"/TMSxFE-Restoration-Build/pack_"${patch}".cpk \
			"${XDELTA_PATH}"/patch_"${patch}".xdelta \
			"${PWD}"/TMSxFE-Restoration-Build/pack_"${patch}".cpk_new || exit 51

		mv "${PWD}"/TMSxFE-Restoration-Build/pack_"${patch}".cpk_new \
			"${PWD}"/TMSxFE-Restoration-Build/pack_"${patch}".cpk
	done

	echo -e "\n< Done patching
<< Find your modified cpk files in:
	\n\t${PWD}/TMSxFE-Restoration-Build

Copy your complete dump (content, code, meta folders) to your SD-Card in

	<sd-card-path>/wiiu/games/Tokyo Mirage Sessions FE [ASEP01]

then copy the modified cpk files into

	<sd-card-path>/wiiu/games/Tokyo Mirage Sessions FE [ASEP01]/content/Pack/

keep a copy of the unmodified cpk files, in case the patches are being updated!
"

}
