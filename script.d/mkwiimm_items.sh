#!/bin/bash

GAME_TYPE="MKWIIMM"
GAME_NAME="Mario Kart Wiimm"
ITEMS_BASE="http://riivolution.nanolx.org/mkwiimm_items"
CSZS="files/Race/Common.szs"
CSZD="files/Race/Common.d"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Custom Mario Kart Wii

Source:			http://wiiki.wii-homebrew.com/Wiimms_Mario_Kart_Fun
Base Image:		Mario Kart Wii (RMC?01)
Supported Versions:	EUR, JAP, USA
************************************************"

}

check_input_image_special () {

	check_input_image_mkwiimm
	ask_input_image_mkwiimm ${IMAGE%/*}
	echo -e "type RMC???.wbfs:\n"
	read ID

	if [[ ! -f ${IMAGE%/*}/${ID} ]]; then
		echo "wrong id from user-input given."
		exit 1
	fi

}

items=( "ballon.brres:Balloon (Battle Object)"
"big_kinoko.brres:Mega Mushroom (Item)"
"bomb.brres:Bob-omb (Item)"
"gesso.brres:Blooper (Item)"
"kart_killer.brres:Bullet Bill (In Use)"
"item_killer.brres:Bullet Bill (Item, when dropped)"
"jugem_reverse.brres:Lakitus Wrong Way Sign"
"jugemu.brres:Lakitu"
"jugemu_signal.brres:Lakitus Countdown Lights"
"kinoko.brres:Super Mushroom (Item) "
"koura_green.brres:Green Shell (Item)"
"koura_red.brres:Red Shell (Item)"
"kumo.brres:Thundercloud (Item)"
"kinoko_p.brres:Golden Mushroom (Item, when dropped)"
"pow_bloc.brres:Pow Block (Item, when dropped)"
"pow_bloc_plane.brres:Pow Block (Item, in use) "
"thunder.brres:Lightning (Item, When dropped)"
"togezo_koura.brres:Spiny Shell (Item)" )

ask_items () {

	if [[ -f ${HOME}/.patchimage.choice ]]; then
		echo "Your choices from last time can be re-used."
		echo "y (yes) or n (no)"
		read choice

		if [[ ${choice} == y ]]; then
			source ${HOME}/.patchimage.choice
		fi
	fi

	if [[ ${choosenitems[@]} == "" ]]; then

		for item in "${items[@]}"; do
			slot=${item/:*}
			desc=${item/*:}

			echo -e "\n\nChoose item for ${desc}

orig		Original item"

			gawk -F \: "/${slot}/"'{print $1 "\t" $3}' < ${PATCHIMAGE_SCRIPT_DIR}/mkwiimm_items.db
			echo -e "\ntype orig or ???.brres"
			read slotid
			echo "<<<<<<>>>>>>"
			choosenitems=( ${choosenitems[@]} ${slot}:${slotid} )
		done

		echo ${choosenitems[@]}
		echo "choosenitems=( ${choosenitems[@]} )" > ${HOME}/.patchimage.choice
	fi

}

download_items () {

	for item in ${choosenitems[@]}; do
		id=${item/*:}
		if [[ ! -f ${PATCHIMAGE_RIIVOLUTION_DIR}/${id} ]]; then
			wget -O ${PATCHIMAGE_RIIVOLUTION_DIR}/${id} \
				${ITEMS_BASE}/${id} &>/dev/null \
				|| (echo "download of ${id} failed." \
				&& rm ${PATCHIMAGE_RIIVOLUTION_DIR}/${id})
		fi
	done

}

download_wiimm () {

	ask_items
	download_items

}

build_mkwiimm () {

	rm -rf workdir
	echo "*** 5) extracting image"
	${WIT} extract ${IMAGE%/*}/${ID} workdir -q || exit 51

	if [[ ! -f "${PATCHIMAGE_RIIVOLUTION_DIR}"/Common.szs_${ID/.*} ]]; then
		echo "*** 6) this is the first run, so backing up common.szs
(in ${PATCHIMAGE_RIIVOLUTION_DIR}) for future customizations"
		cp workdir/${CSZS} "${PATCHIMAGE_RIIVOLUTION_DIR}"/Common.szs_${ID/.*}
	else
		echo "*** 6) restoring original common.szs"
		cp "${PATCHIMAGE_RIIVOLUTION_DIR}"/Common.szs_${ID/.*} workdir/${CSZS}
	fi

	echo "*** 7) replacing items"
	rm -rf workdir/${CSZD}
	${SZS} extract workdir/${CSZS} -q || \
		( echo "szs caught an erro extracting common.szs" && exit 51 )
	for item in ${choosenitems[@]}; do
		slot=${item/:*}
		newi=${item/*:}
		if [[ -f ${PATCHIMAGE_RIIVOLUTION_DIR}/${newi} ]]; then
			cp ${PATCHIMAGE_RIIVOLUTION_DIR}/${newi} \
				workdir/${CSZD}/${slot}
		fi
	done
	${SZS} create -o workdir/${CSZD} -q || \
		( echo "szs caught an error rebuilding common.szs" && exit 51 )
	rm -rf workdir/${CSZD}

	echo "*** 8) rebuilding game"
	echo "       (storing game in ${PATCHIMAGE_GAME_DIR}/${ID})"
	${WIT} cp -o -q -B workdir ${PATCHIMAGE_GAME_DIR}/${ID} || exit 51

	rm -rf workdir

}

patch_wiimm () {

	build_mkwiimm

}
