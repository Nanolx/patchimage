#!/bin/bash

GAME_TYPE="WII_GENERIC"
GAME_NAME="Kirby's Adventure Wii"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Base Image:		Kirby's Adventure Wii (SUK?01)
Supported Versions:	EUR, JAP, USA
************************************************"

}

PATH_HERO="files/g3d/step/chara/hero/"

pi_action () {

	check_input_image_kirby

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

	echo -e "\n*** 3) extracting images"
	${WIT} extract ${IMAGE} --psel=data -d workdir -q || exit 51

	if [[ ! -d "${PATCHIMAGE_RIIVOLUTION_DIR}"/hero/ ]]; then
		echo -e "\n*** 4) this is the first run, so backing up all characters
(in ${PATCHIMAGE_RIIVOLUTION_DIR}) for future customizations"
		cp -r workdir/${PATH_HERO}/ "${PATCHIMAGE_RIIVOLUTION_DIR}"
	else
		echo -e "\n*** 4) restoring original characters"
		cp -r "${PATCHIMAGE_RIIVOLUTION_DIR}"/hero/* workdir/${PATH_HERO}/
	fi

	REG=$(gawk '/^SUK/{print $3}' <(wit ll ${IMAGE}))

	case $REG in
		PAL)	REG=P	;;
		NTSC-J)	REG=J	;;
		NTSC-U)	REG=E	;;
	esac

	[[ ${ID} != 7 ]] && echo "*** 5) exchanging characters"
	case ${ID} in
		1)	cp workdir/${PATH_HERO}/kirby/base/Blue.brres.cmp{,_tmp}
			cp workdir/${PATH_HERO}/kirby/base/{Pink,Blue}.brres.cmp
			mv workdir/${PATH_HERO}/kirby/base/{Blue.brres.cmp_tmp,Pink.brres.cmp}
		;;

		2)	cp workdir/${PATH_HERO}/kirby/base/Yellow.brres.cmp{,_tmp}
			cp workdir/${PATH_HERO}/kirby/base/{Pink,Yellow}.brres.cmp
			mv workdir/${PATH_HERO}/kirby/base/{Yellow.brres.cmp_tmp,Pink.brres.cmp}
		;;

		3)	cp workdir/${PATH_HERO}/kirby/base/Green.brres.cmp{,_tmp}
			cp workdir/${PATH_HERO}/kirby/base/{Pink,Green}.brres.cmp
			mv workdir/${PATH_HERO}/kirby/base/{Green.brres.cmp_tmp,Pink.brres.cmp}
		;;

		4)	cp workdir/${PATH_HERO}/dedede/base/Default.brres.cmp \
				workdir/${PATH_HERO}/kirby/base/Pink.brres.cmp
			cp workdir/${PATH_HERO}/dedede/normal/*.cmp \
				workdir/${PATH_HERO}/kirby/normal/
		;;

		5)	cp workdir/${PATH_HERO}/meta/base/Default.brres.cmp \
				workdir/${PATH_HERO}/kirby/base/Pink.brres.cmp
			cp workdir/${PATH_HERO}/meta/normal/*.cmp \
				workdir/${PATH_HERO}/kirby/normal/
		;;

		6)	cp workdir/${PATH_HERO}/de/base/Default.brres.cmp \
				workdir/${PATH_HERO}/kirby/base/Pink.brres.cmp
			cp workdir/${PATH_HERO}/dee/normal/*.cmp \
				workdir/${PATH_HERO}/kirby/normal/
		;;
	esac

	echo "*** 6) rebuilding the game"
	${WIT} cp -q -B workdir SUK${REG}01.wbfs || exit 51

	if [[ -d ${PATCHIMAGE_GAME_DIR} && ${PATCHIMAGE_GAME_DIR} != ${PWD} ]]; then
		echo "*** 7) storing game in ${PATCHIMAGE_GAME_DIR}"
		mv SUK${REG}01.wbfs "${PATCHIMAGE_GAME_DIR}"/
	fi

	rm -rf workdir

}
