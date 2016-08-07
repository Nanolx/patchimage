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
	echo "*** 3) check_riivolution_patch"
	check_riivolution_patch

	echo "*** 4) extract game"
	${WIT} extract "${IMAGE}" "${WORKDIR}" --psel=DATA -q || exit 51

	echo "*** 5) detect_game_version"
	detect_game_version
	rm -f "${GAMEID}".wbfs "${CUSTOMID}".wbfs
	echo "*** 6) place_files"
	place_files || exit 45

	echo "*** 7) download_banner"
	download_banner
	echo "*** 8) apply_banner"
	apply_banner

	echo "*** 9) dolpatch"
	dolpatch

	if [[ ${CUSTOMID} ]]; then
		GAMEID="${CUSTOMID}"
	fi

	if [[ ${PATCHIMAGE_SHARE_SAVE} == "TRUE" ]]; then
		TMD_OPTS=""
	else
		TMD_OPTS="--tt-id=K"
	fi

	echo "*** 10) rebuild and store game"
	"${WIT}" cp -o -q --disc-id="${GAMEID}" "${TMD_OPTS}" --name "${GAMENAME}" \
		-B "${WORKDIR}" "${PATCHIMAGE_GAME_DIR}"/"${GAMEID}".wbfs || exit 51

	echo "*** 12) remove workdir"
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

	if [[ -f ${PATCH} ]]; then
		ext="${ROM/*.}"
		cp "${ROM}" "${GAMENAME}.${ext}"
		"${IPS}" a "${PATCH}" "${GAMENAME}.${ext}" || exit 51
	else
		echo -e "error: patch (${PATCH}) could not be found"
		exit 21
	fi
}

patchimage_ppf () {
	show_notes
	check_input_rom

	if [[ -f ${PATCH} ]]; then
		ext="${ROM/*.}"
		cp "${ROM}" "${GAMENAME}.${ext}"
		"${PPF}" a "${PATCH}" "${GAMENAME}.${ext}" || exit 51
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

	echo "*** 4) unpack_3dsromfs"
	unpack_3dsromfs romfs.bin || exit 51

	echo "*** 5) patch_romfs"
	patch_romfs

	echo "*** 6) repack_romfs"
	repack_3dsromfs romfs/ "${ROMFS}" || exit 51

	echo "*** 7) storing game"
	mv "${ROMFS}" "${PATCHIMAGE_ROM_DIR}"

	echo "
	*** succesfully created new romfs as \"${PATCHIMAGE_ROM_DIR}/${ROMFS}\"
	"

	[[ ${DATA} ]] && echo \
	"	>> for Hans Banners / Launchers, place all files from

		$(readlink -m "${DATA}")

	   into the root of your sd card
	"

	echo "*** 8) remove workdir"
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

		NSMB1 | NewerSMB )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/newersmb.sh"
		;;

		NSMB2 | NewerSummerSun )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/newersummersun.sh"
		;;

		NSMB3 | AnotherSMB )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/anothersmb.sh"
		;;

		NSMB4 | HolidaySpecial )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/newerholiday.sh"
		;;

		NSMB5 | Cannon )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/cannon.sh"
		;;

		NSMB6 | BowserWorld )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/epicbowserworld.sh"
		;;

		NSMB7 | KoopaCountry )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/koopacountry.sh"
		;;

		NSMB8 | NewSuperMarioBros4 )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/nsmbw4.sh"
		;;

		NSMB9 | RetroRemix )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/retroremix.sh"
		;;

		NSMB10 | WinterMoon )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/wintermoon.sh"
		;;

		NSMB11 | NSMBW3 )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/nsmbw3.sh"
		;;

		NSMB12 | Vacation )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/summervacation.sh"
		;;

		NSMB13 | ASLM )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/awesomersuperluigi.sh"
		;;

		NSMB14 | Sykland )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/skyland.sh"
		;;

		NSMB15 | RVLution )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/rvlution.sh"
		;;

		NSMB16 | Midi )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/midissupermariowii.sh"
		;;

		NSMB17 | DarkUmbra )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/darkumbrasmb.sh"
		;;

		NSMB18 | NewerApocalypse )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/newerapocalypse.sh"
		;;

		NSMB19 | LuigisSuperYoshiBros )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/luigissuperyoshibros.sh"
		;;

		NSMB20 | NewerFallingLeaf )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/newerfallingleaf.sh"
		;;

		NSMB21 | DevilMarioWinterSpecial )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/devilmariowinterspecial.sh"
		;;

		NSMB22 | NewSMBWOtherWorld )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/newsmbwotherworld.sh"
		;;

		NSMB23 | TheLegendOfYoshi )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/thelegendofyoshi.sh"
		;;

		NSMB24 | RemixedSuperMarioBros )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/remixedsupermariobroswii.sh"
		;;

		NSMB25 | GhostlySuperGhostBoos )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/ghostlysuperghostbooswii.sh"
		;;

		NSMB26 | RevisedSuperMarioBros )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/revisedsupermariobroswii.sh"
		;;

		NSMB99 | NSMBWCharacters )
			source "${PATCHIMAGE_SCRIPT_DIR}/nsmbw/nsmbw_characters.sh"
		;;

		MKW1 | Wiimmfi )
			source "${PATCHIMAGE_SCRIPT_DIR}/mkwii/wiimmfi.sh"
		;;

		MKW2 | Wiimmpatch )
			source "${PATCHIMAGE_SCRIPT_DIR}/wiimmfi_generic.sh"
		;;

		MKW3 | Mkwiimm )
			source "${PATCHIMAGE_SCRIPT_DIR}/mkwii/mkwiimm.sh"
		;;

		MKW4 | MkwiimmItems )
			source "${PATCHIMAGE_SCRIPT_DIR}/mkwii/mkwiimm_items.sh"
		;;

		MKW5 | MkwiimmFonts )
			source "${PATCHIMAGE_SCRIPT_DIR}/mkwii/mkwiimm_fonts.sh"
		;;

		MKW6 | MkwiimmKarts )
			source "${PATCHIMAGE_SCRIPT_DIR}/mkwii/mkwiimm_karts.sh"
		;;

		KAW1 | Kirby )
			source "${PATCHIMAGE_SCRIPT_DIR}/kirbywii.sh"
		;;

		TMS1 | TokyoMirageSessions )
			source "${PATCHIMAGE_SCRIPT_DIR}/tokyomiragesessionsfe.sh"
		;;

		PKMN1 | NeoX )
			source "${PATCHIMAGE_SCRIPT_DIR}/pokemon/pokemonneox.sh"
		;;

		PKMN2 | NeoY )
			source "${PATCHIMAGE_SCRIPT_DIR}/pokemon/pokemonneoy.sh"
		;;

		PKMN3 | RutileRuby )
			source "${PATCHIMAGE_SCRIPT_DIR}/pokemon/pokemonrutileruby.sh"
		;;

		PKMN4 | AlphaSapphire )
			source "${PATCHIMAGE_SCRIPT_DIR}/pokemon/pokemonstarsapphire.sh"
		;;

		PKMN5 | EternalX )
			source "${PATCHIMAGE_SCRIPT_DIR}/pokemon/pokemoneternalx.sh"
		;;

		PKMN6 | WiltingY )
			source "${PATCHIMAGE_SCRIPT_DIR}/pokemon/pokemonwiltingy.sh"
		;;

		PKMN7 | RisingRuby )
			source "${PATCHIMAGE_SCRIPT_DIR}/pokemon/pokemonrisingruby.sh"
		;;

		PKMN8 | SinkingSapphire )
			source "${PATCHIMAGE_SCRIPT_DIR}/pokemon/pokemonsinkingsapphire.sh"
		;;

		BSECU | BravelySecondUncensored )
			source "${PATCHIMAGE_SCRIPT_DIR}/bravelyseconduncensored.sh"
		;;

		ZEL1 | ParallelWorlds )
			source "${PATCHIMAGE_SCRIPT_DIR}/parallelworlds.sh"
		;;

		* )
			echo -e "specified Game ${game} not recognized"
			continue
		;;

	esac

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
