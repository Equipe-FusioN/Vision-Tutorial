// BIBLIOTECAS
#include <a_samp>
#include <fixes>
#include <timerfix>
#include <a_mysql>
#include <sscanf2>
#include <zcmd>
#include <DOF2>
#include <YSI_Data\y_iterate>
#include <YSI_Coding\y_hooks>

// CABEÇALHOS
#include <tutorial>
#include <dbinfo>
#include <playerinfo>
#include <weaponinfo>

// MODULOS
#include "../modulos/core/util.pwn"

#include "../modulos/server/database.pwn"
#include "../modulos/server/login.pwn"

#include "../modulos/player/player.pwn"
#include "../modulos/player/comandos.pwn"

// -----------------------------------------------------------------

main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}

// -----------------------------------------------------------------

public OnGameModeInit()
{
	SetGameModeText("Blank Script");
	LoadMap("maps/favela_objects.txt");
	DataBaseInit();
	return 1;
}

// -----------------------------------------------------------------

public OnGameModeExit()
{
	DOF2_Exit();
	mysql_close(DBConn);
	return 1;
}