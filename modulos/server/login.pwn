#include <YSI_Coding\y_hooks>

function OnPlayerLogin(playerid)
{
	orm_setkey(PlayerData[playerid][ormid], "id");

	if(orm_errno(PlayerData[playerid][ormid]) == ERROR_OK) // jogador ja existe na database
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Digite sua senha para logar:", "Logar", "Sair");
	else // jogador não encontrado na database
		ShowPlayerDialog(playerid, DIALOG_REGISTRO, DIALOG_STYLE_PASSWORD, "Registro", "Entre com uma senha para se registrar:", "Registrar", "Sair");
	return 1;
}

hook OnPlayerSpawn(playerid)
{
	if(PlayerData[playerid][logado] == false)
	{
		SetPlayerData(playerid);
		SetPlayerWeaponData(playerid);
		PlayerData[playerid][logado] = true;
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
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