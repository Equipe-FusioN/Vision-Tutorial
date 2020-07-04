new Text:gData;
new Text:hora;
new gametime;

CreateClock()
{
	gData = TextDrawCreate(577.000000, 8.000000, "00/00/0000");
	TextDrawFont(gData, 3);
	TextDrawLetterSize(gData, 0.266665, 1.299998);
	TextDrawTextSize(gData, 400.000000, 17.000000);
	TextDrawSetOutline(gData, 2);
	TextDrawSetShadow(gData, 0);
	TextDrawAlignment(gData, 2);
	TextDrawColor(gData, -1);
	TextDrawBackgroundColor(gData, 255);
	TextDrawBoxColor(gData, 50);
	TextDrawUseBox(gData, 0);
	TextDrawSetProportional(gData, 1);
	TextDrawSetSelectable(gData, 0);

	hora = TextDrawCreate(577.000000, 20.000000, "00:00");
	TextDrawFont(hora, 3);
	TextDrawLetterSize(hora, 0.554166, 2.449999);
	TextDrawTextSize(hora, 400.000000, 17.000000);
	TextDrawSetOutline(hora, 2);
	TextDrawSetShadow(hora, 0);
	TextDrawAlignment(hora, 2);
	TextDrawColor(hora, -1);
	TextDrawBackgroundColor(hora, 255);
	TextDrawBoxColor(hora, 50);
	TextDrawUseBox(hora, 0);
	TextDrawSetProportional(hora, 1);
	TextDrawSetSelectable(hora, 0);

    new string[12], globaldate[3];
    getdate(globaldate[2], globaldate[1], globaldate[0]);
    format(string,sizeof(string), "%02d/%02d/%04d", globaldate[0], globaldate[1], globaldate[2]);
    TextDrawSetString(gData, string);
    ProcessGameTime();
    gametime = SetTimer("ProcessGameTime", 60000, true);
}

HideClock(playerid)
{
    TextDrawHideForPlayer(playerid, gData);
    TextDrawHideForPlayer(playerid, hora);
}

ShowClock(playerid)
{
    TextDrawShowForPlayer(playerid, gData);
    TextDrawShowForPlayer(playerid, hora);
}

DestroyClock()
{
    KillTimer(gametime);
	TextDrawDestroy(gData);
	TextDrawDestroy(hora);
	return 1;
}

function ProcessGameTime()
{
    new string[12], globaltime[3];

    gettime(globaltime[2], globaltime[1], globaltime[0]);
    format(string,sizeof(string), "%02d:%02d", globaltime[2], globaltime[1]);
    TextDrawSetString(hora, string);

    if(globaltime[2] == 0 && globaltime[1] == 0)
    {
        new globaldate[3];
        getdate(globaldate[2], globaldate[1], globaldate[0]);
        format(string,sizeof(string), "%02d/%02d/%04d", globaldate[0], globaldate[1], globaldate[2]);
        TextDrawSetString(gData, string);
    }

    return 1;
}