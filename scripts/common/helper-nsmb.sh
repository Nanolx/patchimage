#!/bin/bash

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

show_nsmb_db () {

	ID1=${1:0:3}
	ID2=${1:4:2}
	gawk -F : "/^${ID1}\*${ID2}/"'{print $2}' \
		< "${PATCHIMAGE_DATABASE_DIR}"/nsmbw.db || echo "** Unknown **"

}

ask_input_image_nsmb () {

	echo "Choose New Super Mario Bros. Wii Image to modify

	ALL		patch all images"

	for image in "${PWD}"/SMN???.{iso,wbfs} \
		"${PWD}"/SLF???.{iso,wbfs} \
		"${PWD}"/SLB???.{iso,wbfs} \
		"${PWD}"/SMM???.{iso,wbfs} \
		"${PWD}"/SMV???.{iso,wbfs} \
		"${PWD}"/MRR???.{iso,wbfs} \
		"${PATCHIMAGE_WBFS_DIR}"/SMN???.{iso,wbfs} \
		"${PATCHIMAGE_WBFS_DIR}"/SLF???.{iso,wbfs} \
		"${PATCHIMAGE_WBFS_DIR}"/SLB???.{iso,wbfs} \
		"${PATCHIMAGE_WBFS_DIR}"/SMM???.{iso,wbfs} \
		"${PATCHIMAGE_WBFS_DIR}"/SMV???.{iso,wbfs} \
		"${PATCHIMAGE_WBFS_DIR}"/MRR???.{iso,wbfs}; do
		[[ -f ${image} ]] && echo "	${image##*/}	$(show_nsmb_db "${image##*/}")"
	done

	echo ""

}
