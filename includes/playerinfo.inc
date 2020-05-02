enum PLAYER_DATA
{
	accid,
	nome[MAX_PLAYER_NAME],
	senha[MAX_PASS_LEN],
	admin,
	Float:posX,
	Float:posY,
	Float:posZ,
	Float:angulo,
	Float:health,
	Float:armor,
	money,
	interior,
	vw,
	skin,
	score,
	ORM:ormid,
	bool:logado,
	pSalt[SALT_LEN]
};
new PlayerData[MAX_PLAYERS][PLAYER_DATA];