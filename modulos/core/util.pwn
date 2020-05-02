Float:GetPlayerHealthEx(playerid)
{
	new Float:playerhealth;
	GetPlayerHealth(playerid, playerhealth);
	return playerhealth;
}

Float:GetPlayerArmourEx(playerid)
{
	new Float:playerarmor;
	GetPlayerArmour(playerid, playerarmor);
	return playerarmor;
}

stock GetPlayerNameEx(playerid)
{
	new PlayerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
	return PlayerName;
}

stock Salt()
{
    new salt[SALT_LEN];
    for(new i; i < SALT_LEN-1; i++)
        salt[i] = random(79) + 47;
	salt[SALT_LEN-1] = 0;
    return salt;
}

stock RemoveBuildingFromFile(playerid, const file[])
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

stock LoadMap(const file[])
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