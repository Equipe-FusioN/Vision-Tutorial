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

    new string[512];
    format(string, sizeof(string), "Admin\tNível\tStatus");
    new Cache:cache = mysql_query(DBConn, "SELECT * FROM Player WHERE admin>0");
    if(cache_is_valid(cache))
    {
        cache_set_active(cache);
        new row;
        if(cache_get_row_count(row))
        {
            for(new i; i<row; i++)
            {
                new adminid, nomeadm[MAX_PLAYER_NAME], modoadm[MAX_PLAYER_NAME], admlvlname[16];
                cache_get_value_name(i, "nome", nomeadm);
                new aux[MAX_PLAYER_NAME];
                format(aux, sizeof(aux), "%s", nomeadm);
                unformat(aux, "u", adminid);
                if(adminid != INVALID_PLAYER_ID && PlayerData[adminid][logado] == true)
                {
                    format(nomeadm, sizeof(nomeadm), "%s", GetPlayerNameEx(adminid));
                    if(ModoAdmin[adminid] == true)
                        format(modoadm,sizeof(modoadm), "%sDisponível",EMBED_VERDE);
                    else format(modoadm,sizeof(modoadm), "%sJogando",EMBED_AMARELO);
                    format(admlvlname, sizeof(admlvlname), "%s", GetAdminLevelName(PlayerData[adminid][admin]));
                    
                    format(string, sizeof(string), "%s\n%s\t%s\t%s", string, nomeadm, admlvlname, modoadm);
                }
                else
                {
                    format(modoadm,sizeof(modoadm), "%sOffline",EMBED_VERMELHO);
                    new admlvl;
                    cache_get_value_name_int(i, "admin", admlvl);
                    format(admlvlname, sizeof(admlvlname), "%s", GetAdminLevelName(admlvl));
                    
                    format(string, sizeof(string), "%s\n%s\t%s\t%s", string, nomeadm, admlvlname, modoadm);
                }
            }
        }
        ShowPlayerDialog(playerid, DIALOG_ADMINS, DIALOG_STYLE_TABLIST_HEADERS, "Staff Administrativa", string, "OK", "Fechar");
    }
    cache_unset_active();
    cache_delete(cache);
    return 1;
}

CMD:setaradm(playerid, params[])
{
    new string[64];
    if(PlayerData[playerid][admin] < DEV)
    {
        format(string, sizeof(string), "ERRO: Você não é um %s!", GetAdminLevelName(DEV));
        return SendClientMessage(playerid, COR_VERMELHO, string);
    }
    else if(ModoAdmin[playerid] != true)
            return SendClientMessage(playerid, COR_VERMELHO, "ERRO: Você não está em modo admin!");

    new giveplayerid, admlvl;
    if(sscanf(params, "ud", giveplayerid, admlvl))
        return SendClientMessage(playerid, COR_CINZA, "USO: /setaradm [id/nome] [nivel(0~4)]");
    else if(giveplayerid == INVALID_PLAYER_ID || !IsPlayerConnected(giveplayerid))
        return SendClientMessage(playerid, COR_VERMELHO, "ERRO: Jogador não está logado!");
    else if(PlayerData[giveplayerid][logado] != true)
        return SendClientMessage(playerid, COR_VERMELHO, "ERRO: Jogador não está logado!");

    PlayerData[giveplayerid][admin] = admlvl;
    orm_update(PlayerData[giveplayerid][ormid]);

    format(string, sizeof(string), "%s %s Alterou o cargo de %s para %s.", GetAdminLevelName(PlayerData[playerid][admin]), GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetAdminLevelName(PlayerData[giveplayerid][admin]));    
    SendClientMessageToAll(COR_ROSA, string);
    return 1;
}

CMD:banir(playerid, params[])
{
	new string[512];
    if(PlayerData[playerid][admin] < ADMIN)
    {
        format(string, sizeof(string), "ERRO: Você não é um %s!", GetAdminLevelName(ADMIN));
        return SendClientMessage(playerid, COR_VERMELHO, string);
    }
    else if(ModoAdmin[playerid] != true)
        return SendClientMessage(playerid, COR_VERMELHO, "ERRO: Você não está em modo admin!");

    new giveplayerid, tempo, motivo[64];
    if(sscanf(params, "uds[64]", giveplayerid, tempo, motivo))
        return SendClientMessage(playerid, COR_CINZA, "USO: /banir [id/nome] [dias(0=permanente)] [motivo]");
    else if(giveplayerid == INVALID_PLAYER_ID || PlayerData[giveplayerid][logado] != true)
        return SendClientMessage(playerid, COR_VERMELHO, "ERRO: Jogador não está logado!");

    new playerip[16], serial[64], bantime, unbantime;
    GetPlayerIp(giveplayerid, playerip, sizeof(playerip));
    gpci(giveplayerid, serial, sizeof(serial));
    bantime = getdate() + gettime();
    if(tempo < 1) unbantime = 0; // permaban
    else unbantime = bantime + (tempo*86400); // 86400 = 1 dia

    mysql_format(DBConn, string, sizeof(string), "INSERT INTO Ban \
        (accid, ip, gpci, adm, ban, desban, motivo) \
        VALUES (%d, %e, %e, %e, %d, %d, %e);",
        PlayerData[giveplayerid][accid], playerip, serial, GetPlayerNameEx(playerid), bantime, unbantime, motivo);
    mysql_query(DBConn, string, false);

    if(tempo < 1) format(string, sizeof(string), "%s %s baniu %s permanentemente.", GetAdminLevelName(PlayerData[playerid][admin]), GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
    else format(string, sizeof(string), "%s %s baniu %s por %d dia(s).", GetAdminLevelName(PlayerData[playerid][admin]), GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), tempo);

    SendClientMessageToAll(COR_VERMELHO, string);
    Kick(giveplayerid);
    return 1;
}