#!/bin/bash


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

apply_banner () {

	if [[ ${BANNER} != "" ]]; then
		if [[ -f ${BANNER} ]]; then
			cp "${BANNER}" "${BANNER_LOCATION}"
		else
			echo "specified banner ${BANNER} does not exist, not modifying"
		fi
	fi

}
