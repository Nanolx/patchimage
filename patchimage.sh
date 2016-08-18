#!/bin/bash
#
# create wbfs image from riivolution patch
#
# Christopher Roy Bratusek <nano@jpberlin.de>
#
# License: GPL v3

basedir=$(readlink -m "${BASH_SOURCE[0]}")
basedir=$(dirname "${basedir}")

export PATCHIMAGE_DIR=${basedir}

if [[ -d ${basedir}/scripts ]]; then
	export PATCHIMAGE_SCRIPT_DIR=${basedir}/scripts
	export PATCHIMAGE_PATCH_DIR=${basedir}/patches
	export PATCHIMAGE_DATA_DIR=${basedir}/data
	export PATCHIMAGE_TOOLS_DIR=${basedir}/tools
	export PATCHIMAGE_OVERRIDE_DIR=${basedir}/override
	export PATCHIMAGE_DATABASE_DIR=${basedir}/database
else
	export PATCHIMAGE_SCRIPT_DIR=/usr/share/patchimage/scripts
	export PATCHIMAGE_PATCH_DIR=/usr/share/patchimage/patches
	export PATCHIMAGE_DATA_DIR=/usr/share/patchimage/data
	if [[ $(uname -m) == "x86_64" ]]; then
		export PATCHIMAGE_TOOLS_DIR=/usr/lib/x86_64-linux-gnu/patchimage/tools
		export PATCHIMAGE_OVERRIDE_DIR=/usr/lib/x86_64-linux-gnu/patchimage/override
	else
		export PATCHIMAGE_TOOLS_DIR=/usr/lib/i386-linux-gnu/patchimage/tools
		export PATCHIMAGE_OVERRIDE_DIR=/usr/lib/i386-linux-gnu/patchimage/override
	fi
	export PATCHIMAGE_DATABASE_DIR=/usr/share/patchimage/database
fi

export PATCHIMAGE_RIIVOLUTION_DIR="${basedir}"
export PATCHIMAGE_WBFS_DIR="${basedir}"
export PATCHIMAGE_AUDIO_DIR="${basedir}"
export PATCHIMAGE_GAME_DIR="${basedir}"
export PATCHIMAGE_COVER_DIR="${basedir}"

source "${PATCHIMAGE_SCRIPT_DIR}/common.sh"
source "${PATCHIMAGE_SCRIPT_DIR}/messages.sh"
optparse "${@}"

check_directories
setup_tools

patchimage_riivolution () {

	show_notes
	rm -rf "${WORKDIR}"
	if [[ ${PATCHIMAGE_SOUNDTRACK_DOWNLOAD} == TRUE ]]; then
		echo -e "\n*** A) download_soundtrack"
		download_soundtrack
		if [[ ${ONLY_SOUNDTRACK} == TRUE ]]; then
			exit 0
		fi
	fi

	echo -e "\n*** 1) check_input_image"
	check_input_image
	echo "*** 2) check_riivolution_patch"
	check_riivolution_patch

	echo "*** 3) extract game"
	${WIT} extract "${IMAGE}" "${WORKDIR}" --psel=DATA -q || exit 51

	echo "*** 4) detect_game_version"
	detect_game_version
	rm -f "${GAMEID}".wbfs "${CUSTOMID}".wbfs
	echo "*** 5) place_files"
	place_files || exit 45

	echo "*** 6) download_banner"
	download_banner
	echo "*** 7) apply_banner"
	apply_banner

	echo "*** 8) dolpatch"
	dolpatch

	if [[ ${CUSTOMID} ]]; then
		GAMEID="${CUSTOMID}"
	fi

	if [[ ${PATCHIMAGE_SHARE_SAVE} == "TRUE" ]]; then
		TMD_OPTS=""
	else
		TMD_OPTS="--tt-id=K"
	fi

	echo "*** 9) rebuild and store game"
	"${WIT}" cp -o -q --disc-id="${GAMEID}" "${TMD_OPTS}" --name "${GAMENAME}" \
		-B "${WORKDIR}" "${PATCHIMAGE_GAME_DIR}"/"${GAMEID}".wbfs || exit 51

	echo "*** 10) remove workdir"
	rm -rf "${WORKDIR}"

	echo -e "\n >>> ${GAMENAME} saved as: ${PATCHIMAGE_GAME_DIR}/${GAMEID}.wbfs\n"

	if [[ ${PATCHIMAGE_COVER_DOWNLOAD} == TRUE ]]; then
		echo -e "*** Z) download_covers"
		download_covers "${GAMEID}"
		echo -e "\nCovers downloaded to ${PATCHIMAGE_COVER_DIR}"
	fi

}

patchimage_mkwiimm () {

	show_notes
	echo -e "\n*** 1) check_input_image"
	check_input_image
	echo -e "\n*** 2) download_wiimm"
	download_wiimm
	echo -e "\n*** 3) patch_wiimm"
	patch_wiimm

}

patchimage_generic () {

	show_notes
	echo -e "\n*** 1) check_input_image"
	check_input_image_special
	echo -e "\n*** 2) pi_action"
	pi_action

}

patchimage_ips () {
	show_notes
	check_input_rom
	check_riivolution_patch --nofail

	if [[ -f ${PATCH} ]]; then
		ext="${ROM/*.}"
		cp "${ROM}" "${GAMENAME}.${ext}"
		"${IPS}" a "${PATCH}" "${GAMENAME}.${ext}" || exit 51
	elif [[ -f ${PATCHIMAGE_RIIVOLUTION_DIR}/${PATCH} ]]; then
		ext="${ROM/*.}"
		cp "${ROM}" "${GAMENAME}.${ext}"
		"${IPS}" a "${PATCHIMAGE_RIIVOLUTION_DIR}"/"${PATCH}" \
			"${GAMENAME}.${ext}" || exit 51
	else
		echo -e "error: patch (${PATCH}) could not be found"
		exit 21
	fi
}

patchimage_bps () {
	show_notes
	check_input_rom
	check_riivolution_patch --nofail

	if [[ -f ${PATCH} ]]; then
		ext="${ROM/*.}"
		cp "${ROM}" "${GAMENAME}.${ext}"
		"${BPS}" -decode -t "${GAMENAME}.${ext}" "${PATCH}" || exit 51
	elif [[ -f ${PATCHIMAGE_RIIVOLUTION_DIR}/${PATCH} ]]; then
		ext="${ROM/*.}"
		cp "${ROM}" "${GAMENAME}.${ext}"
		"${BPS}" -decode -t "${GAMENAME}.${ext}" \
			"${PATCHIMAGE_RIIVOLUTION_DIR}"/"${PATCH}" || exit 51
	else
		echo -e "error: patch (${PATCH}) could not be found"
		exit 21
	fi
}

patchimage_ppf () {
	show_notes
	check_input_rom
	check_riivolution_patch --nofail

	if [[ -f ${PATCH} ]]; then
		ext="${ROM/*.}"
		cp "${ROM}" "${GAMENAME}.${ext}"
		"${PPF}" a "${PATCH}" "${GAMENAME}.${ext}" || exit 51
	elif [[ -f ${PATCHIMAGE_RIIVOLUTION_DIR}/${PATCH} ]]; then
		ext="${ROM/*.}"
		cp "${ROM}" "${GAMENAME}.${ext}"
		"${PPF}" a "${PATCHIMAGE_RIIVOLUTION_DIR}"/"${PATCH}" \
			"${GAMENAME}.${ext}" || exit 51
	else
		echo -e "error: patch (${PATCH}) could not be found"
		exit 21
	fi
}

patchimage_hans () {

	show_notes
	echo -e "\n*** 1) check_input_rom"
	if [[ ${HANS_MULTI_SOURCE} ]]; then
		check_input_rom_special
	else	check_input_rom
	fi

	rm -rf romfs/ romfs.bin "${ROMFS}"

	echo "*** 2) check_hans_files"
	check_hans_files

	echo "*** 3) unpack_3dsrom"
	unpack_3dsrom "${ROM}" || exit 51

	if [[ ${HANS_DELTA} ]]; then
		echo "*** 4) apply_delta"

		if [[ -f ${PATCH} ]]; then
			"${XD3}" -d -f -s romfs.bin \
				"${PATCH}" "${ROMFS}" || exit 51
		elif [[ -f ${PATCHIMAGE_RIIVOLUTION_DIR}/${PATCH} ]]; then
			"${XD3}" -d -f -s romfs.bin \
				"${PATCHIMAGE_RIIVOLUTION_DIR}"/"${PATCH}" \
				"${ROMFS}" || exit 51
		else
			echo -e "error: patch (${PATCH}) could not be found"
			exit 21
		fi

		echo "*** 5) storing game"
	else
		echo "*** 4) unpack_3dsromfs"
		unpack_3dsromfs romfs.bin || exit 51

		echo "*** 5) patch_romfs"
		patch_romfs

		echo "*** 6) repack_romfs"
		repack_3dsromfs romfs/ "${ROMFS}" || exit 51

		echo "*** 7) storing game"
	fi

	mv "${ROMFS}" "${PATCHIMAGE_ROM_DIR}"

	echo "
	*** succesfully created new romfs as \"${PATCHIMAGE_ROM_DIR}/${ROMFS}\"
	"

	[[ ${DATA} ]] && echo \
	"	>> for Hans Banners / Launchers, place all files from

		$(readlink -m "${DATA}")

	   into the root of your sd card
	"

	if [[ ${HANS_DELTA} ]]; then
		echo "*** 6) remove workdir"
	else	echo "*** 8) remove workdir"
	fi

	rm -rf romfs/ romfs.bin

}

patchimage_delta () {

	show_notes
	echo -e "\n*** 1) menu"
	menu || exit 9

	echo -e "\n*** 2) patch"
	patch || exit 51

}

[[ ! ${GAME} ]] && ask_game

for game in ${GAME[@]}; do
	case ${game} in
		NSMB_ALL )
			NEW_GAME=(${NEW_GAME[@]} NSMB{1..12} NSMB{13..27})
		;;

		PKMN_ALL )
			NEW_GAME=(${NEW_GAME[@]} PKMN{1..9})
		;;

		PKMN_Y )
			NEW_GAME=(${NEW_GAME[@]} PKMN2 PKMN6)
		;;

		PKMN_X )
			NEW_GAME=(${NEW_GAME[@]} PKMN1 PKMN5)
		;;

		PKMN_OR )
			NEW_GAME=(${NEW_GAME[@]} PKMN3 PKMN7)
		;;

		PKMN_AS )
			NEW_GAME=(${NEW_GAME[@]} PKMN4 PKMN8 PKMN9)
		;;
	esac

	[[ ${NEW_GAME} ]] && GAME=(${NEW_GAME[@]})
done

for game in ${GAME[@]}; do

	script=$(gawk -F : "/\<${game}\>/"'{print $3}' ${PATCHIMAGE_DATABASE_DIR}/scripts.db)
	if [[ -f ${PATCHIMAGE_SCRIPT_DIR}/${script} ]]; then
		echo ${PATCHIMAGE_SCRIPT_DIR}/${script}
		source ${PATCHIMAGE_SCRIPT_DIR}/${script}
	else	echo -e "specified Game ${game} not recognized"
		continue
	fi

	if [[ ${PATCHIMAGE_SHOW_DOWNLOAD} ]]; then
		echo -e "\nDownloadlink for required files of Game ${GAMENAME} (${game}):\n\t${DOWNLOAD_LINK}\n"
		continue
	fi

	case ${GAME_TYPE} in
		"RIIVOLUTION" )
			patchimage_riivolution
		;;

		"MKWIIMM")
			patchimage_mkwiimm
		;;

		"GENERIC")
			patchimage_generic
		;;

		"IPS" )
			patchimage_ips
		;;

		"BPS" )
			patchimage_bps
		;;

		"PPF" )
			patchimage_ppf
		;;

		"HANS" )
			patchimage_hans
		;;

		"DELTA" )
			patchimage_delta
		;;

	esac
done
