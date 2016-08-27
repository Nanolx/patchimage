#!/bin/bash

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
