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