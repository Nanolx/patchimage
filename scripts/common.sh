#!/bin/bash

PATCHIMAGE_VERSION=7.2.2
PATCHIMAGE_RELEASE=2016/08/23

[[ -e ${HOME}/.patchimage.rc ]] && source "${HOME}"/.patchimage.rc

setup_tools () {

	if [[ $(uname -m) == "x86_64" ]]; then
		SUFFIX=64
	else	SUFFIX=32
	fi

	export WIT="${PATCHIMAGE_TOOLS_DIR}"/wit."${SUFFIX}"
	export PPF="${PATCHIMAGE_TOOLS_DIR}"/applyppf3."${SUFFIX}"
	export IPS="${PATCHIMAGE_TOOLS_DIR}"/uips."${SUFFIX}"
	export UNP="${PATCHIMAGE_TOOLS_DIR}"/unp
	export SZS="${PATCHIMAGE_TOOLS_DIR}"/wszst."${SUFFIX}"
	export XD3="${PATCHIMAGE_TOOLS_DIR}"/xdelta3."${SUFFIX}"
	export GDOWN="${PATCHIMAGE_TOOLS_DIR}"/gdown.pl
	export CTRTOOL="${PATCHIMAGE_TOOLS_DIR}"/ctrtool."${SUFFIX}"
	export FDSTOOL="${PATCHIMAGE_TOOLS_DIR}"/3dstool."${SUFFIX}"

}

ask_game () {

echo "${SUPPORTED_GAMES_ALL}

Enter ID or Short Name for the Game you want to build (multiple separated by space):
"

read -er GAME

}

download_soundtrack () {

	if [[ ${SOUNDTRACK_LINK} && ! -f ${PATCHIMAGE_AUDIO_DIR}/${SOUNDTRACK_ZIP} ]]; then
		wget -q --no-check-certificate "${SOUNDTRACK_LINK}" \
			-O "${PATCHIMAGE_AUDIO_DIR}"/"${SOUNDTRACK_ZIP}" || exit 57
		echo -e "\n >>> soundtrack saved to\n >>> ${PATCHIMAGE_AUDIO_DIR}/${SOUNDTRACK_ZIP}"
	else
		echo -e "no soundtrack for ${GAMENAME} available."
	fi

}

download_banner () {

	if [[ ${PATCHIMAGE_BANNER_DOWNLOAD} == "TRUE" ]]; then
		if [[ ${CUSTOM_BANNER} ]]; then
			if [[ ! -f "${PATCHIMAGE_RIIVOLUTION_DIR}"/"${GAMEID}"-custom-banner.bnr ]]; then
				wget -q --no-check-certificate "${CUSTOM_BANNER}" \
					-O "${PATCHIMAGE_RIIVOLUTION_DIR}"/"${GAMEID}"-custom-banner.bnr__tmp || \
					rm -f "${PATCHIMAGE_RIIVOLUTION_DIR}"/"${GAMEID}"-custom-banner.bnr__tmp
			fi

			if [[ -f "${PATCHIMAGE_RIIVOLUTION_DIR}"/"${GAMEID}"-custom-banner.bnr__tmp ]]; then
				mv "${PATCHIMAGE_RIIVOLUTION_DIR}"/"${GAMEID}"-custom-banner.bnr__tmp \
					"${PATCHIMAGE_RIIVOLUTION_DIR}"/"${GAMEID}"-custom-banner.bnr
				BANNER="${PATCHIMAGE_RIIVOLUTION_DIR}"/"${GAMEID}"-custom-banner.bnr
			else	echo "*** >> could not download custom banner"
			fi
		else
			echo "*** >> no custom banner available"
		fi
	fi

}

nsmbw_version () {

	if [[ -f ${WORKDIR}/files/COPYDATE_LAST_2009-10-03_232911 ]]; then
		VERSION=EURv1
		export REG_LETTER=P
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2010-01-05_152101 ]]; then
		VERSION=EURv2
		export REG_LETTER=P
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2009-10-03_232303 ]]; then
		VERSION=USAv1
		export REG_LETTER=E
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2010-01-05_143554 ]]; then
		VERSION=USAv2
		export REG_LETTER=E
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2009-10-03_231655 ]]; then
		VERSION=JPNv1
		export REG_LETTER=J
	elif [[ ! ${VERSION} ]]; then
		echo -e "please specify your games version using --version={EURv1,EURv2,USAv1,USAv2,JPNv1}"
		exit 27
	fi
	echo "*** >> status: ${VERSION}"
}

apply_banner () {

	if [[ ${BANNER} != "" ]]; then
		if [[ -e ${BANNER} ]]; then
			cp "${BANNER}" "${BANNER_LOCATION}"
		else
			echo "specified banner ${BANNER} does not exist, not modifying"
		fi
	fi

}

check_directories () {

	if [[ ! -d ${PATCHIMAGE_RIIVOLUTION_DIR} && -w $(dirname "${PATCHIMAGE_RIIVOLUTION_DIR}") ]]; then
		mkdir -p "${PATCHIMAGE_RIIVOLUTION_DIR}" || PATCHIMAGE_RIIVOLUTION_DIR="${HOME}"
	fi

	[[ ! -w ${PATCHIMAGE_RIIVOLUTION_DIR} ]] && PATCHIMAGE_RIIVOLUTION_DIR="${HOME}"

	if [[ ! -d ${PATCHIMAGE_WBFS_DIR} && -w $(dirname "${PATCHIMAGE_WBFS_DIR}") ]]; then
		mkdir -p "${PATCHIMAGE_WBFS_DIR}" || PATCHIMAGE_WBFS_DIR="${HOME}"
	fi

	[[ ! -w "${PATCHIMAGE_WBFS_DIR}" ]] && PATCHIMAGE_WBFS_DIR="${HOME}"

	if [[ ! -d ${PATCHIMAGE_GAME_DIR} && -w $(dirname "${PATCHIMAGE_GAME_DIR}") ]]; then
		mkdir -p "${PATCHIMAGE_GAME_DIR}" || PATCHIMAGE_GAME_DIR="${HOME}"
	fi

	[[ ! -w ${PATCHIMAGE_GAME_DIR} ]] && PATCHIMAGE_GAME_DIR="${HOME}"

	if [[ ! -d ${PATCHIMAGE_3DS_DIR} && -w $(dirname "${PATCHIMAGE_3DS_DIR}") ]]; then
		mkdir -p "${PATCHIMAGE_3DS_DIR}" || PATCHIMAGE_3DS_DIR="${HOME}"
	fi

	[[ ! -w ${PATCHIMAGE_3DS_DIR} ]] && PATCHIMAGE_3DS_DIR="${HOME}"

	if [[ ! -d ${PATCHIMAGE_ROM_DIR} && -w $(dirname "${PATCHIMAGE_ROM_DIR}") ]]; then
		mkdir -p "${PATCHIMAGE_ROM_DIR}" || PATCHIMAGE_ROM_DIR="${HOME}"
	fi

	[[ ! -w ${PATCHIMAGE_ROM_DIR} ]] && PATCHIMAGE_ROM_DIR="${HOME}"

	if [[ ! -d ${PATCHIMAGE_AUDIO_DIR} && -w $(dirname "${PATCHIMAGE_AUDIO_DIR}") ]]; then
		mkdir -p "${PATCHIMAGE_AUDIO_DIR}" || PATCHIMAGE_AUDIO_DIR="${HOME}"
	fi

	[[ ! -w ${PATCHIMAGE_AUDIO_DIR} ]] && PATCHIMAGE_AUDIO_DIR="${HOME}"

	if [[ ! -d ${PATCHIMAGE_COVER_DIR} && -w $(dirname "${PATCHIMAGE_COVER_DIR}") ]]; then
		mkdir -p "${PATCHIMAGE_COVER_DIR}" || PATCHIMAGE_COVER_DIR="${HOME}"
	fi

	[[ ! -w ${PATCHIMAGE_COVER_DIR} ]] && PATCHIMAGE_COVER_DIR="${HOME}"

}


check_input_image () {

	x=0
	if [[ ! ${IMAGE} ]]; then
		WBFS0=$(find . -maxdepth 1 -name "${WBFS_MASK}".wbfs)
		WBFS1=$(find "${PATCHIMAGE_WBFS_DIR}" -name "${WBFS_MASK}".wbfs)
		ISO0=$(find . -maxdepth 1 -name "${WBFS_MASK}".iso)
		ISO1=$(find "${PATCHIMAGE_WBFS_DIR}" -name "${WBFS_MASK}".iso)

		if [[ -f ${WBFS0} ]]; then
			x=1
			IMAGE=${WBFS0}
		elif [[ -f ${ISO0} ]]; then
			x=2
			IMAGE=${ISO0}
		elif [[ -f ${WBFS1} ]]; then
			x=3
			IMAGE=${WBFS1}
		elif [[ -f ${ISO1} ]]; then
			x=4
			IMAGE=${ISO1}
		else
			echo -e "please specify image to use with --iso=<path>"
			exit 15
		fi
	fi
	echo "*** >> status: ${x}"

	IMAGE=$(readlink -m "${IMAGE}")

}

check_input_rom () {

	x=5
	if [[ ! ${ROM} ]]; then
		ROM0=$(find . -maxdepth 1 -name "${ROM_MASK}")
		ROM1=$(find "${PATCHIMAGE_3DS_DIR}" -name "${ROM_MASK}")

		if [[ -f ${ROM0} ]]; then
			x=6
			ROM=${ROM0}
		elif [[ -f ${ROM1} ]]; then
			x=7
			ROM=${ROM1}
		else
			if [[ ! ${HANS_MULTI_SOURCE} ]]; then
				echo -e "error: could not find suitable ROM, specify using --rom"
				exit 15
			fi
		fi
	fi
	echo "*** >> status: ${x}"

	ROM=$(readlink -m "${ROM}")
}

show_nsmb_db () {

	ID1=${1:0:3}
	ID2=${1:4:2}
	gawk -F : "/^${ID1}\*${ID2}/"'{print $2}' \
		< "${PATCHIMAGE_DATABASE_DIR}"/nsmbw.db || echo "** Unknown **"

}

show_mkwiimm_db () {

	ID=${1:4:2}
	[[ ${ID} == [0-9][0-9] ]] && \
		gawk -F : "/^${ID}/"'{print $2}' \
			< "${PATCHIMAGE_DATABASE_DIR}"/mkwiimm.db \
			|| echo "** Unknown **"

}

ask_input_image_mkwiimm () {

	echo "Choose Mario Kart Wii Image to modify

	ALL		patch all images"

	for image in "${PWD}"/RMC???.{iso,wbfs} "${PATCHIMAGE_WBFS_DIR}"/RMC???.{iso,wbfs}; do
		[[ -f ${image} ]] && echo "	${image##*/}	$(show_mkwiimm_db "${image##*/}")"
	done

	echo ""

}

ask_input_image_nsmb () {

	echo "Choose New Super Mario Bros. Wii Image to modify

	ALL		patch all images"

	for image in "${PWD}"/SMN???.{iso,wbfs} \
		"${PWD}"/SLF???.{iso,wbfs} \
		"${PWD}"/SLB???.{iso,wbfs} \
		"${PWD}"/SMM???.{iso,wbfs} \
		"${PWD}"/SMV???.{iso,wbfs} \
		"${PWD}"/MRR???.{iso,wbfs} \
		"${PATCHIMAGE_WBFS_DIR}"/SMN???.{iso,wbfs} \
		"${PATCHIMAGE_WBFS_DIR}"/SLF???.{iso,wbfs} \
		"${PATCHIMAGE_WBFS_DIR}"/SLB???.{iso,wbfs} \
		"${PATCHIMAGE_WBFS_DIR}"/SMM???.{iso,wbfs} \
		"${PATCHIMAGE_WBFS_DIR}"/SMV???.{iso,wbfs} \
		"${PATCHIMAGE_WBFS_DIR}"/MRR???.{iso,wbfs}; do
		[[ -f ${image} ]] && echo "	${image##*/}	$(show_nsmb_db "${image##*/}")"
	done

	echo ""

}

show_titles_db () {

	ID=${1/.*}
	gawk -F : "/^${ID}/"'{print $2}' \
		< "${PATCHIMAGE_DATABASE_DIR}"/titles.db \
		|| echo "** Unknown **"

}

check_wfc () {

	ID=${1/.*}
	if grep -q "${ID}" "${PATCHIMAGE_DATABASE_DIR}"/wfc.db; then
		echo TRUE
	else
		echo FALSE
	fi

}

ask_input_image_wiimmfi () {

	echo "Choose Wii Game Image to wiimmfi"

	for image in "${PWD}"/*.{iso,wbfs} \
		"${PATCHIMAGE_WBFS_DIR}"/*.{iso,wbfs}; do
		if [[ -e ${image} && ! ${image} == "*/RMC*" && $(check_wfc "${image##*/}") == TRUE ]]; then
			echo "	${image##*/}	$(show_titles_db "${image##*/}")"
		fi
	done

	echo ""

}

unpack () {

	if [[ ${UNP_EXTRA_ARGS} ]]; then
		${UNP} "${1}" -- ${UNP_EXTRA_ARGS} >/dev/null || exit 63
	else	${UNP} "${1}" >/dev/null || exit 63
	fi

}

download_riivolution_patch () {

	x=4
	case ${DOWNLOAD_LINK} in
		*docs.google* | *drive.google* )
			x=5
			echo "*** >> downloading"
			${GDOWN} "${DOWNLOAD_LINK}" \
				"${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"__tmp >/dev/null || \
				( echo -e "\nDownload failed!" && exit 57 )
			mv "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"__tmp \
				"${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"
			echo "*** >> unpacking"
			unpack "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"
		;;

		*mega.nz* )
			x=6
			echo "can not download from Mega, download manually from:

	${DOWNLOAD_LINK}
"
			exit 21
		;;

		*mediafire* )
			x=6
			echo "can not download from Mediafire, download manually from:

	${DOWNLOAD_LINK}
"
			exit 21
		;;

		*sendspace* )
			x=6
			echo "can not download from SendSpace, download manually from:

	${DOWNLOAD_LINK}
"
			exit 21
		;;

		*romhacking* )
			x=6
			echo "can not download from Romhacking, download manually from:

	${DOWNLOAD_LINK}
"

			exit 21
		;;

		"" )
			echo "no download link for ${GAMENAME} available."
			exit 21
		;;

		* )
			x=5
			echo "*** >> downloading"
			wget -q --no-check-certificate "${DOWNLOAD_LINK}" \
				-O "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"__tmp || \
				( echo -e "\nDownload failed!" && exit 57 )
			mv "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"__tmp \
				"${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"
			echo "*** >> unpacking"
			unpack "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"
		;;
	esac

}

check_riivolution_patch () {

	x=0
	if [[ ! -d ${RIIVOLUTION_DIR} ]]; then
		x=1
		if [[ -f "${PWD}/${RIIVOLUTION_ZIP}" ]]; then
			echo "*** >> unpacking"
			x=2
			unpack "${PWD}/${RIIVOLUTION_ZIP}"
		elif [[ -f "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}" ]]; then
			echo "*** >> unpacking"
			x=3
			unpack "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"
		elif [[ ${PATCHIMAGE_RIIVOLUTION_DOWNLOAD} == "TRUE" ]]; then
			download_riivolution_patch
		else
			if [[ ${1} == --nofail ]]; then
				echo -e "no zip archive found. Skipping to bare patch file detection"
			else
				echo -e "please specify zip/rar to use with --riivolution=<path>"
				exit 21
			fi
		fi
	fi
	echo "*** >> status: ${x}"

}

download_covers () {

	alt=$(echo "${1}" | sed s/./E/4)

	for path in cover cover3D coverfull disc disccustom; do
		if [[ ! -f "${PATCHIMAGE_COVER_DIR}"/"${1}"_"${path}".png ]]; then
			wget -q -O "${PATCHIMAGE_COVER_DIR}"/"${1}"_"${path}".png \
				http://art.gametdb.com/wii/"${path}"/EN/"${1}".png \
				|| rm "${PATCHIMAGE_COVER_DIR}"/"${1}"_"${path}".png

			if [[ ! -f "${PATCHIMAGE_COVER_DIR}"/"${1}"_"${path}".png ]]; then
				wget -q -O "${PATCHIMAGE_COVER_DIR}"/"${1}"_"${path}".png \
					http://art.gametdb.com/wii/"${path}"/US/"${alt}".png \
				|| rm "${PATCHIMAGE_COVER_DIR}"/"${1}"_"${path}".png
			fi

			[[ ! -f "${PATCHIMAGE_COVER_DIR}"/"${1}"_"${path}".png ]] && \
				echo "Cover (${path}) does not exist for gameid ${1}."
		fi

	done

}

unpack_3dsrom () {

	${CTRTOOL} -p --romfs=romfs.bin "${1}" &>/dev/null

}

unpack_3dsromfs () {

	${CTRTOOL} -t romfs --romfsdir=romfs "${1}" &>/dev/null

}

repack_3dsromfs () {

	${FDSTOOL} -ctf romfs "${2}" --romfs-dir "${1}" &>/dev/null

}

optparse () {

xcount=0
pcount=$#

while [[ $xcount -lt $pcount ]]; do
	case ${1} in

		--iso=* )
			ISO_PATH="${1/*=}"

			if [[ -f "${ISO_PATH}" ]]; then
				IMAGE="${ISO_PATH}"
			else
				echo -e "ISO not found"
				exit 15
			fi
		;;

		--rom=* )
			ROM_PATH="${1/*=}"

			if [[ -f "${ROM_PATH}" ]]; then
				ROM="${ROM_PATH}"
			else
				echo -e "ROM not found"
				exit 15
			fi
		;;

		--riivolution=* )
			RIIVOLUTION="${1/*=}"
			if [[ -f "${RIIVOLUTION}" ]]; then
				"${UNP}" "${RIIVOLUTION}" >/dev/null
			else
				echo -e "Riivolution patch ${RIIVOLUTION} not found."
				exit 21
			fi
		;;

		--patch=*  )
			PATCH="${1/*=}"
			if [[ -f "${PATCH}" ]]; then
				PATCH="${PATCH}"
			else
				echo -e "IPS/PPF patch ${PATCH} not found."
				exit 21
			fi
		;;

		--customid=* )
			CUSTOMID=${1/*=}
			if [[ ${#CUSTOMID} != 6 ]]; then
				echo -e "CustomID ${CUSTOMID} needs to have 6 digits"
				exit 39
			fi
		;;

		--download )
			export PATCHIMAGE_RIIVOLUTION_DOWNLOAD=TRUE
		;;

		--show-download )
			export PATCHIMAGE_SHOW_DOWNLOAD=TRUE
		;;

		--soundtrack )
			export PATCHIMAGE_SOUNDTRACK_DOWNLOAD=TRUE
		;;

		--only-soundtrack )
			export PATCHIMAGE_SOUNDTRACK_DOWNLOAD=TRUE
			export ONLY_SOUNDTRACK=TRUE
		;;

		--override-szs )
			export MKWIIMM_OVERRIDE_SZS=TRUE
		;;

		--version=* )
			VERSION="${1/*=}"
			case ${VERSION} in
				EURv1 )
					export REG_LETTER=P
				;;

				EURv2 )
					export REG_LETTER=P
				;;

				USAv1 )
					export REG_LETTER=E
				;;

				USAv2 )
					export REG_LETTER=E
				;;

				JPNv1 )
					export REG_LETTER=J
				;;

				* )
					echo -e "unrecognized game version: ${VERSION}"
					exit 27
				;;
			esac
		;;

		--sharesave )
			export PATCHIMAGE_SHARE_SAVE=TRUE
		;;

		--game=* )
			export GAME="${1/*=}"
		;;

		--list-games )
			echo "${SUPPORTED_GAMES_ALL}"
			exit 0
		;;

		--list-games-nsmb )
			echo "${SUPPORTED_GAMES_NSMB}"
			exit 0
		;;

		--list-games-mkwiimmfi )
			echo "${SUPPORTED_GAMES_MKWIIMMFI}"
			exit 0
		;;

		--list-games-tokyo )
			echo "${SUPPORTED_GAMES_TOKYOMIRAGESESSIONSFE}"
			exit 0
		;;

		--list-games-kirby )
			echo "${SUPPORTED_GAMES_KIRBY}"
			exit 0
		;;

		--list-games-pokemon )
			echo "${SUPPORTED_GAMES_POKEMON}"
			exit 0
		;;

		--list-games-3ds )
			echo "${SUPPORTED_GAMES_3DS}"
			exit 0
		;;

		--list-games-other )
			echo "${SUPPORTED_GAMES_OTHER}"
			exit 0
		;;

		--list-requirements )
			echo "${REQUIREMENTS_ALL}"
			exit 0
		;;

		--list-requirements-nsmb )
			echo "${REQUIREMENTS_NSMB}"
			echo "${REQUIREMENTS_FOOTER}"
			exit 0
		;;

		--list-requirements-mkwiimmfi )
			echo "${REQUIREMENTS_MKWIIMMFI}"
			echo "${REQUIREMENTS_FOOTER}"
			exit 0
		;;

		--list-requirements-tokyo )
			echo "${REQUIREMENTS_TOKYOMIRAGESESSIONSFE}"
			echo "${REQUIREMENTS_FOOTER}"
			exit 0
		;;

		--list-requirements-kirby )
			echo "${REQUIREMENTS_KIRBY}"
			echo "${REQUIREMENTS_FOOTER}"
			exit 0
		;;

		--list-requirements-pokemon )
			echo "${REQUIREMENTS_POKEMON}"
			echo "${REQUIREMENTS_FOOTER}"
			exit 0
		;;

		--list-requirements-3ds )
			echo "${REQUIREMENTS_3DS}"
			echo "${REQUIREMENTS_FOOTER}"
			exit 0
		;;

		--list-requirements-other )
			echo "${REQUIREMENTS_OTHER}"
			echo "${REQUIREMENTS_FOOTER}"
			exit 0
		;;

		--covers )
			export PATCHIMAGE_COVER_DOWNLOAD=TRUE
		;;

		--only-covers=* )
			export PATCHIMAGE_COVER_DOWNLOAD=TRUE
			download_covers "${1/*=}"
			exit 0
		;;

		--banner=* )
			BANNER="${1/*=}"
			BANNER_EXT="${BANNER//*./}"
			if [[ ${BANNER_EXT} != "bnr" ]]; then
				echo "given banner (${BANNER}) is not a .bnr file!"
				exit 33
			fi
		;;

		--download-banner )
			export PATCHIMAGE_BANNER_DOWNLOAD=TRUE
		;;

		--xdelta=* )
			export XDELTA_PATH="${1/*=}"
		;;

		--cpk=* )
			export CPK_PATH="${1/*=}"
		;;

		--help | -h )
			echo "${PATCHIMAGE_HELP}"
			exit 0
		;;
	esac
	shift
	xcount=$((xcount+1))
done

}
