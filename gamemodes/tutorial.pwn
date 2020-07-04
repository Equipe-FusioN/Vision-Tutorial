// BIBLIOTECAS
#include <a_samp>
#include <fixes>
#include <timerfix>
#include <a_mysql>
#include <sscanf2>
#include <zcmd>
#include <DOF2>
#include <timestamp>
#include <YSI_Data\y_iterate>
#include <YSI_Coding\y_hooks>

// CABEÇALHOS
#include <cores>
#include <tutorial>
#include <dbinfo>
#include <playerinfo>
#include <weaponinfo>
#include <adminfo>

// MODULOS
#include "../modulos/core/util.pwn"

#include "../modulos/gui/relogio.pwn"

#include "../modulos/server/database.pwn"
#include "../modulos/server/login.pwn"

#include "../modulos/player/player.pwn"
#include "../modulos/player/comandos.pwn"

#include "../modulos/admin/comandos.pwn"
#include "../modulos/admin/admin.pwn"

// -----------------------------------------------------------------

main()
{
	print("\n----------------------------------");
	print(" Tutorial Series by FusioN Team ");
	print("----------------------------------\n");
}

// -----------------------------------------------------------------

public OnGameModeInit()
{
	SetGameModeText("FsN Tutos");
	LoadMap("maps/favela_objects.txt");
	DataBaseInit();
	CreateClock();
	return 1;
}

// -----------------------------------------------------------------

public OnGameModeExit()
{
	DOF2_Exit();
	mysql_close(DBConn);
	DestroyClock();
	return 1;
}