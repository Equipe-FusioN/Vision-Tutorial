enum // Niveis de Admin
{
    PLAYER,
    HELPER,
    ADMIN,
    MASTER,
    DEV
};

new AdminData[MAX_PLAYERS][MAX_PLAYER_NAME];
new bool:ModoAdmin[MAX_PLAYERS];

stock GetAdminLevelName(admlvl)
{
    new admlabel[16];
    switch(admlvl)
    {
        case HELPER: format(admlabel, sizeof(admlabel), "Helper");
        case ADMIN: format(admlabel, sizeof(admlabel), "Administrador");
        case MASTER: format(admlabel, sizeof(admlabel), "Admin Master");
        case DEV: format(admlabel, sizeof(admlabel), "Desenvolvedor");
        default: format(admlabel, sizeof(admlabel), "Jogador");
    }
    return admlabel;
}

stock SendClientMessageToStaff(const message[])
{
    foreach(new playerid : Player)
        if(PlayerData[playerid][admin] > PLAYER)
            SendClientMessage(playerid, COR_ROSA, message);
}