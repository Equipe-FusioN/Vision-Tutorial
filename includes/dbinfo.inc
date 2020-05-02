new MySQL:DBConn,
    host[16], 
    pass[16],
    username[MAX_PLAYER_NAME],
    database[MAX_PLAYER_NAME];

stock LoadDBSettings(const filename[])
{
	//new host[16], username[MAX_PLAYER_NAME], database[MAX_PLAYER_NAME], pass[16];
	if(DOF2_FileExists(filename))
	{
		format(host, sizeof(host), "%s", DOF2_GetString(filename,"address"));
		format(username, sizeof(username), "%s", DOF2_GetString(filename,"username"));
		format(database, sizeof(database), "%s", DOF2_GetString(filename,"database"));
		format(pass, sizeof(pass), "%s", DOF2_GetString(filename,"password"));
	}
	else
	{
		DOF2_CreateFile(filename);
		DOF2_SetString(filename,"address","127.0.0.1");
		DOF2_SetString(filename,"username","root");
		DOF2_SetString(filename,"database", " ");
		DOF2_SetString(filename,"password", " ");
		DOF2_SaveFile();
	}
}