#!/bin/bash

GAME_TYPE="WII_GENERIC"
GAME_NAME="Kirby's Adventure Wii"
WBFS_MASK="SUK[PUJ]01"
PATH_HERO="files/g3d/step/chara/hero/"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Base Image:		Kirby's Adventure Wii (SUK?01)
Supported Versions:	EUR, JAP, USA
************************************************"

}

check_input_image_special () {

	check_input_image

}

exchange_kirby () {

	cp workdir/${PATH_HERO}/kirby/base/${1}.brres.cmp{,_tmp}
	cp workdir/${PATH_HERO}/kirby/base/Pink.brres.cmp \
		workdir/${PATH_HERO}/kirby/base/${1}.brres.cmp
	mv workdir/${PATH_HERO}/kirby/base/${1}.brres.cmp_tmp \
		workdir/${PATH_HERO}/kirby/base/Pink.brres.cmp

}

exchange_hero () {

	cp workdir/${PATH_HERO}/${1}/base/Default.brres.cmp \
		workdir/${PATH_HERO}/kirby/base/Pink.brres.cmp_temp
	cp workdir/${PATH_HERO}/kirby/base/Pink.brres.cmp \
		workdir/${PATH_HERO}/${1}/base/Default.brres.cmp
	mv workdir/${PATH_HERO}/kirby/base/Pink.brres.cmp{_temp,}
	for brres in workdir/${PATH_HERO}/${1}/normal/*.cmp ; do
		xfile=${brres##*/}
		xpath=${brres%/*}
		cp ${brres} workdir/${PATH_HERO}/kirby/normal/${xfile}_temp
		cp workdir/${PATH_HERO}/kirby/normal/${xfile} \
			workdir/${PATH_HERO}/${1}/normal/
		mv workdir/${PATH_HERO}/kirby/normal/${xfile}{_temp,}
	done

}

pi_action () {

	echo "Choose character for first player

1	Kirby (blue)
2	Kirby (yellow)
3	Kirby (green)

*** options 4 to 6 may crash the game upon start ***
4	King DeDeDe
5	MetaKnight
6	WaddleDee

7	Restore to original

type in an number."
read ID

	[[ ${ID} != [0-9] ]] && echo "invalid number provided from user-input." && exit 1

	rm -rf workdir

	echo -e "\n*** 3) extracting image"
	${WIT} extract ${IMAGE} --psel=data -d workdir -q || exit 51

	if [[ ! -d "${PATCHIMAGE_RIIVOLUTION_DIR}"/hero/ ]]; then
		echo "*** 4) this is the first run, so backing up all characters
(in ${PATCHIMAGE_RIIVOLUTION_DIR}) for future customizations"
		cp -r workdir/${PATH_HERO}/ "${PATCHIMAGE_RIIVOLUTION_DIR}"
	else
		echo "*** 4) restoring original characters"
		cp -r "${PATCHIMAGE_RIIVOLUTION_DIR}"/hero/* workdir/${PATH_HERO}/
	fi

	REG=$(gawk '/^SUK/{print $3}' <(${WIT} ll ${IMAGE}))

	case $REG in
		PAL)	REG=P	;;
		NTSC-J)	REG=J	;;
		NTSC-U)	REG=E	;;
	esac

	[[ ${ID} != 7 ]] && echo "*** 5) exchanging characters"
	case ${ID} in
		1)	exchange_kirby Blue	;;
		2)	exchange_kirby Yellow	;;
		3)	exchange_kirby Green	;;
		4)	exchange_hero dedede	;;
		5)	exchange_hero meta	;;
		6)	exchange_hero dee	;;
	esac

	echo "*** 6) rebuilding the game "
	echo "       (storing game in ${PATCHIMAGE_GAME_DIR}/SUK${REG}01.wbfs)"
	${WIT} cp -o -q -B workdir ${PATCHIMAGE_GAME_DIR}/SUK${REG}01.wbfs || exit 51

	rm -rf workdir

}
