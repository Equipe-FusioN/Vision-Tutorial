#include <YSI_Coding\y_hooks>

function OnPlayerLogin(playerid)
{
	orm_setkey(PlayerData[playerid][ormid], "id");

	if(orm_errno(PlayerData[playerid][ormid]) == ERROR_OK) // jogador ja existe na database
	{
		new string[512];
		mysql_format(DBConn, string, sizeof(string), "SELECT * FROM Ban WHERE accid=%d;", PlayerData[playerid][accid]);
		new Cache:cache = mysql_query(DBConn, string);
		if(cache_is_valid(cache))
		{
			cache_set_active(cache);
			new row;
			if(cache_get_row_count(row))
			{
				if(row > 0)
				{
					new banid,ban,desban,nomeadmin[MAX_PLAYER_NAME],motivo[128];
					cache_get_value_name(0, "adm", nomeadmin);
					cache_get_value_name(0, "motivo", motivo);
					cache_get_value_name_int(0, "banid", banid);
					cache_get_value_name_int(0, "ban", ban);
					cache_get_value_name_int(0, "desban", desban);

					// se o ban é permanente
					if(desban <= 0)
					{
						new date[3], time[3];
						TimestampToDate(ban, date[0], date[1], date[2], time[0], time[1], time[2], -3);

						format(string, sizeof(string), "%sVOCÊ ESTÁ BANIDO DESTE SERVIDOR!\n\
						%sResponsável pelo ban: %s%s\n\
						%sData do Ban: %s%d/%d/%d - %d:%d:%d\n\
						%sData de Desban: %sPERMANENTE\n\
						%sMotivo: %s%s",
						EMBED_VERMELHO,
						EMBED_AMARELO, EMBED_BRANCO, nomeadmin,
						EMBED_AMARELO, EMBED_BRANCO, date[2],date[1],date[0], time[0], time[1], time[2],
						EMBED_AMARELO, EMBED_VERMELHO,
						EMBED_AMARELO, EMBED_BRANCO, motivo);

						ShowPlayerDialog(playerid, DIALOG_BAN, DIALOG_STYLE_MSGBOX, "Banido", string, "Sair", "");

						cache_unset_active();
						cache_delete(cache);
						return 1;
					}
					// se o ban é temporário
					else if(getdate()+gettime() < desban) // ainda esta banido
					{
						new bandate[3], bantime[3], desbandate[3], desbantime[3];
						TimestampToDate(ban, bandate[0],bandate[1],bandate[2], bantime[0],bantime[1],bantime[2], -3);
						TimestampToDate(desban, desbandate[0],desbandate[1],desbandate[2], desbantime[0],desbantime[1],desbantime[2], -3);

						format(string, sizeof(string), "%sVOCÊ ESTÁ BANIDO DESTE SERVIDOR!\n\
						%sResponsável pelo ban: %s%s\n\
						%sData do Ban: %s%d/%d/%d - %d:%d:%d\n\
						%sData de Desban: %s%d/%d/%d - %d:%d:%d\n\
						%sMotivo: %s%s",
						EMBED_VERMELHO,
						EMBED_AMARELO, EMBED_BRANCO, nomeadmin,
						EMBED_AMARELO, EMBED_BRANCO, bandate[2],bandate[1],bandate[0], bantime[0],bantime[1],bantime[2],
						EMBED_AMARELO, EMBED_BRANCO, desbandate[2],desbandate[1],desbandate[0], desbantime[0],desbantime[1],desbantime[2],
						EMBED_AMARELO, EMBED_BRANCO, motivo);

						ShowPlayerDialog(playerid, DIALOG_BAN, DIALOG_STYLE_MSGBOX, "Banido", string, "Sair", "");

						cache_unset_active();
						cache_delete(cache);
						return 1;
					}
					else // player ja pode ser desbanido
					{
						mysql_format(DBConn, string, sizeof(string), "DELETE FROM Ban WHERE banid=%d;", banid);
						mysql_query(DBConn, string, false);
					}
				}
			}
		}

		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Digite sua senha para logar:", "Logar", "Sair");
	}
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
		case DIALOG_BAN: Kick(playerid);
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
					SendClientMessage(playerid, COR_VERMELHO, "ERRO: Senha incorreta!");
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
					SendClientMessage(playerid, COR_VERMELHO, "ERRO: Sua senha deve conter entre 1 e 16 caracteres!");
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