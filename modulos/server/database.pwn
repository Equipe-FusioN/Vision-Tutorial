function DataBaseInit()
{
	LoadDBSettings("dbconfig.ini");
	DBConn = mysql_connect(host, username, pass, database);
	if(mysql_errno() == 0)
	{
		printf("[MySQL] Database '%s' conectada com sucesso!", database);
		print("[MySQL] Verificando tabelas...");

        CheckPlayerTable();
		print("[MySQL] Tabela 'Player' verificada com sucesso!");

		CheckBanTable();
		print("[MySQL] Tabela 'Ban' verificada com sucesso!");
	}
	else
	{
		printf("[MySQL] ERRO: Não foi possível se conectar a database '%s'!", database);
		SendRconCommand("exit");
	}

	return 1;
}

stock CheckPlayerTable()
{
    mysql_query(DBConn, "CREATE TABLE IF NOT EXISTS Player (\
		id int NOT NULL AUTO_INCREMENT,\
		nome varchar(25) NOT NULL,\
		senha varchar(255) NOT NULL,\
		admin int DEFAULT 0,\
		PRIMARY KEY(id));", false);

    mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS health float DEFAULT 100;", false);
    mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS armor float DEFAULT 100;", false);
    mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS dinheiro int DEFAULT 100;", false);
    mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS posX double DEFAULT 0;", false);
    mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS posY double DEFAULT 0;", false);
	mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS posZ double DEFAULT 0;", false);
	mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS angulo double DEFAULT 0;", false);
	mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS interior int DEFAULT 0;", false);
	mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS vw int DEFAULT 0;", false);
	mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS score int DEFAULT 0;", false);
	mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS skin int DEFAULT 0;", false);
	mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS salt varchar(65) DEFAULT 0;", false);

	mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS fist int DEFAULT 0;", false);
    mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS white_gun int DEFAULT 0;", false);
    mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS pistol int DEFAULT 0;", false);
    mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS pistol_ammo int DEFAULT 0;", false);
    mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS shotgun int DEFAULT 0;", false);
    mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS shotgun_ammo int DEFAULT 0;", false);
    mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS machinegun int DEFAULT 0;", false);
    mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS machinegun_ammo int DEFAULT 0;", false);
    mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS fuzil int DEFAULT 0;", false);
    mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS fuzil_ammo int DEFAULT 0;", false);
    mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS rifle int DEFAULT 0;", false);
    mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS rifle_ammo int DEFAULT 0;", false);
}

stock CheckBanTable()
{
	mysql_query(DBConn, "CREATE TABLE IF NOT EXISTS Ban (\
		banid int NOT NULL AUTO_INCREMENT,\
		accid int NOT NULL,\
		PRIMARY KEY (banid),\
		FOREIGN KEY (accid) REFERENCES Player(id)\
	);", false);

	mysql_query(DBConn, "ALTER TABLE Ban ADD IF NOT EXISTS ip varchar(16) NOT NULL;", false);
	mysql_query(DBConn, "ALTER TABLE Ban ADD IF NOT EXISTS gpci varchar(64) NOT NULL;", false);
	mysql_query(DBConn, "ALTER TABLE Ban ADD IF NOT EXISTS adm varchar(25) NOT NULL;", false);
	mysql_query(DBConn, "ALTER TABLE Ban ADD IF NOT EXISTS ban int NOT NULL;", false);
	mysql_query(DBConn, "ALTER TABLE Ban ADD IF NOT EXISTS desban int NOT NULL;", false);
	mysql_query(DBConn, "ALTER TABLE Ban ADD IF NOT EXISTS motivo varchar(255) NOT NULL;", false);
}