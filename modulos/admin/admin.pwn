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
    return 1;
}