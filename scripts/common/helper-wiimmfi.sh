#!/bin/bash

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
		if [[ -f ${image} && ! ${image} == "*/RMC*" && $(check_wfc "${image##*/}") == TRUE ]]; then
			echo "	${image##*/}	$(show_titles_db "${image##*/}")"
		fi
	done

	echo ""

}
