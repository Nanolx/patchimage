#!/bin/bash

PATCHIMAGE_VERSION=7.3.1
PATCHIMAGE_RELEASE=2016/08/28

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
	export MEGADL="${PATCHIMAGE_TOOLS_DIR}"/megadl."${SUFFIX}"

}

ask_game () {

echo "${SUPPORTED_GAMES_ALL}

Enter ID or Short Name for the Game you want to build (multiple separated by space):
"

read -er GAME

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

unpack () {

	if [[ ${UNP_EXTRA_ARGS} ]]; then
		${UNP} "${1}" -- ${UNP_EXTRA_ARGS} >/dev/null || exit 63
	else	${UNP} "${1}" >/dev/null || exit 63
	fi

}

check_riivolution_patch () {

	x=0
	if [[ ! -d ${RIIVOLUTION_DIR} ]]; then
		x=1
		if [[ -f "${RIIVOLUTION_ZIP_CUSTOM}" ]]; then
			echo "*** >> unpacking"
			x=2
			unpack "${RIIVOLUTION_ZIP_CUSTOM}"
		elif [[ -f "${PWD}/${RIIVOLUTION_ZIP}" ]]; then
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
