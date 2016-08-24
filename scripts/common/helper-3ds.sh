#!/bin/bash

unpack_3dsrom () {

	${CTRTOOL} -p --romfs=romfs.bin "${1}" &>/dev/null

}

unpack_3dsromfs () {

	${CTRTOOL} -t romfs --romfsdir=romfs "${1}" &>/dev/null

}

repack_3dsromfs () {

	${FDSTOOL} -ctf romfs "${2}" --romfs-dir "${1}" &>/dev/null

}
