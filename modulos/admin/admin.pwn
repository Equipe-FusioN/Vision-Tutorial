#include <YSI_Coding\y_hooks>

hook OnPlayerConnect(playerid)
{
    ModoAdmin[playerid] = false;
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_ADMINS && response && PlayerData[playerid][admin] >= DEV)
    {
        format(AdminData[playerid], MAX_PLAYER_NAME, "%s", inputtext);
        new string[512];
        format(string, sizeof(string), "Setar %s para %s", AdminData[playerid], GetAdminLevelName(PLAYER));
        for(new i=1;i<5;i++)
            format(string, sizeof(string), "%s\nSetar %s para %s", string, AdminData[playerid], GetAdminLevelName(i));
        ShowPlayerDialog(playerid, DIALOG_INFOADMIN, DIALOG_STYLE_LIST, "Gerenciar Admin", string, "Selecionar", "Cancelar");
    }
    else if(dialogid == DIALOG_INFOADMIN && response)
    {
        if(ModoAdmin[playerid] != true)
            return SendClientMessage(playerid, COR_VERMELHO, "ERRO: Você não está em modo admin!");

        new giveplayerid, string[128];
        format(string, sizeof(string), "%s", AdminData[playerid]);
        unformat(string, "u", giveplayerid);
        if(giveplayerid != INVALID_PLAYER_ID && PlayerData[giveplayerid][logado] == true)
        {
            PlayerData[giveplayerid][admin] = listitem;
            orm_update(PlayerData[giveplayerid][ormid]);

            format(string, sizeof(string), "%s %s Alterou o cargo de %s para %s.", GetAdminLevelName(PlayerData[playerid][admin]), GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetAdminLevelName(PlayerData[giveplayerid][admin]));            
        }
        else
        {
            mysql_format(DBConn, string, sizeof(string), "UPDATE Player SET admin=%d WHERE nome='%e';", listitem, AdminData[playerid]);
            mysql_query(DBConn, string, false);

            format(string, sizeof(string), "%s %s Alterou o cargo de %s para %s.", GetAdminLevelName(PlayerData[playerid][admin]), GetPlayerNameEx(playerid), AdminData[playerid], GetAdminLevelName(listitem));
        }

        SendClientMessageToAll(COR_ROSA, string);
    }
    return 1;
}