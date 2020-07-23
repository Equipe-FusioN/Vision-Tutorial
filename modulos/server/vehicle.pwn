#include <YSI_Coding\y_hooks>

stock AddVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2)
{
    new vehicleid = CreateVehicle(vehicletype, x, y, z, rotation, color1, color2, -1);
    VehicleData[vehicleid][vFuel] = 100.0;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleSeat(playerid) == 0 && PRESSED(KEY_FIRE))
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(VehicleData[vehicleid][vFuel] <= 0.0)
            return SendClientMessage(playerid, COR_VERMELHO, "Veículo sem combustível!");

        new engine, lights, alarm, doors, bonnet, boot, objective;
        GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

        if(engine > 0) // veiculo esta ligado
        {
            SetVehicleParamsEx(vehicleid, 0, 0, alarm, doors, bonnet, boot, objective);
            KillTimer(VehicleData[vehicleid][vTimer]);
            SendClientMessage(playerid, COR_VERMELHO, "Veículo desligado!");
        }
        else //veiculo esta desligado
        {
            SetVehicleParamsEx(vehicleid, 1, 1, alarm, doors, bonnet, boot, objective);
            SendClientMessage(playerid, COR_VERMELHO, "Veículo ligado!");
            VehicleData[vehicleid][vTimer] = SetTimerEx("FuelTimer", 1000, true, "d", vehicleid);
        }
    }
    return 1;
}

function FuelTimer(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

    if(engine > 0)
        VehicleData[vehicleid][vFuel] -= 0.08;

    if(VehicleData[vehicleid][vFuel] <= 0)
    {
        VehicleData[vehicleid][vFuel] = 0.0;
        SetVehicleParamsEx(vehicleid, 0, 0, alarm, doors, bonnet, boot, objective);
        KillTimer(VehicleData[vehicleid][vTimer]);
        foreach(new i : Player)
            if(IsPlayerInVehicle(i, vehicleid) && GetPlayerVehicleSeat(i) == 0)
            {
                SendClientMessage(i, COR_VERMELHO, "Veículo sem combustível!");
                break;
            }
    }
    return 1;
}