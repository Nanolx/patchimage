#!/bin/bash

ROM_MASK="*[Ll]ink*[Pp]ast*smc"
DOWNLOAD_LINK="https://sites.google.com/site/zeldaparallelworlds/lozpw110.rar"
DOWNLOAD_ZIP="lozpw110.rar"
PATCH="ZPW_1.1.ips"
GAMENAME="The Legend of Zelda - Parallel Worlds"
GAME_TYPE=IPS

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Parallel Worlds is a complete overhaul of A Link to the Past,
new world, new dungeons... and much more difficult.

Source:			https://sites.google.com/site/zeldaparallelworlds/
Base ROM:		The Legend of Zelda: A Link to the Past
Supported Versions:	US
************************************************"

}

check_input_rom () {

	if [[ ! ${ROM} ]]; then
		ROM=$(find . -name ${ROM_MASK} | sed -e 's,./,,')
		if [[ ${ROM} == "" ]]; then
			echo -e "error: could not find suitable ROM, specify using --rom"
			exit 1
		fi
	fi

}
