#!/bin/bash

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
