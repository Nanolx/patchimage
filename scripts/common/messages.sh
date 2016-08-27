#!/bin/bash

MESSAGE_HEADER="************************************************
patchimage v${PATCHIMAGE_VERSION}"

MESSAGE_HEADER_LIST="ID	Short Name		Full Name"

SUPPORTED_GAMES_NSMB="<<<<<< New Super Mario Bros. Wii >>>>>>
NSMB1	NewerSMB		NewerSMB
NSMB2	NewerSummerSun		Newer Summer Sun
NSMB3	AnotherSMB		AnotherSMB
NSMB4	HolidaySpecial		Newer: Holiday Special
NSMB5	Cannon			Cannon Super Mario Bros.
NSMB6	BowserWorld		Epic Super Bowser World
NSMB7	KoopaCountry		Koopa Country
NSMB8	NewSuperMarioBros4	New Super Mario Bros. 4
NSMB9	RetroRemix		New Super Mario Bros. Wii Retro Remix
NSMB10	WinterMoon		Super Mario: Mushroom Adventure PLUS - Winter Moon
NSMB11	NSMBW3			NSMBW3: The Final Levels
NSMB12	Vacation		Super Mario Vacation
NSMB14	Sykland			Super Mario Skyland
NSMB15	RVLution		RVLution Wii (NewSMB Mod)
NSMB16	Midi			Midi's Super Mario Wii (Just A Little Adventure)
NSMB17	DarkUmbra		DarkUmbra SMB Anniversary Edition
NSMB18	NewerApocalypse		Newer Apocalypse
NSMB19	LuigisSuperYoshiBros	Luigi's Super Yoshi Bros.
NSMB20	NewerFallingLeaf	Newer: Falling Leaf
NSMB21	DevilMarioWinterSpecial	Devil Mario Winter Special
NSMB22	NewSMBWOtherWorld	New Super Mario Bros. Wii - Other World
NSMB23	TheLegendOfYoshi	The Legend of Yoshi
NSMB24	RemixedSuperMarioBros	Remixed Super Mario Bros. Wii
NSMB25	GhostlySuperGhostBoos	Ghostly Super Ghost Boos. Wii
NSMB26	RevisedSuperMarioBros	Revised Super Mario Bros. Wii
NSMB27	MLGSuperLuigi		MLG Super Luigi Bros. Wii
NSMB28	Cliff			Cliff Super Mario Bros. Wii
NSMB29	Virtual			Challenging Super Mario Bros. Wii: Virtual Special

NSMB99	NSMBWCharacters		Customize Characters

NSMB_ALL			All Mods of New Super Mario Bros. Wii
"

SUPPORTED_GAMES_MKWIIMMFI="<<<<<< Mario Kart Wii / Wiimmfi >>>>>>
MKW1	Wiimmfi			Wiimfi Patcher. Patch Mario Kart to use Wiimm's server
MKW2	Wiimmpatch		Wiimfi Patcher. Patch WFC games to use Wiimm's server (exp)
MKW3	Mkwiimm			Mario Kart Wiimm. Custom Mario Kart Distribution
MKW4	MkwiimmItems		Custom Items. Replace items in the game
MKW5	MkwiimmFonts		Custom Font. Replace font in the game
MKW6	MkwiimmKarts		Custom Karts. Replace characters in the game
"

SUPPORTED_GAMES_KIRBY="<<<<<< Kirby's Adventure Wii >>>>>>
KAW1	Kirby			Change first player's character
"

SUPPORTED_GAMES_TOKYOMIRAGESESSIONSFE="<<<<<< Tokyo Mirage Sessions #FE >>>>>>
TMS1	TokyoMirageSessions	Uncensor US/EUR version
"

SUPPORTED_GAMES_POKEMON="<<<<<< Pokemon >>>>>>
PKMN1	NeoX			Pokemon Neo X
PKMN2	NeoY			Pokemon Neo Y
PKMN3	RutileRuby		Pokemon Rutile Ruby
PKMN4	StarSapphire		Pokemon Star Sapphire
PKMN5	EternalX		Pokemon Eternal X
PKMN6	WiltingY		Pokemon Wilting Y
PKMN7	RisingRuby		Pokemon Rising Ruby
PKMN8	SinkingSapphire		Pokemon Sinking Sapphire
PKMN9	DeltaEmeraldAS		Pokemon Delta Emerald (Alpha Sapphire)
PKMN10	RedRuby			Pokemon Red Ruby

PKMN_ALL			All Mods of Pokemon X, Y, Omega Ruy, Alpha Sapphire
PKMN_X				All Mods of Pokemon X
PKMN_Y				All Mods of Pokemon Y
PKMN_OR				All Mods of Pokemon Omega Ruby
PKMN_AS				All Mods of Pokemon Alpha Sapphire
"

SUPPORTED_GAMES_3DS="<<<<<< 3DS ROMS >>>>>>
BSECU	BravelySecondUncensored	Bravely Second Uncensored
"

SUPPORTED_GAMES_OTHER="<<<<<< ROMS >>>>>>
ZEL1	ParallelWorlds		The Legend of Zelda: Parallel Worlds
"

SUPPORTED_GAMES_ALL="${MESSAGE_HEADER}

${MESSAGE_HEADER_LIST}

${SUPPORTED_GAMES_NSMB}
${SUPPORTED_GAMES_MKWIIMMFI}
${SUPPORTED_GAMES_KIRBY}
${SUPPORTED_GAMES_TOKYOMIRAGESESSIONSFE}
${SUPPORTED_GAMES_POKEMON}
${SUPPORTED_GAMES_3DS}
${SUPPORTED_GAMES_OTHER}
${MESSAGE_HEADER_LIST}
"

REQUIREMENTS_NSMB="<<<<<< New Super Mario Bros. Wii >>>>>>

Required Image:
	SMN[+]01.iso or SMN[+]01.wbfs

where [+] is:
	E	for US version
	P	for EU/Ozeania version
	J	for JP version

NSMB1	NewerSMB		Newer_Mario_Wii.zip
NSMB2	NewerSummerSun		Newer_Summer_Sun.zip
NSMB3	AnotherSMB		Another_Super_Mario_Brothers_Wii_2.0.zip
NSMB4	HolidaySpecial		Newer_Super_Mario_Bros._Wii_HS.zip
NSMB5	Cannon			Cannon_Super_Mario_Bros._Wii_v1.1.zip
NSMB6	BowserWorld		Epic_Super_Bowser_World_v1.00.zip
NSMB7	KoopaCountry		Koopa country.rar
NSMB8	NewSuperMarioBros4	New Super Mario Bros. Wii 4 made by Orange-Yoshi3.3.zip
NSMB9	RetroRemix		Retro Remix.rar
NSMB10	WinterMoon		WinterMoon.rar
NSMB11	NSMBW3			NSMBW3_The final levels.zip
NSMB12	Vacation		Super_Mario_Vacation_v1.00.zip
NSMB14	Sykland			Skyland.zip
NSMB15	RVLution		RVLution Wii.zip
NSMB16	Midi			MSMBWii.zip
NSMB17	DarkUmbra		DUSMBAE Riivo Release Pack rev1.rar
NSMB18	NewerApocalypse		NewerApocalypse 1.0.zip
NSMB19	LuigisSuperYoshiBros	Luigis Super Yoshi Bros.zip
NSMB20	NewerFallingLeaf	Newer_FALLING_LEAF.zip
NSMB21	DevilMarioWinterSpecial	Devil Mario Winter Special collabo Frozen.zip
NSMB22	NewSMBWOtherWorld	Riivolution Other WorldR v1.02.zip
NSMB23	TheLegendOfYoshi	The Legend Of Yoshi.zip
NSMB24	RemixedSuperMarioBros	Remixed v1.5.zip
NSMB25	GhostlySuperGhostBoos	GSGBW v1.0.2.zip
NSMB26	RevisedSuperMarioBros	RSMBW Version 1.0.zip
NSMB27	MLGSuperLuigi		MLGLuigiWii.zip
NSMB28	Cliff			Cliff_Super_Mario_Brothers_Wiiv1.0.5.zip
NSMB29	Virtual			ChaSMBW_VrS_v0.2.zip

NSMB99	NSMBWCharacters		Alternative Character Files are supplied
"

REQUIREMENTS_MKWIIMMFI="<<<<<< Mario Kart Wii / Wiimmfi >>>>>>

Required Image:
	RMC[+]01.iso or RMC[+]01.wbfs

where [+] is:
	E	for US version
	P	for EU/Ozeania version
	J	for JP version

MKW1	Wiimmfi			Any iso or wbfs image of a Nintendo WFC game
MKW2	Wiimmpatch		Any iso or wbfs image of Wiimm's Mario Kart Wii
MKW3	Mkwiimm			Any Wiimm's Mario Kart Wii Distribution archive
MKW4	MkwiimmItems		Alternative Item Files are supplied
MKW5	MkwiimmFonts		Alternative Font Files are supplied
MKW6	MkwiimmKarts		Alternative Kart Files are supplied
"

REQUIREMENTS_TOKYOMIRAGESESSIONSFE="<<<<<< Tokyo Mirage Sessions #FE >>>>>>

Required files dumped with ddd in subfolder
	<dumpfolder>/vol/content/Pack :

	- pack_000_map.cpk
	- pack_010_character.cpk
	- pack_030_etc.cpk
	- pack_031_message.cpk
	- pack_050_movie.cpk
	- pack_999_etc_om.cpk
	- pack_999_lua.cpk

Required patch files:

	- patch_000_map.xdelta
	- patch_010_character.xdelta
	- patch_030_etc.xdelta
	- patch_031_message.xdelta
	- patch_050_movie.xdelta
	- patch_999_etc_om.xdelta
	- patch_999_lua.xdelta
"

REQUIREMENTS_KIRBY="<<<<<< Kirby's Adventure Wii >>>>>>
KAW1	Kirby			Character files are in-game
"

REQUIREMENTS_POKEMON="<<<<<< Pokemon X >>>>>>

required cxi ROM:

	0004000000055DD00.cxi

PKMN1	NeoX			Neo X and Y Files.rar
PKMN5	EternalX		Eternal X V1.3.zip

<<<<<< Pokemon Y >>>>>>

required cxi ROM:

	0004000000055EE00.cxi

PKMN2	NeoY			Neo X and Y Files.rar
PKMN6	WiltingY		Wilting Y V1.3.zip

<<<<<< Pokemon Omega Ruby >>>>>>

required cxi ROM:

	000400000011CC400.cxi

PKMN3	RutileRuby		Rutile Ruby 2.1 - Distribution.zip
PKMN7	RisingRuby		RRSSFiles 18-11-2015.zip
PKMN10	RedRuby			Pokemon Red Ruby.rar

<<<<<< Pokemon Alpha Sapphire >>>>>>

required cxi ROM:

	000400000011CC500.cxi

PKMN4	StarSapphire		Star Sapphire 2.1 - Distribution.zip
PKMN8	SinkingSapphire		RRSSFiles 18-11-2015.zip
PKMN9	DeltaEmeraldAS		Pokemon Delta Emerald.zip
"

REQUIREMENTS_3DS="<<<<<< 3DS ROMs >>>>>>

required cxi ROM:

	000400000017BA00.cxi	US Version
	000400000017BB00.cxi	EU Version

BSECU	BravelySecondUncensored
	US Version:	Bravely_Second_Uncensored_USA_MINI_Asia81.rar
	EU Version:	Bravely_Second_Uncensored_EUR_MINI_Asia81.rar
"

REQUIREMENTS_OTHER="<<<<<< ROMS >>>>>>

required smc ROM:

	The Legend of Zelda - A Link to the Past.smc	US Version

ZEL1	ParallelWorlds		lozpw110.rar
"

REQUIREMENTS_FOOTER="Download Links can be obtained using:

	patchimage --game=\"<ID1> <ID2> ...\" --show-download

Files not hosted on Mediafire, Mega or the like can be
auto-downloaded for the build using:

	patchimage --game=\"<ID1> <ID2> ...\" --download

if the file can not automatically be downloaded the link will
be shown and you'll be told to download on your own.
"

REQUIREMENTS_ALL="${MESSAGE_HEADER}

${MESSAGE_HEADER_LIST}

${REQUIREMENTS_NSMB}
${REQUIREMENTS_MKWIIMMFI}
${REQUIREMENTS_KIRBY}
${REQUIREMENTS_TOKYOMIRAGESESSIONSFE}
${REQUIREMENTS_POKEMON}
${REQUIREMENTS_3DS}
${REQUIREMENTS_OTHER}
${MESSAGE_HEADER_LIST}

${REQUIREMENTS_FOOTER}"

PATCHIMAGE_HELP="patchimage ${PATCHIMAGE_VERSION} (${PATCHIMAGE_RELEASE})

	(c) 2013-2016 Christopher Roy Bratusek <nano@jpberlin.de>
	patchimage creates wbfs images from riivolution patches.

*** General parameters ***
--help						| show this message
--game=<ID/Short Name>				| specify game you want to create
--game=\"<ID1/Short Name1> <ID2/Short Name2>\"	| specify multiple games you want to create
--show-download					| only show download link for required files

*** List games ***
--list-games					| show possible options for --game
--list-games-nsmb				| show possible New Super Mario Bros. Wii options for --game
--list-games-mkwiimmfi				| show possible Mario Kart Wii / Wiimmfi options for --game
--list-games-tokyo				| show possible Tokyo Mirage Sessions #FE options for --game
--list-games-kirby				| show possible for Kirby's Adventure Wii options for --game
--list-games-pokemon				| show possible Pokemon options for --game
--list-games-3ds				| show possible 3DS options for --game
--list-games-other				| show possible other options for --game

*** List requirements ***
--list-requirements				| show required image and patch files all games
--list-requirements-nsmb			| show required image and patch files for New Super Mario Bros. Wii
--list-requirements-mkwiimmfi			| show required image and patch files for Mario Kart Wii / Wiimmfi
--list-requirements-tokyo			| show required files and patches for Tokyo Mirage Sessions #FE
--list-requirements-kirby			| show required image and patch files for Kirby's Adventure Wii
--list-requirements-pokemon			| show required image and patch files for Pokemon games
--list-requirements-3ds				| show required image and patch files for other 3DS games
--list-requirements-other			| show required image and patch files for other games

*** Wii game parameters ***
--iso=/home/test/RMCP01.iso			| specify path to Wii iso or wbfs image to use
--riivolution=/home/test/MyMod.zip		| specify path to Wii Riivolution archive
--version=EURv1,EURv2,USAv1,USAv2,JPNv1		| specify your game version (New Super Mario Bros. Wii)
--customdid=SMNP02				| specify a custom ID to use for the modified Wii game
--sharesave					| let modified Wii games share savegame with the original game
--download					| download Riivolution or HANS patch archives (if possible)
--soundtrack					| download soundtrack (if available)
--only-soundtrack				| download soundtrack only (if available) and exit
--covers					| download covers (if available)
--only-covers=SMNP02				| download covers only (if available)
--banner=<banner.bnr>				| use a custom banner (Riivolution games)
--download-banner				| download a custom banner (if available)
--override-szs					| override wit and szs in Wiimms Mario Kart Fun distributions
						| [use this if the originals fail due to incompatible library versions]

*** 3DS game parameters ***
--rom=/home/test/0004000000055e00.cxi		| specify path to 3DS ROM to use for building
--hans=/home/test/MyModdedGame.zip		| specify path to 3DS HANS archive

*** Wii U game parameters ***
--xdelta=/home/test/xdelta			| specify path to Tokyo Mirage Sessions #FE xdelta patches
--cpk=/home/test/cpk				| specify path to original Tokyo Mirage Mirage Sessions #FE files

*** Other game parameters ***
--rom=/home/test/MyGame.rom			| specify path to ROM to use for building
--patch=/home/test/MyModdedGame.ips		| specify path to IPS Patch file

*** Batch-Building shortcuts ***
--game=NSMB_ALL					| build all mods of New Super Mario Bros. Wii
--game=PKMN_ALL					| build all mods of Pokemon X, Y, Omega Ruby, Alpha Sapphire
--game=PKMN_X					| build all mods of Pokemon X
--game=PKMN_Y					| build all mods of Pokemon Y
--game=PKMN_OR					| build all mods of Pokemon Omega Ruby
--game=PKMN_AS					| build all mods of Pokemon Alpha Sapphire
"
