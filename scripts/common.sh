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

SUPPORTED_GAMES="************************************************
patchimage v${PATCHIMAGE_VERSION}

ID	Short Name		Full Name

<<<<<< New Super Mario Bros. Wii >>>>>>
NSMB1	NewerSMB		NewerSMB
NSMB2	NewerSummerSun		Newer Summer Sun
NSMB3	AnotherSMB		AnotherSMB
NSMB4	HolidaySpecial		Newer: Holiday Special
NSMB5	Cannon			Cannon Super Mario Bros.
NSMB6	BowserWorld		Epic Super Bowser World
NSMB7	KoopaCountry		Koopa Country
NSMB8	NewSuperMarioBros4	New Super Mario Bros. 4
NSMB9	RetroRemix		New Super Mario Bros. Wii Retro Remix
NSMB10	WinterMoon		Super Mario: Mushroom Adventure PLUS - Winter Moon
NSMB11	NSMBW3			NSMBW3: The Final Levels
NSMB12	Vacation		Super Mario Vacation
NSMB13	ASLM			Awesomer Super Luigi Mini
NSMB14	Sykland			Super Mario Skyland
NSMB15	RVLution		RVLution Wii (NewSMB Mod)
NSMB16	Midi			Midi's Super Mario Wii (Just A Little Adventure)
NSMB17	DarkUmbra		DarkUmbra SMB Anniversary Edition
NSMB18	NewerApocalypse		Newer Apocalypse
NSMB19	LuigisSuperYoshiBros	Luigi's Super Yoshi Bros.
NSMB20	NewerFallingLeaf	Newer: Falling Leaf
NSMB21	DevilMarioWinterSpecial	Devil Mario Winter Special
NSMB22	NewSMBWOtherWorld	New Super Mario Bros. Wii - Other World
NSMB23	TheLegendOfYoshi	The Legend of Yoshi
NSMB24	RemixedSuperMarioBros	Remixed Super Mario Bros. Wii
NSMB25	GhostlySuperGhostBoos	Ghostly Super Ghost Boos. Wii
NSMB26	RevisedSuperMarioBros	Revised Super Mario Bros. Wii

NSMB99	NSMBWCharacters		Customize Characters

<<<<<< Mario Kart Wii >>>>>>
MKW1	Wiimmfi			Wiimfi Patcher. Patch Mario Kart to use Wiimm's server
MKW2	Wiimmpatch		Wiimfi Patcher. Patch WFC games to use Wiimm's server (exp)
MKW3	Mkwiimm			Mario Kart Wiimm. Custom Mario Kart Distribution
MKW4	MkwiimmItems		Custom Items. Replace items in the game
MKW5	MkwiimmFonts		Custom Font. Replace font in the game
MKW6	MkwiimmKarts		Custom Karts. Replace characters in the game

<<<<<< Kirby's Adventure Wii >>>>>>
KAW1	Kirby			Change first player's character

<<<<<< Tokyo Mirage Sessions #FE >>>>>>
TMS1	TokyoMirageSessions	Uncensor US/EUR version

<<<<<< 3DS ROMS >>>>>>
PKMN1	NeoX			Pokemon Neo X
PKMN2	NeoY			Pokemon Neo Y
PKMN3	RutileRuby		Pokemon Rutile Ruby
PKMN4	AlphaSapphire		Pokemon Star Sapphire
PKMN5	EternalX		Pokemon Eternal X
PKMN6	WiltingY		Pokemon Wilting Y
PKMN7	RisingRuby		Pokemon Rising Ruby
PKMN8	SinkingSapphire		Pokemon Sinking Sapphire

BSECU	BravelySecondUncensored	Bravely Second Uncensored

<<<<<< ROMS >>>>>>
ZEL1	ParallelWorlds		The Legend of Zelda: Parallel Worlds

ID	Short Name		Full Name
"

ask_game () {

echo -e \
"${SUPPORTED_GAMES}

Enter ID or Short Name for the Game you want to build (multiple separated by space):
"

read -r GAME

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
			else	"*** >> could not download custom banner"
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
		if [[ -f "${PWD}/${RIIVOLUTION_ZIP}" ]]; then
			echo "*** >> unpacking"
			x=2
			unpack "${PWD}/${RIIVOLUTION_ZIP}"
		elif [[ -f "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}" ]]; then
			echo "*** >> unpacking"
			x=3
			unpack "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"
		elif [[ ${PATCHIMAGE_RIIVOLUTION_DOWNLOAD} == "TRUE" ]]; then
			x=4
			if [[ ${DOWNLOAD_LINK} == *docs.google* || ${DOWNLOAD_LINK} == *drive.google*  ]]; then
				if [[ ! -f "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}" ]]; then
					x=5
					echo "*** >> downloading"
					${GDOWN} "${DOWNLOAD_LINK}" "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"__tmp >/dev/null || exit 57
					mv "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"__tmp "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"
					echo "*** >> unpacking"
					unpack "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"
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
					wget -q --no-check-certificate "${DOWNLOAD_LINK}" -O "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"__tmp >/dev/null || exit 57
					mv "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"__tmp "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"
					echo "*** >> unpacking"
					unpack "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"
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
			echo "${SUPPORTED_GAMES}"
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
			echo -e "patchimage ${PATCHIMAGE_VERSION} (${PATCHIMAGE_RELEASE})

	(c) 2013-2016 Christopher Roy Bratusek <nano@jpberlin.de>
	patchimage creates wbfs images from riivolution patches.

*** General parameters ***
--help						| show this message
--game=<ID/Short Name>				| specify game you want to create
--game=\"<ID1/Short Name1> <ID2/Short Name2>\"	| specify multiple games you want to create
--list-games					| show possible options for --game

*** Wii game parameters ***
--iso=/home/test/RMCP01.iso			| specify path to Wii iso or wbfs image to use
--riivolution=/home/test/MyMod.zip		| specify path to Wii Riivolution archive
--version=EURv1,EURv2,USAv1,USAv2,JPNv1		| specify your game version (New Super Mario Bros. Wii)
--customdid=SMNP02				| specify a custom ID to use for the modified Wii game
--sharesave					| let modified Wii games share savegame with the original game
--download					| download Riivolution or HANS patch archives (if possible)
--soundtrack					| download soundtrack (if available)
--only-soundtrack				| download soundtrack only (if available) and exit
--covers					| download covers (if available)
--only-covers=SMNP02				| download covers only (if available)
--banner=<banner.bnr>				| use a custom banner (Riivolution games)
--download-banner				| download a custom banner (if available)
--override-szs					| override wit and szs in Wiimms Mario Kart Fun distributions
						| [use this if the originals fail due to incompatible library versions]

*** 3DS game parameters ***
--rom=/home/test/0004000000055e00.cxi		| specify path to 3DS ROM to use for building
--hans=/home/test/MyModdedGame.zip		| specify path to 3DS HANS archive

*** Wii U game parameters ***
--xdelta=/home/test/xdelta			| specify path to Tokyo Mirage Sessions #FE xdelta patches
--cpk=/home/test/cpk				| specify path to original Tokyo Mirage Mirage Sessions #FE files

*** Other game parameters ***
--rom=/home/test/MyGame.rom			| specify path to ROM to use for building
--patch=/home/test/MyModdedGame.ips		| specify path to IPS Patch file
"
			exit 0
		;;
	esac
	shift
	xcount=$((xcount+1))
done

}
