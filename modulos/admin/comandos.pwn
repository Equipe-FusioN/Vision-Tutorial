CMD:modoadmin(playerid, params[])
{
    if(PlayerData[playerid][logado] == false)
	    SendClientMessage(playerid, COR_VERMELHO, "ERRO: Você não está logado!");
    else if(PlayerData[playerid][admin] > PLAYER)
    {
        if(ModoAdmin[playerid] == false)
        {
            GetPlayerHealth(playerid, PlayerData[playerid][health]);
            ModoAdmin[playerid] = true;
            SetPlayerHealth(playerid, FLOAT_INFINITY);
            new string[128];
            format(string, sizeof(string), "%s %s entrou em modo admin.", GetAdminLevelName (PlayerData[playerid][admin]), GetPlayerNameEx(playerid));
            SendClientMessageToAll(COR_ROSA, string);
            SendClientMessageToAll(COR_ROSA, "Use /admins para mais informações.");
        }
        else
        {
            ModoAdmin[playerid] = false;
            SetPlayerHealth(playerid, PlayerData[playerid][health]);
            new string[128];
            format(string, sizeof(string), "%s %s saiu do modo admin.", GetAdminLevelName(PlayerData[playerid][admin]), GetPlayerNameEx(playerid));
            SendClientMessageToAll(COR_ROSA, string);
            SendClientMessageToAll(COR_ROSA, "Use /admins para mais informações.");
        }
    }
    return 1;
}

CMD:admins(playerid, params[])
{
    if(PlayerData[playerid][logado] == false)
	    SendClientMessage(playerid, COR_VERMELHO, "ERRO: Você não está logado!");

    new Cache:cache = mysql_query(DBConn, "SELECT * FROM Player WHERE admin>0");
    if(cache_is_valid(cache))
    {
        cache_set_active(cache);
        new row;
        if(cache_get_row_count(row))
        {
            for(new i; i<row; i++)
            {
                new adminid, admname[MAX_PLAYER_NAME];
                cache_get_value_name(i, "nome", admname);
                if(sscanf(admname, "u", adminid))
                {

                }
                else
                {

                }
            }
        }
    }
    cache_unset_active();
    cache_delete(cache);
    return 1;
}