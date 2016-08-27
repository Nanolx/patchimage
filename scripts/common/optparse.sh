#!/bin/bash


optparse () {

xcount=0
pcount=$#

while [[ $xcount -lt $pcount ]]; do
	case ${1} in

		--iso=* )
			ISO_PATH="${1/*=}"

			if [[ -f "${ISO_PATH}" ]]; then
				IMAGE=$(readlink -m "${ISO_PATH}")
			else
				echo -e "ISO not found"
				exit 15
			fi
		;;

		--rom=* )
			ROM_PATH="${1/*=}"

			if [[ -f "${ROM_PATH}" ]]; then
				ROM=$(readlink -m "${ROM_PATH}")
			else
				echo -e "ROM not found"
				exit 15
			fi
		;;

		--riivolution=* )
			RIIVOLUTION="${1/*=}"
			if [[ -f "${RIIVOLUTION}" ]]; then
				RIIVOLUTION_ZIP_CUSTOM=$(readlink -m "${RIIVOLUTION}")
			else
				echo -e "Riivolution patch ${RIIVOLUTION} not found."
				exit 21
			fi
		;;

		--patch=*  )
			PATCH="${1/*=}"
			if [[ -f "${PATCH}" ]]; then
				PATCH=$(readlink -m "${PATCH}")
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
			if [[ -d ${1/*=} ]]; then
				export XDELTA_PATH=$(readlink -m "${1/*=}")
			else
				echo "given directory ${1/*=} does no exist."
				exit 75
			fi
		;;

		--cpk=* )
			if [[ -d ${1/*=} ]]; then
				export CPK_PATH=$(readlink -m "${1/*=}")
			else
				echo "given directory ${1/*=} does no exist."
				exit 75
			fi
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
