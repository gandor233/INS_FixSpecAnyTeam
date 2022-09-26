/*
 * @Description: 修复mp_forcecamera设置为0后导致服务器崩溃的问题。好用的话Github给颗星吧。
 * @Author: Gandor233
 * @Github: https://github.com/gandor233
 * @Date: 2022-09-26 14:23:42
 * @LastEditTime: 2022-09-26 14:51:27
 * @LastEditors: Gandor233
 */

#pragma semicolon 1
#include <sourcemod>

#define PLUGIN_VERSION "1.0"

public Plugin myinfo = {
    name = "INS_FixSpecAnyTeam",
    author = "Gandor233",
    description = "Fix any team spectator mode crash server bug for insurgency(2014).",
    version = PLUGIN_VERSION,
    url = "https://github.com/gandor233/INS_FixSpecAnyTeam"
};

ConVar sm_ins_fsat_version;
ConVar mp_forcecamera;
ConVar sm_spec_any_team;

public void OnPluginStart()
{
    sm_ins_fsat_version = CreateConVar("sm_ins_fsat_version", PLUGIN_VERSION, "INS_FixSpecAnyTeam Plugin Version", FCVAR_REPLICATED|FCVAR_NOTIFY);

    mp_forcecamera = FindConVar("mp_forcecamera");
    sm_spec_any_team = CreateConVar("sm_spec_any_team", "0", "(bool) Enable spec any team");
    
    HookEvent("player_death", Event_PlayerDeathPre, EventHookMode_Pre);
    HookEvent("player_spawn", Event_SpawnPost, EventHookMode_PostNoCopy);
    return;
}

public Action Event_PlayerDeathPre(Event event, const char[] name, bool dontBroadcast)
{
    if (mp_forcecamera.IntValue == 0)
    {
        if (GetAlivePlayerCount() <= 1)
            mp_forcecamera.IntValue = 1;
    }
    return Plugin_Continue;
}

public void Event_SpawnPost(Event event, const char[] name, bool dontBroadcast)
{
    RequestFrame(OnPlayerSpawnPost);
    return;
}
public void OnPlayerSpawnPost()
{
    if (sm_spec_any_team.BoolValue)
    {
        if (GetAlivePlayerCount() > 0)
            mp_forcecamera.IntValue = 0;
    }
    return;
}

stock int GetAlivePlayerCount()
{
    int iPlayerCount = 0;
    for (int client = 1; client <= MaxClients; client++)
    {
        if (IsClientInGame(client))
        {
            if (IsPlayerAlive(client))
                iPlayerCount++;
        }
    }
    return iPlayerCount;
}