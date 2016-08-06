#!/bin/bash

PATCHIMAGE_VERSION=7.0.0
PATCHIMAGE_RELEASE=2016/08/03

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

echo -e \
"************************************************
patchimage v${PATCHIMAGE_VERSION}

ID	Name

<<<<<< New Super Mario Bros. Wii >>>>>>
NSMB1	NewerSMB
NSMB2	Newer Summer Sun
NSMB3	AnotherSMB
NSMB4	Newer: Holiday Special
NSMB5	Cannon Super Mario Bros.
NSMB6	Epic Super Bowser World
NSMB7	Koopa Country
NSMB8	New Super Mario Bros. 4
NSMB9	New Super Mario Bros. Wii Retro Remix
NSMB10	Super Mario: Mushroom Adventure PLUS - Winter Moon
NSMB11	NSMBW3: The Final Levels
NSMB12	Super Mario Vacation
NSMB13	Awesomer Super Luigi Mini
NSMB14	Super Mario Skyland
NSMB15	RVLution Wii (NewSMB Mod)
NSMB16	Midi's Super Mario Wii (Just A Little Adventure)
NSMB17	DarkUmbra SMB Anniversary Edition
NSMB18	Newer Apocalypse
NSMB19	Luigi's Super Yoshi Bros.
NSMB20	Newer: Falling Leaf
NSMB21	Devil Mario Winter Special
NSMB22	New Super Mario Bros. Wii - Other World
NSMB23	The Legend of Yoshi
NSMB24	Remixed Super Mario Bros. Wii
NSMB25	Ghostly Super Ghost Boos. Wii
NSMB26	Revised Super Mario Bros. Wii

NSMB99	Customize Characters

<<<<<< Mario Kart Wii >>>>>>
MKW1	Wiimfi Patcher. Patch Mario Kart to use Wiimm's server
MKW2	Wiimfi Patcher. Patch WFC games to use Wiimm's server (exp)
MKW3	Mario Kart Wiimm. Custom Mario Kart Distribution
MKW4	Custom Items. Replace items in the game
MKW5	Custom Font. Replace font in the game
MKW6	Custom Karts. Replace characters in the game

<<<<<< Kirby's Adventure Wii >>>>>>
KAW1	Change first player's character

<<<<<< Tokyo Mirage Sessions #FE >>>>>>
TMS1	Uncensor US/EUR version

<<<<<< 3DS ROMS >>>>>>
PKMN1	Pokemon Neo X
PKMN2	Pokemon Neo Y
PKMN3	Pokemon Rutile Ruby
PKMN4	Pokemon Star Sapphire
PKMN5	Pokemon Eternal X
PKMN6	Pokemon Wilting Y
PKMN7	Pokemon Rising Ruby
PKMN8	Pokemon Sinking Sapphire

BSECU	Bravely Second Uncensored

<<<<<< ROMS >>>>>>
ZEL1	The Legend of Zelda: Parallel Worlds

ID	Name
Enter ID for the Game you want to create:
"

read -r GAME

}

download_soundtrack () {

	if [[ ${SOUNDTRACK_LINK} && ! -f ${PATCHIMAGE_AUDIO_DIR}/${SOUNDTRACK_ZIP} ]]; then
		wget --no-check-certificate "${SOUNDTRACK_LINK}" \
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
				wget --no-check-certificate "${CUSTOM_BANNER}" \
					-O "${PATCHIMAGE_RIIVOLUTION_DIR}"/"${GAMEID}"-custom-banner.bnr__tmp || exit 57
				mv "${PATCHIMAGE_RIIVOLUTION_DIR}"/"${GAMEID}"-custom-banner.bnr__tmp \
					"${PATCHIMAGE_RIIVOLUTION_DIR}"/"${GAMEID}"-custom-banner.bnr
			fi
			BANNER="${PATCHIMAGE_RIIVOLUTION_DIR}"/"${GAMEID}"-custom-banner.bnr
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
		if test -f "${WBFS_MASK}".wbfs; then
			x=1
			IMAGE="${WBFS_MASK}".wbfs
		elif test -f "${WBFS_MASK}".iso; then
			x=2
			IMAGE="${WBFS_MASK}".iso
		elif test -f "${PATCHIMAGE_WBFS_DIR}"/"${WBFS_MASK}".iso; then
			x=3
			IMAGE="${PATCHIMAGE_WBFS_DIR}"/"${WBFS_MASK}".iso
		elif test -f "${PATCHIMAGE_WBFS_DIR}"/"${WBFS_MASK}".wbfs; then
			x=4
			IMAGE="${PATCHIMAGE_WBFS_DIR}"/"${WBFS_MASK}".wbfs
		else
			echo -e "please specify image to use with --iso=<path>"
			exit 15
		fi
	fi
	echo "*** >> status: ${x}"

}

check_input_rom () {

	x=5
	if [[ ! ${ROM} ]]; then
		ROM=$(find . -name "${ROM_MASK}" | sed -e 's,./,,')
		if [[ -f ${ROM} ]]; then
			x=6
			ROM="${ROM}"
		else
			ROM=$(find "${PATCHIMAGE_3DS_DIR}" -name "${ROM_MASK}")
			if [[ -f ${ROM} ]]; then
				x=7
				ROM="${ROM}"
			else
				if [[ ! ${HANS_MULTI_SOURCE} ]]; then
					echo -e "error: could not find suitable ROM, specify using --rom"
					exit 15
				fi
			fi
		fi
	fi
	echo "*** >> status: ${x}"
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
		"${PWD}"/SMM???.{iso,wbfs} \
		"${PWD}"/SMV???.{iso,wbfs} \
		"${PWD}"/MRR???.{iso,wbfs} \
		"${PATCHIMAGE_WBFS_DIR}"/SMN???.{iso,wbfs} \
		"${PATCHIMAGE_WBFS_DIR}"/SLF???.{iso,wbfs} \
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

check_riivolution_patch () {

	x=0
	if [[ ! -d ${RIIVOLUTION_DIR} ]]; then
		x=1
		if [[ -f "${PWD}/${RIIVOLUTION_DIR}" ]]; then
			echo "*** >> unpacking"
			x=2
			${UNP} "${PWD}/${RIIVOLUTION_ZIP}" -- "${UNP_EXTRA_ARGS}" >/dev/null || exit 63
		elif [[ -f "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}" ]]; then
			echo "*** >> unpacking"
			x=3
			${UNP} "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}" -- "${UNP_EXTRA_ARGS}" >/dev/null || exit 63
		elif [[ ${PATCHIMAGE_RIIVOLUTION_DOWNLOAD} == "TRUE" ]]; then
			x=4
			if [[ ${DOWNLOAD_LINK} == *docs.google* || ${DOWNLOAD_LINK} == *drive.google*  ]]; then
				if [[ ! -f "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}" ]]; then
					x=5
					echo "*** >> downloading"
					${GDOWN} "${DOWNLOAD_LINK}" "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"__tmp >/dev/null || exit 57
					mv "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"__tmp "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"
					echo "*** >> unpacking"
					${UNP} "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}" -- "${UNP_EXTRA_ARGS}" >/dev/null || exit 63
				fi
			elif [[ ${DOWNLOAD_LINK} == *mega.nz* ]]; then
				echo "can not download from Mega, download manually from:

	${DOWNLOAD_LINK}
"
				exit 21
			elif [[ ${DOWNLOAD_LINK} == *mediafire* ]]; then
				echo "can not download from Mediafire, download manually from:

	${DOWNLOAD_LINK}
"
				exit 21
			elif [[ ${DOWNLOAD_LINK} ]]; then
				if [[ ! -f "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}" ]]; then
					x=5
					echo "*** >> downloading"
					wget --no-check-certificate "${DOWNLOAD_LINK}" -O "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"__tmp >/dev/null || exit 57
					mv "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"__tmp "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"
					echo "*** >> unpacking"
					${UNP} "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}" -- "${UNP_EXTRA_ARGS}" >/dev/null || exit 63
				fi
			else
				echo "no download link for ${GAMENAME} available."
				exit 21
			fi
		else
			echo -e "please specify zip/rar to use with --riivolution=<path>"
			exit 21
		fi
	fi
	echo "*** >> status: ${x}"

}

download_covers () {

	alt=$(echo "${1}" | sed s/./E/4)

	for path in cover cover3D coverfull disc disccustom; do
		if [[ ! -f "${PATCHIMAGE_COVER_DIR}"/"${1}"_"${path}".png ]]; then
			wget -O "${PATCHIMAGE_COVER_DIR}"/"${1}"_"${path}".png \
				http://art.gametdb.com/wii/"${path}"/EN/"${1}".png &>/dev/null \
				|| rm "${PATCHIMAGE_COVER_DIR}"/"${1}"_"${path}".png

			if [[ ! -f "${PATCHIMAGE_COVER_DIR}"/"${1}"_"${path}".png ]]; then
				wget -O "${PATCHIMAGE_COVER_DIR}"/"${1}"_"${path}".png \
					http://art.gametdb.com/wii/"${path}"/US/"${alt}".png &>/dev/null \
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
			if [[ -e "${RIIVOLUTION}" ]]; then
				"${UNP}" "${RIIVOLUTION}" >/dev/null
			else
				echo -e "Riivolution patch ${RIIVOLUTION} not found."
				exit 21
			fi
		;;

		--patch=*  )
			PATCH="${1/*=}"
			if [[ -e "${PATCH}" ]]; then
				${UNP} "${PATCH}" >/dev/null
			else
				echo -e "PATCH patch ${PATCH} not found."
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

		--soundtrack )
			export PATCHIMAGE_SOUNDTRACK_DOWNLOAD=TRUE
		;;

		--only-soundtrack )
			export PATCHIMAGE_SOUNDTRACK_DOWNLOAD=TRUE
			export ONLY_SOUNDTRACK=TRUE
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
			echo -e "patchimage ${PATCHIMAGE_VERSION} (${PATCHIMAGE_RELEASE})

	(c) 2013-2016 Christopher Roy Bratusek <nano@jpberlin.de>
	patchimage creates wbfs images from riivolution patches.

--game=<gamename/gameletter>		| specify game you want to create
--iso/--rom=/home/test/<Image>		| specify which ISO/ROM to use for building
--riivolution/--patch=<Patch>		| specify path to Riivolution/Patch files
--version=EURv1,EURv2,USAv1,USAv2,JPNv1	| specify your game version
--customdid=SMNP02			| specify a custom ID to use for the game
--sharesave				| let modified game share savegame with original game
--download				| download riivolution patchfiles
--soundtrack				| download soundtrack (if available)
--only-soundtrack			| download soundtrack only (if available) and exit
--covers				| download covers (if available)
--only-covers=SMNP02			| download covers only (if available)
--banner=<banner.bnr>			| use a custom banner (riivolution games)
--download-banner			| download a custom banner (if available)
--xdelta=<path>				| path to xdelta patches
--cpk=<path>				| path to unpatched xdelta patches"
			exit 0
		;;
	esac
	shift
	xcount=$((xcount+1))
done

}
