#!/bin/bash

PATCHIMAGE_VERSION=6.4.0
PATCHIMAGE_RELEASE=2016/08/03

[[ -e $HOME/.patchimage.rc ]] && source $HOME/.patchimage.rc

setup_tools () {

	if [[ $(uname -m) == "x86_64" ]]; then
		SUFFIX=64
	else	SUFFIX=32
	fi

	WIT="${PATCHIMAGE_TOOLS_DIR}"/wit.${SUFFIX}
	PPF="${PATCHIMAGE_TOOLS_DIR}"/applyppf3.${SUFFIX}
	IPS="${PATCHIMAGE_TOOLS_DIR}"/uips.${SUFFIX}
	UNP="${PATCHIMAGE_TOOLS_DIR}"/unp
	SZS="${PATCHIMAGE_TOOLS_DIR}"/wszst.${SUFFIX}
	XD3="${PATCHIMAGE_TOOLS_DIR}"/xdelta3.${SUFFIX}
	GDOWN="${PATCHIMAGE_TOOLS_DIR}"/gdown.pl
	CTRTOOL="${PATCHIMAGE_TOOLS_DIR}"/ctrtool.${SUFFIX}
	FDSTOOL="${PATCHIMAGE_TOOLS_DIR}"/3dstool.${SUFFIX}

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

read GAME

}

download_soundtrack () {

	if [[ ${SOUNDTRACK_LINK} && ! -f "${PATCHIMAGE_AUDIO_DIR}"/"${SOUNDTRACK_ZIP}" ]]; then
		wget --no-check-certificate "${SOUNDTRACK_LINK}" -O "${PATCHIMAGE_AUDIO_DIR}"/"${SOUNDTRACK_ZIP}" || exit 57
		echo -e "\n >>> soundtrack saved to\n >>> ${PATCHIMAGE_AUDIO_DIR}/${SOUNDTRACK_ZIP}"
	else
		echo -e "no soundtrack for ${GAMENAME} available."
	fi

}

download_banner () {

	if [[ ${PATCHIMAGE_BANNER_DOWNLOAD} == "TRUE" ]]; then
		if [[ ${CUSTOM_BANNER} ]]; then
			if [[ ! -f "${PATCHIMAGE_RIIVOLUTION_DIR}"/${GAMEID}-custom-banner.bnr ]]; then
				wget --no-check-certificate "${CUSTOM_BANNER}" -O "${PATCHIMAGE_RIIVOLUTION_DIR}"/${GAMEID}-custom-banner.bnr__tmp || exit 57
				mv "${PATCHIMAGE_RIIVOLUTION_DIR}"/${GAMEID}-custom-banner.bnr__tmp "${PATCHIMAGE_RIIVOLUTION_DIR}"/${GAMEID}-custom-banner.bnr
			fi
			BANNER="${PATCHIMAGE_RIIVOLUTION_DIR}"/${GAMEID}-custom-banner.bnr
		else
			echo "*** >> no custom banner available"
		fi
	fi

}

nsmbw_version () {

	if [[ -f ${WORKDIR}/files/COPYDATE_LAST_2009-10-03_232911 ]]; then
		VERSION=EURv1
		REG_LETTER=P
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2010-01-05_152101 ]]; then
		VERSION=EURv2
		REG_LETTER=P
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2009-10-03_232303 ]]; then
		VERSION=USAv1
		REG_LETTER=E
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2010-01-05_143554 ]]; then
		VERSION=USAv2
		REG_LETTER=E
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2009-10-03_231655 ]]; then
		VERSION=JPNv1
		REG_LETTER=J
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

	[[ ! -d ${PATCHIMAGE_RIIVOLUTION_DIR} && -w $(dirname ${PATCHIMAGE_RIIVOLUTION_DIR}) ]] && \
		( mkdir -p "${PATCHIMAGE_RIIVOLUTION_DIR}" || PATCHIMAGE_RIIVOLUTION_DIR=${HOME} )

	[[ ! -w ${PATCHIMAGE_RIIVOLUTION_DIR} ]] && PATCHIMAGE_RIIVOLUTION_DIR=${HOME}

	[[ ! -d ${PATCHIMAGE_WBFS_DIR} && -w $(dirname ${PATCHIMAGE_WBFS_DIR}) ]] && \
		( mkdir -p "${PATCHIMAGE_WBFS_DIR}" || PATCHIMAGE_WBFS_DIR=${HOME} )

	[[ ! -w "${PATCHIMAGE_WBFS_DIR}" ]] && PATCHIMAGE_WBFS_DIR=${HOME}

	[[ ! -d ${PATCHIMAGE_GAME_DIR} && -w $(dirname ${PATCHIMAGE_GAME_DIR}) ]] && \
		( mkdir -p "${PATCHIMAGE_GAME_DIR}" || PATCHIMAGE_GAME_DIR=${HOME} )

	[[ ! -w ${PATCHIMAGE_GAME_DIR} ]] && PATCHIMAGE_GAME_DIR=${HOME}

	[[ ! -d ${PATCHIMAGE_3DS_DIR} && -w $(dirname ${PATCHIMAGE_3DS_DIR}) ]] && \
		( mkdir -p "${PATCHIMAGE_3DS_DIR}" || PATCHIMAGE_3DS_DIR=${HOME} )

	[[ ! -w ${PATCHIMAGE_3DS_DIR} ]] && PATCHIMAGE_3DS_DIR=${HOME}

	[[ ! -d ${PATCHIMAGE_ROM_DIR} && -w $(dirname ${PATCHIMAGE_ROM_DIR}) ]] && \
		( mkdir -p "${PATCHIMAGE_ROM_DIR}" || PATCHIMAGE_ROM_DIR=${HOME} )

	[[ ! -w ${PATCHIMAGE_ROM_DIR} ]] && PATCHIMAGE_ROM_DIR=${HOME}

	[[ ! -d ${PATCHIMAGE_AUDIO_DIR} && -w $(dirname ${PATCHIMAGE_AUDIO_DIR}) ]] && \
		( mkdir -p "${PATCHIMAGE_AUDIO_DIR}" || PATCHIMAGE_AUDIO_DIR=${HOME} )

	[[ ! -w ${PATCHIMAGE_AUDIO_DIR} ]] && PATCHIMAGE_AUDIO_DIR=${HOME}

	[[ ! -d ${PATCHIMAGE_COVER_DIR} && -w $(dirname "${PATCHIMAGE_COVER_DIR}") ]] && \
		( mkdir -p "${PATCHIMAGE_COVER_DIR}" || PATCHIMAGE_COVER_DIR=${HOME} )

	[[ ! -w ${PATCHIMAGE_COVER_DIR} ]] && PATCHIMAGE_COVER_DIR=${HOME}

}

check_input_image () {

	x=0
	if [[ ! ${IMAGE} ]]; then
		if [[ -f BASE.wbfs ]]; then
			x=1
			IMAGE=BASE.wbfs
		elif [[ -f BASE.iso ]]; then
			x=1
			IMAGE=BASE.iso
		fi
	fi
	echo "*** >> status: ${x}"

}

check_input_image_nsmb () {

	x=0
	if [[ ! ${IMAGE} ]]; then
		if test -f SMN?01.wbfs; then
			x=1
			IMAGE=SMN?01.wbfs
		elif test -f SMN?01.iso; then
			x=2
			IMAGE=SMN?01.iso
		elif test -f "${PATCHIMAGE_WBFS_DIR}"/SMN?01.iso; then
			x=3
			IMAGE="${PATCHIMAGE_WBFS_DIR}"/SMN?01.iso
		elif test -f "${PATCHIMAGE_WBFS_DIR}"/SMN?01.wbfs; then
			x=4
			IMAGE="${PATCHIMAGE_WBFS_DIR}"/SMN?01.wbfs
		else
			echo -e "please specify image to use with --iso=<path>"
			exit 15
		fi
	fi
	echo "*** >> status: ${x}"

}

check_input_image_kirby () {

	x=0
	if [[ ! ${IMAGE} ]]; then
		if test -f SMN?01.wbfs; then
			x=1
			IMAGE=SMN?01.wbfs
		elif test -f SMN?01.iso; then
			x=2
			IMAGE=SMN?01.iso
		elif test -f "${PATCHIMAGE_WBFS_DIR}"/SUK?01.iso; then
			x=3
			IMAGE="${PATCHIMAGE_WBFS_DIR}"/SUK?01.iso
		elif test -f "${PATCHIMAGE_WBFS_DIR}"/SUK?01.wbfs; then
			x=4
			IMAGE="${PATCHIMAGE_WBFS_DIR}"/SUK?01.wbfs
		else
			echo -e "please specify image to use with --iso=<path>"
			exit 15
		fi
	fi
	echo "*** >> status: ${x}"

}

check_input_image_mkwiimm () {

	x=0
	if [[ ! ${IMAGE} ]]; then
		if test -f RMC?01.wbfs; then
			x=1
			IMAGE=RMC?01.wbfs
		elif test -f RMC?01.iso; then
			x=2
			IMAGE=RMC?01.iso
		elif test -f "${PATCHIMAGE_WBFS_DIR}"/RMC?01.iso; then
			x=3
			IMAGE="${PATCHIMAGE_WBFS_DIR}"/RMC?01.iso
		elif test -f "${PATCHIMAGE_WBFS_DIR}"/RMC?01.wbfs; then
			x=4
			IMAGE="${PATCHIMAGE_WBFS_DIR}"/RMC?01.wbfs
		else
			echo -e "please specify image to use with --iso=<path>"
			exit 15
		fi
	fi
	echo "*** >> status: ${x}"

}

check_input_rom () {

	x=5
	if [[ ! ${CXI} ]]; then
		CXI=$(find . -name ${CXI_MASK} | sed -e 's,./,,')
		if [[ -f ${CXI} ]]; then
			x=6
			CXI=${CXI}
			RFS=${ROMFS}
		else
			CXI=$(find ${PATCHIMAGE_3DS_DIR} -name ${CXI_MASK})
			if [[ -f ${CXI} ]]; then
				x=7
				CXI=${CXI}
				RFS=${ROMFS}
			else
				echo -e "error: could not find suitable ROM, specify using --rom"
				exit 15
			fi
		fi
	fi
	echo "*** >> status: ${x}"
}

show_nsmb_db () {

	ID1=${1:0:3}
	ID2=${1:4:2}
	gawk -F \: "/^${ID1}\*${ID2}/"'{print $2}' \
		< "${PATCHIMAGE_SCRIPT_DIR}"/nsmbw.db || echo "** Unknown **"

}

show_mkwiimm_db () {

	ID=${1:4:2}
	[[ ${ID} == [0-9][0-9] ]] && gawk -F \: "/^${ID}/"'{print $2}' \
		< "${PATCHIMAGE_SCRIPT_DIR}"/mkwiimm.db || echo "** Unknown **"

}

ask_input_image_mkwiimm () {

	echo "Choose Mario Kart Wii Image to modify

	ALL		patch all images"

	for image in ${1}/RMC???.{iso,wbfs}; do
		if [[ -e ${image} ]]; then
			echo "	${image##*/}	$(show_mkwiimm_db ${image##*/})"
		fi
	done

	echo ""

}

ask_input_image_nsmb () {

	echo "Choose New Super Mario Bros. Wii Image to modify

	ALL		patch all images"

	for image in ${1}/SMN???.{iso,wbfs} ${1}/SLF???.{iso,wbfs} ${1}/SMM???.{iso,wbfs} ${1}/SMV???.{iso,wbfs} ${1}/MRR???.{iso,wbfs}; do
		if [[ -e ${image} ]]; then
			echo "	${image##*/}	$(show_nsmb_db ${image##*/})"
		fi
	done

	echo ""

}

show_titles_db () {

	ID=${1/.*}
	gawk -F \: "/^${ID}/"'{print $2}' \
		< "${PATCHIMAGE_SCRIPT_DIR}"/titles.db || echo "** Unknown **"

}

check_wfc () {

	ID=${1/.*}
	if [[ $(grep ${ID} "${PATCHIMAGE_SCRIPT_DIR}"/wfc.db) ]]; then
		echo TRUE
	else
		echo FALSE
	fi

}

ask_input_image_wiimmfi () {

	echo "Choose Wii Game Image to wiimmfi"

	for image in ${1}/*.{iso,wbfs}; do
		if [[ -e ${image} && ! ${image} == "*/RMC*" && $(check_wfc ${image##*/}) == TRUE ]]; then
			echo "	${image##*/}	$(show_titles_db ${image##*/})"
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
			${UNP} "${PWD}/${RIIVOLUTION_ZIP}" "${UNP_EXTRA_ARGS}" >/dev/null || exit 63
		elif [[ -f "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}" ]]; then
			echo "*** >> unpacking"
			x=3
			${UNP} "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}" "${UNP_EXTRA_ARGS}" >/dev/null || exit 63
		elif [[ ${PATCHIMAGE_RIIVOLUTION_DOWNLOAD} == "TRUE" ]]; then
			x=4
			if [[ ${DOWNLOAD_LINK} == *docs.google* ]]; then
				if [[ ! -f "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}" ]]; then
					x=5
					echo "*** >> downloading"
					${GDOWN} "${DOWNLOAD_LINK}" "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"__tmp >/dev/null || exit 57
					mv "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"__tmp "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"
					echo "*** >> unpacking"
					${UNP} "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}" "${UNP_EXTRA_ARGS}" >/dev/null || exit 63
				fi
			elif [[ ${DOWNLOAD_LINK} ]]; then
				if [[ ! -f "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}" ]]; then
					x=5
					echo "*** >> downloading"
					wget --no-check-certificate "${DOWNLOAD_LINK}" -O "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"__tmp >/dev/null || exit 57
					mv "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"__tmp "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}"
					echo "*** >> unpacking"
					${UNP} "${PATCHIMAGE_RIIVOLUTION_DIR}/${RIIVOLUTION_ZIP}" "${UNP_EXTRA_ARGS}" >/dev/null || exit 63
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

	alt=$(echo $1 | sed s/./E/4)

	for path in cover cover3D coverfull disc disccustom; do
		if [[ ! -f "${PATCHIMAGE_COVER_DIR}"/${1}_${path}.png ]]; then
			wget -O "${PATCHIMAGE_COVER_DIR}"/${1}_${path}.png \
				http://art.gametdb.com/wii/${path}/EN/${1}.png &>/dev/null \
				|| rm "${PATCHIMAGE_COVER_DIR}"/${1}_${path}.png

			if [[ ! -f "${PATCHIMAGE_COVER_DIR}"/${1}_${path}.png ]]; then
				wget -O "${PATCHIMAGE_COVER_DIR}"/${1}_${path}.png \
					http://art.gametdb.com/wii/${path}/US/${alt}.png &>/dev/null \
				|| rm "${PATCHIMAGE_COVER_DIR}"/${1}_${path}.png
			fi

			[[ ! -f "${PATCHIMAGE_COVER_DIR}"/${1}_${path}.png ]] && \
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

		--iso* )
			ISO_PATH=${1/*=}
			ISO_EXT=${ISO_PATH//*./}

			if [[ -e "${ISO_PATH}" ]]; then
				ln -sf "${ISO_PATH}" BASE.${ISO_EXT}
				IMAGE=BASE.${ISO_EXT}
			else
				echo -e "ISO not found"
				exit 15
			fi
		;;

		--rom* )
			ROM_PATH=${1/*=}
			ROM_EXT=${ROM_PATH//*./}

			if [[ -e "${ROM_PATH}" ]]; then
				ln -sf "${ROM_PATH}" BASE.${ROM_EXT}
				IMAGE=BASE.${ROM_EXT}
			else
				echo -e "ROM not found"
				exit 15
			fi
		;;

		--riivolution* )
			RIIVOLUTION=${1/*=}
			if [[ -e "${RIIVOLUTION}" ]]; then
				${UNP} "${RIIVOLUTION}" >/dev/null
			else
				echo -e "Riivolution patch ${RIIVOLUTION} not found."
				exit 21
			fi
		;;

		--patch*  )
			PATCH=${1/*=}
			if [[ -e "${PATCH}" ]]; then
				${UNP} "${PATCH}" >/dev/null
			else
				echo -e "PATCH patch ${PATCH} not found."
				exit 21
			fi
		;;

		--customid* )
			CUSTOMID=${1/*=}
			if [[ ${#CUSTOMID} != 6 ]]; then
				echo -e "CustomID ${CUSTOMID} needs to have 6 digits"
				exit 39
			fi
		;;

		--download )
			PATCHIMAGE_RIIVOLUTION_DOWNLOAD=TRUE
		;;

		--soundtrack )
			PATCHIMAGE_SOUNDTRACK_DOWNLOAD=TRUE
		;;

		--only-soundtrack )
			PATCHIMAGE_SOUNDTRACK_DOWNLOAD=TRUE
			ONLY_SOUNDTRACK=TRUE
		;;

		--version=* )
			VERSION=${1/*=}
			case ${VERSION} in
				EURv1 )
					REG_LETTER=P
				;;

				EURv2 )
					REG_LETTER=P
				;;

				USAv1 )
					REG_LETTER=E
				;;

				USAv2 )
					REG_LETTER=E
				;;

				JPNv1 )
					REG_LETTER=J
				;;

				* )
					echo -e "unrecognized game version: ${VERSION}"
					exit 27
				;;
			esac
		;;

		--sharesave )
			PATCHIMAGE_SHARE_SAVE=TRUE
		;;

		--game* )
			GAME=${1/*=}
		;;

		--covers* )
			PATCHIMAGE_COVER_DOWNLOAD=TRUE
		;;

		--only-covers* )
			PATCHIMAGE_COVER_DOWNLOAD=TRUE
			download_covers ${1/*=}
			exit 0
		;;

		--banner=* )
			BANNER=${1/*=}
			BANNER_EXT=${BANNER//*./}
			if [[ ${BANNER_EXT} != "bnr" ]]; then
				echo "given banner (${BANNER}) is not a .bnr file!"
				exit 33
			fi
		;;

		--download-banner )
			PATCHIMAGE_BANNER_DOWNLOAD=TRUE
		;;

		--xdelta=* )
			XDELTA_PATH=${1/*=}
		;;

		--cpk=* )
			CPK_PATH=${1/*=}
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
	xcount=$(($xcount+1))
done

}
