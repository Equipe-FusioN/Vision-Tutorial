#include <a_samp>
#include <fixes>
#include <timerfix>
#include <a_mysql>
#include <sscanf2>
#include <zcmd>
#include <DOF2>

#define function%0(%1) forward %0(%1); public %0(%1)

#define MAX_PASS_LEN 65
#define SALT_LEN 13

#define MAX_WEAPONS 13

enum //Weapon Slots
{
    WEAPONSLOT_FIST,
    WEAPONSLOT_WHITEGUN,
    WEAPONSLOT_PISTOL,
    WEAPONSLOT_SHOTGUN,
    WEAPONSLOT_MACHINEGUN,
    WEAPONSLOT_FUZIL,
    WEAPONSLOT_RIFLE
};

enum //Dialogs
{
	DIALOG_LOGIN,
	DIALOG_REGISTRO
};

new MySQL:DBConn, host[16], username[MAX_PLAYER_NAME], database[MAX_PLAYER_NAME], pass[16];

enum PLAYER_DATA
{
	accid,
	nome[MAX_PLAYER_NAME],
	senha[MAX_PASS_LEN],
	admin,
	Float:posX,
	Float:posY,
	Float:posZ,
	Float:angulo,
	Float:health,
	Float:armor,
	money,
	interior,
	vw,
	skin,
	score,
	ORM:ormid,
	bool:logado,
	pSalt[SALT_LEN]
};
new PlayerData[MAX_PLAYERS][PLAYER_DATA];

enum WEAPON_DATA
{
	weaponid,
	ammo
};
new WeaponData[MAX_PLAYERS][MAX_WEAPONS][WEAPON_DATA];

// PROCEDIMENTOS

function Float:GetPlayerHealthEx(playerid)
{
	new Float:playerhealth;
	GetPlayerHealth(playerid, playerhealth);
	return playerhealth;
}

function Float:GetPlayerArmourEx(playerid)
{
	new Float:playerarmor;
	GetPlayerArmour(playerid, playerarmor);
	return playerarmor;
}

stock SavePlayerData(playerid)
{
    PlayerData[playerid][armor] = GetPlayerArmourEx(playerid);
    PlayerData[playerid][health] = GetPlayerHealthEx(playerid);
    PlayerData[playerid][money] = GetPlayerMoney(playerid);
    PlayerData[playerid][skin] = GetPlayerSkin(playerid);
    PlayerData[playerid][interior] = GetPlayerInterior(playerid);
    PlayerData[playerid][vw] = GetPlayerVirtualWorld(playerid);
    PlayerData[playerid][score] = GetPlayerScore(playerid);
    GetPlayerFacingAngle(playerid, PlayerData[playerid][angulo]);
    GetPlayerPos(playerid,
    PlayerData[playerid][posX],
    PlayerData[playerid][posY],
    PlayerData[playerid][posZ]);

	for(new i=0; i < MAX_WEAPONS; i++)
		GetPlayerWeaponData(playerid, i, WeaponData[playerid][i][weaponid], WeaponData[playerid][i][ammo]);
 
    orm_update(PlayerData[playerid][ormid]);
}

stock SetPlayerWeaponData(playerid)
{
    GivePlayerWeapon(playerid, WeaponData[playerid][WEAPONSLOT_SHOTGUN][weaponid], WeaponData[playerid][WEAPONSLOT_SHOTGUN][ammo]);
    GivePlayerWeapon(playerid, WeaponData[playerid][WEAPONSLOT_MACHINEGUN][weaponid], WeaponData[playerid][WEAPONSLOT_MACHINEGUN][ammo]);
    GivePlayerWeapon(playerid, WeaponData[playerid][WEAPONSLOT_FUZIL][weaponid], WeaponData[playerid][WEAPONSLOT_FUZIL][ammo]);
    GivePlayerWeapon(playerid, WeaponData[playerid][WEAPONSLOT_RIFLE][weaponid], WeaponData[playerid][WEAPONSLOT_RIFLE][ammo]);
    SetPlayerArmedWeapon(playerid,0);
}

stock SetPlayerData(playerid)
{
    SetPlayerScore(playerid, PlayerData[playerid][score]);
    SetPlayerHealth(playerid, PlayerData[playerid][health]);
    SetPlayerArmour(playerid, PlayerData[playerid][armor]);
    GivePlayerMoney(playerid, PlayerData[playerid][money]);
    SetPlayerInterior(playerid, PlayerData[playerid][interior]);
    SetPlayerVirtualWorld(playerid, PlayerData[playerid][vw]);
}

stock LoadPlayerWeaponData(playerid)
{
    orm_addvar_int(PlayerData[playerid][ormid], WeaponData[playerid][WEAPONSLOT_FIST][weaponid], "fist");
    orm_addvar_int(PlayerData[playerid][ormid], WeaponData[playerid][WEAPONSLOT_WHITEGUN][weaponid], "white_gun");
 
    orm_addvar_int(PlayerData[playerid][ormid], WeaponData[playerid][WEAPONSLOT_PISTOL][weaponid], "pistol");
    orm_addvar_int(PlayerData[playerid][ormid], WeaponData[playerid][WEAPONSLOT_PISTOL][ammo], "pistol_ammo");
 
    orm_addvar_int(PlayerData[playerid][ormid], WeaponData[playerid][WEAPONSLOT_SHOTGUN][weaponid], "shotgun");
    orm_addvar_int(PlayerData[playerid][ormid], WeaponData[playerid][WEAPONSLOT_SHOTGUN][ammo], "shotgun_ammo");
 
    orm_addvar_int(PlayerData[playerid][ormid], WeaponData[playerid][WEAPONSLOT_MACHINEGUN][weaponid], "machinegun");
    orm_addvar_int(PlayerData[playerid][ormid], WeaponData[playerid][WEAPONSLOT_MACHINEGUN][ammo], "machinegun_ammo");
 
    orm_addvar_int(PlayerData[playerid][ormid], WeaponData[playerid][WEAPONSLOT_FUZIL][weaponid], "fuzil");
    orm_addvar_int(PlayerData[playerid][ormid], WeaponData[playerid][WEAPONSLOT_FUZIL][ammo], "fuzil_ammo");
 
    orm_addvar_int(PlayerData[playerid][ormid], WeaponData[playerid][WEAPONSLOT_RIFLE][weaponid], "rifle");
    orm_addvar_int(PlayerData[playerid][ormid], WeaponData[playerid][WEAPONSLOT_RIFLE][ammo], "rifle_ammo");
}

stock LoadPlayerData(playerid)
{
	PlayerData[playerid][logado] = false;
	format(PlayerData[playerid][nome], MAX_PLAYER_NAME, "%s", GetPlayerNameEx(playerid));

	PlayerData[playerid][ormid] = orm_create("Player", DBConn);

	orm_addvar_int(PlayerData[playerid][ormid], PlayerData[playerid][accid], "id");
	orm_addvar_string(PlayerData[playerid][ormid], PlayerData[playerid][nome], MAX_PLAYER_NAME, "nome");
	orm_addvar_string(PlayerData[playerid][ormid], PlayerData[playerid][senha], MAX_PASS_LEN, "senha");
	orm_addvar_int(PlayerData[playerid][ormid], PlayerData[playerid][admin], "admin");
	orm_addvar_float(PlayerData[playerid][ormid], PlayerData[playerid][posX], "posX");
	orm_addvar_float(PlayerData[playerid][ormid], PlayerData[playerid][posY], "posY");
	orm_addvar_float(PlayerData[playerid][ormid], PlayerData[playerid][posZ], "posZ");
	orm_addvar_float(PlayerData[playerid][ormid], PlayerData[playerid][angulo], "angulo");
	orm_addvar_float(PlayerData[playerid][ormid], PlayerData[playerid][health], "health");
	orm_addvar_float(PlayerData[playerid][ormid], PlayerData[playerid][armor], "armor");
	orm_addvar_int(PlayerData[playerid][ormid], PlayerData[playerid][money], "dinheiro");
	orm_addvar_int(PlayerData[playerid][ormid], PlayerData[playerid][score], "score");
	orm_addvar_int(PlayerData[playerid][ormid], PlayerData[playerid][skin], "skin");
	orm_addvar_int(PlayerData[playerid][ormid], PlayerData[playerid][interior], "interior");
	orm_addvar_int(PlayerData[playerid][ormid], PlayerData[playerid][vw], "vw");
	orm_addvar_string(PlayerData[playerid][ormid], PlayerData[playerid][pSalt], SALT_LEN, "salt");
	
	//LoadPlayerWeaponData(playerid);
	orm_setkey(PlayerData[playerid][ormid], "nome");
	orm_select(PlayerData[playerid][ormid], "OnPlayerLogin", "d", playerid);
}

stock LoadDBSettings(const filename[])
{
	//new host[16], username[MAX_PLAYER_NAME], database[MAX_PLAYER_NAME], pass[16];
	if(DOF2_FileExists(filename))
	{
		format(host, sizeof(host), "%s", DOF2_GetString(filename,"address"));
		format(username, sizeof(username), "%s", DOF2_GetString(filename,"username"));
		format(database, sizeof(database), "%s", DOF2_GetString(filename,"database"));
		format(pass, sizeof(pass), "%s", DOF2_GetString(filename,"password"));
	}
	else
	{
		DOF2_CreateFile(filename);
		DOF2_SetString(filename,"address","127.0.0.1");
		DOF2_SetString(filename,"username","root");
		DOF2_SetString(filename,"database", " ");
		DOF2_SetString(filename,"password", " ");
		DOF2_SaveFile();
	}
}

stock Salt()
{
    new salt[SALT_LEN];
    for(new i; i < SALT_LEN-1; i++)
        salt[i] = random(79) + 47;
	salt[SALT_LEN-1] = 0;
    return salt;
}

stock GetPlayerNameEx(playerid)
{
	new PlayerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
	return PlayerName;
}

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

public OnGameModeExit()
{
	DOF2_Exit();
	mysql_close(DBConn);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	RemoveBuildingFromFile(playerid, "maps/favela_buildings.txt");
	LoadPlayerData(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(PlayerData[playerid][logado] == true)
	{
		SavePlayerData(playerid);

		new rsnstr[3][] =
		{
			"Timeout/Crash",
			"Saiu",
			"Kickado/Banido"
		};
		new string[64];
		format(string, sizeof(string), "%s foi desconectado (%s)", GetPlayerNameEx(playerid), rsnstr[reason]);
		SendClientMessageToAll(-1, string);
	}

	orm_destroy(PlayerData[playerid][ormid]);
	for(new PLAYER_DATA:i; i < PLAYER_DATA; i++)
		PlayerData[playerid][i] = 0;

	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(PlayerData[playerid][logado] == false)
	{
		SetPlayerData(playerid);
		SetPlayerWeaponData(playerid);
		PlayerData[playerid][logado] = true;
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_LOGIN:
		{
			if(!response)
				Kick(playerid);
			else
			{
				new hash[MAX_PASS_LEN];
				SHA256_PassHash(inputtext, PlayerData[playerid][pSalt], hash, MAX_PASS_LEN);
				if(strlen(inputtext) < 1 || strcmp(PlayerData[playerid][senha], hash))
				{
					SendClientMessage(playerid, -1, "ERRO: Senha incorreta!");
					ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Digite sua senha para logar:", "Logar", "Sair");
				}
				else
				{
					SendClientMessage(playerid, -1, "Logado com sucesso!");
					SetSpawnInfo(playerid, NO_TEAM, PlayerData[playerid][skin],
					PlayerData[playerid][posX], PlayerData[playerid][posY],PlayerData[playerid][posZ],
					PlayerData[playerid][angulo],
					WeaponData[playerid][WEAPONSLOT_FIST][weaponid], WeaponData[playerid][WEAPONSLOT_FIST][ammo],
					WeaponData[playerid][WEAPONSLOT_WHITEGUN][weaponid], WeaponData[playerid][WEAPONSLOT_WHITEGUN][ammo],
					WeaponData[playerid][WEAPONSLOT_PISTOL][weaponid], WeaponData[playerid][WEAPONSLOT_PISTOL][ammo]);
					SpawnPlayer(playerid);
				}
			}
		}
		case DIALOG_REGISTRO:
		{
			if(!response)
				Kick(playerid);
			else
			{
				if(strlen(inputtext) < 1 || strlen(inputtext) > 16)
				{
					SendClientMessage(playerid, -1, "ERRO: Sua senha deve conter entre 1 e 16 caracteres!");
					ShowPlayerDialog(playerid, DIALOG_REGISTRO, DIALOG_STYLE_PASSWORD, "Registro", "Entre com uma senha para se registrar:", "Registrar", "Sair");
				}
				else
				{
					PlayerData[playerid][pSalt] = Salt();
					SendClientMessage(playerid, -1, "Registrado com sucesso!");
					SHA256_PassHash(inputtext, PlayerData[playerid][pSalt], PlayerData[playerid][senha], MAX_PASS_LEN);
					orm_insert(PlayerData[playerid][ormid]);
					PlayerData[playerid][logado] = true;
					SetSpawnInfo(playerid, NO_TEAM, 0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
					SpawnPlayer(playerid);
				}
			}
		}
	}

	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    return 1;
}

function OnPlayerLogin(playerid)
{
	orm_setkey(PlayerData[playerid][ormid], "id");

	if(orm_errno(PlayerData[playerid][ormid]) == ERROR_OK) // jogador ja existe na database
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Digite sua senha para logar:", "Logar", "Sair");
	else // jogador não encontrado na database
		ShowPlayerDialog(playerid, DIALOG_REGISTRO, DIALOG_STYLE_PASSWORD, "Registro", "Entre com uma senha para se registrar:", "Registrar", "Sair");
	return 1;
}

function DataBaseInit()
{
	//new MYSQL:DBConn, host[16], username[MAX_PLAYER_NAME], database[MAX_PLAYER_NAME], pass[16];
	LoadDBSettings("dbconfig.ini");
	DBConn = mysql_connect(host, username, pass, database);
	if(mysql_errno() == 0)
	{
		printf("[MySQL] Database '%s' conectada com sucesso!", database);
		print("[MySQL] Verificando tabelas...");

		mysql_query(DBConn, "CREATE TABLE IF NOT EXISTS Player (\
		id int NOT NULL AUTO_INCREMENT,\
		nome varchar(25) NOT NULL,\
		senha varchar(255) NOT NULL,\
		admin int DEFAULT 0,\
		PRIMARY KEY(id));", false);

		mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS health float DEFAULT 100;", false);
		mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS armor float DEFAULT 100;", false);
		mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS dinheiro int DEFAULT 100;", false);
		mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS posX double DEFAULT 0;", false);
		mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS posY double DEFAULT 0;", false);
		mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS posZ double DEFAULT 0;", false);
		mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS angulo double DEFAULT 0;", false);
		mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS interior int DEFAULT 0;", false);
		mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS vw int DEFAULT 0;", false);
		mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS score int DEFAULT 0;", false);
		mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS skin int DEFAULT 0;", false);
		mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS salt varchar(65) DEFAULT 0;", false);

		mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS fist int DEFAULT 0;", false);
        mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS white_gun int DEFAULT 0;", false);
        mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS pistol int DEFAULT 0;", false);
        mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS pistol_ammo int DEFAULT 0;", false);
        mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS shotgun int DEFAULT 0;", false);
        mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS shotgun_ammo int DEFAULT 0;", false);
        mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS machinegun int DEFAULT 0;", false);
        mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS machinegun_ammo int DEFAULT 0;", false);
        mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS fuzil int DEFAULT 0;", false);
        mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS fuzil_ammo int DEFAULT 0;", false);
        mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS rifle int DEFAULT 0;", false);
        mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS rifle_ammo int DEFAULT 0;", false);

		print("[MySQL] Tabela 'Players' verificada com sucesso!");
	}
	else
	{
		printf("[MySQL] ERRO: Não foi possível se conectar a database '%s'!", database);
		SendRconCommand("exit");
	}

	return 1;
}

function RemoveBuildingFromFile(playerid, const file[])
{
	new File:map = fopen(file, io_read);
	if(map)
	{
		new string[256];
		while(fread(map, string))
		{
			new modelid, Float:pos[3], Float:rad;
			if(!sscanf(string, "dffff", modelid, pos[0], pos[1], pos[2], rad))
				RemoveBuildingForPlayer(playerid, modelid, pos[0], pos[1], pos[2], rad);
			else
				return printf("Carregamento do mapa '%s' falhou para o jogador %s(%d).", file, GetPlayerNameEx(playerid), playerid);
		}
	}
	return printf("Jogador %s(%d) carregou o mapa '%s' com êxito.", GetPlayerNameEx(playerid), playerid, file);
}

function LoadMap(const file[])
{
	printf("Carregando Mapa '%s'...", file);
	new File:map = fopen(file, io_read);
	if(map)
	{
		new string[256];
		while(fread(map, string))
		{
			new modelid, Float:pos[3], Float:rot[3];
			if(sscanf(string, "dffffff", modelid, pos[0], pos[1], pos[2], rot[0], rot[1], rot[2]))
				return printf("Erro ao carregar o mapa '%s'!",file);
			else
				CreateObject(modelid, pos[0], pos[1], pos[2], rot[0], rot[1], rot[2]);
				
		}
		return printf("Mapa '%s' carregado com sucesso!",file);
	}
	else return printf("Erro ao carregar o mapa '%s'!",file);
}

// COMANDOS

CMD:pos(playerid, const params[])
{
	new Float:pos[3], giveplayerid;
	if(sscanf(params, "ufff", giveplayerid, pos[0], pos[1], pos[2]))
		return SendClientMessage(playerid, -1, "USO: /pos [id] [x] [y] [z]");

	if(!IsPlayerConnected(giveplayerid) || giveplayerid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, -1, "ERRO: ID Inválido!");

	SetPlayerPos(giveplayerid, pos[0], pos[1], pos[2]);
	return 1;
}

CMD:info(playerid, const params[])
{
	new giveplayerid, string[64];
	
	if(sscanf(params, "u", giveplayerid))
		return SendClientMessage(playerid, -1, "USO: /info [id]");
	
	if(!IsPlayerConnected(giveplayerid) || giveplayerid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, -1, "ERRO: ID Inválido!");

	format(string, sizeof(string), "Jogador: %s", GetPlayerNameEx(giveplayerid));
	SendClientMessage(playerid, -1, string);

	format(string, sizeof(string), "ID: %d", giveplayerid);
	SendClientMessage(playerid, -1, string);

	format(string, sizeof(string), "Score: %d", GetPlayerScore(giveplayerid));
	SendClientMessage(playerid, -1, string);

	format(string, sizeof(string), "Dinheiro: %d", GetPlayerMoney(giveplayerid));
	SendClientMessage(playerid, -1, string);
		
	format(string, sizeof(string), "Life: %f", GetPlayerHealthEx(giveplayerid));
	SendClientMessage(playerid, -1, string);

	format(string, sizeof(string), "Armor: %f", GetPlayerArmourEx(giveplayerid));
	SendClientMessage(playerid, -1, string);

	new Float:pos[3];
	GetPlayerPos(giveplayerid, pos[0], pos[1], pos[2]);
	format(string, sizeof(string), "PosX: %f PosY: %f PosZ: %f", pos[0], pos[1], pos[2]);
	SendClientMessage(playerid, -1, string);

	format(string, sizeof(string),"Int: %d", GetPlayerInterior(giveplayerid));
	SendClientMessage(playerid, -1, string);

	format(string, sizeof(string),"Virtual World: %d", GetPlayerVirtualWorld(giveplayerid));
	SendClientMessage(playerid, -1, string);

	return 1;
}