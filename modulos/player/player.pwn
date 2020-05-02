#include <YSI_Coding\y_hooks>

hook OnPlayerConnect(playerid)
{
	RemoveBuildingFromFile(playerid, "maps/favela_buildings.txt");
	LoadPlayerData(playerid);
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
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

hook OnPlayerText(playerid, text[])
{
	new Float:talkpos[3];
	GetPlayerPos(playerid, talkpos[0], talkpos[1], talkpos[2]);
	foreach(new i : Player)
	{
		if(IsPlayerInRangeOfPoint(i, 20, talkpos[0], talkpos[1], talkpos[2]))
		{
			new string[128];
			format(string,sizeof(string), "%s(%d): %s", GetPlayerNameEx(playerid), playerid, text);
			SendClientMessage(i, -1, string);
			return 1;
		}
	}

	return 0;
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
	
	LoadPlayerWeaponData(playerid);
	orm_setkey(PlayerData[playerid][ormid], "nome");
	orm_select(PlayerData[playerid][ormid], "OnPlayerLogin", "d", playerid);
    return 1;
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
    return 1;
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
    orm_addvar_int(PlayerData[playerid][ormid], WeaponData[playerid][WEAPONSLOT_MACHINEGUN][ammo], "machine_ammo");
 
    orm_addvar_int(PlayerData[playerid][ormid], WeaponData[playerid][WEAPONSLOT_FUZIL][weaponid], "fuzil");
    orm_addvar_int(PlayerData[playerid][ormid], WeaponData[playerid][WEAPONSLOT_FUZIL][ammo], "fuzil_ammo");
 
    orm_addvar_int(PlayerData[playerid][ormid], WeaponData[playerid][WEAPONSLOT_RIFLE][weaponid], "rifle");
    orm_addvar_int(PlayerData[playerid][ormid], WeaponData[playerid][WEAPONSLOT_RIFLE][ammo], "rifle_ammo");
}