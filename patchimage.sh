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
export PATCHIMAGE_ROM_DIR="${basedir}"
export PATCHIMAGE_3DS_DIR="${basedir}"

MODULES="common downloader helper-3ds helper-mkwii \
	helper-nsmb helper-wiimmfi messages optparse patcher"
for mod in ${MODULES[@]}; do
	source "${PATCHIMAGE_SCRIPT_DIR}/common/${mod}.sh"
done

optparse "${@}"

check_directories
setup_tools

[[ ! ${GAME} ]] && ask_game

for game in ${GAME[@]}; do
	case ${game} in
		NSMB_ALL )
			NEW_GAME=(${NEW_GAME[@]} NSMB{1..29})
		;;

		PKMN_ALL )
			NEW_GAME=(${NEW_GAME[@]} PKMN{1..10})
		;;

		PKMN_Y )
			NEW_GAME=(${NEW_GAME[@]} PKMN2 PKMN6)
		;;

		PKMN_X )
			NEW_GAME=(${NEW_GAME[@]} PKMN1 PKMN5)
		;;

		PKMN_OR )
			NEW_GAME=(${NEW_GAME[@]} PKMN3 PKMN7 PKMN10)
		;;

		PKMN_AS )
			NEW_GAME=(${NEW_GAME[@]} PKMN4 PKMN8 PKMN9)
		;;
	esac

	[[ ${NEW_GAME} ]] && GAME=(${NEW_GAME[@]})
done

CURDIR=${PWD}
if [[ -w ${CURDIR} ]]; then
	BUILD_DIR="${CURDIR}"/patchimage_build
else	BUILD_DIR="${HOME}"/patchimage_build
fi

for game in ${GAME[@]}; do

	script=$(gawk -F : "/\<${game}\>/"'{print $3}' ${PATCHIMAGE_DATABASE_DIR}/scripts.db)
	if [[ -f ${PATCHIMAGE_SCRIPT_DIR}/${script} ]]; then
		source ${PATCHIMAGE_SCRIPT_DIR}/${script}
	else	echo -e "specified Game ${game} not recognized"
		continue
	fi

	if [[ ${PATCHIMAGE_SHOW_DOWNLOAD} ]]; then
		echo -e "\nDownloadlink for required files of Game:\n\t${GAMENAME} (${game}):\n\n\t${DOWNLOAD_LINK}\n"
		continue
	fi

	rm -rf "${BUILD_DIR}"
	mkdir -p "${BUILD_DIR}"
	cd "${BUILD_DIR}"

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

	cd "${CURDIR}"
done
