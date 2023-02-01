///////////////////////
// Actual Code Below //
///////////////////////

// List of Includes
#include <sourcemod>
#include <multicolors>

// The code formatting rules we wish to follow
#pragma semicolon 1;
#pragma newdecls required;


// The retrievable information about the plugin itself 
public Plugin myinfo =
{
	name		= "[CS:GO] Server Promoter",
	author		= "Manifest @Road To Glory",
	description	= "Frequently sends messages to the player to inform of the new server's IP.",
	version		= "V. 1.0.0 [Beta]",
	url			= ""
};


//////////////////////////
// - Global Variables - //
//////////////////////////

// Global Chars
char serverIP[256];

// - Global ConVars
ConVar cvar_NewServerIP;
ConVar cvar_SendChatMessages;
ConVar cvar_SendHudMessages;
ConVar cvar_SendConsoleMessages;
ConVar cvar_SendCenterMessages;

ConVar cvar_FrequencyChatMessage;
ConVar cvar_FrequencyHudMessage;
ConVar cvar_FrequencyConsoleMessage;
ConVar cvar_FrequencyCenterMessage;


//////////////////////////
// - Forwards & Hooks - //
//////////////////////////


// This happens when the plugin is loaded
public void OnPluginStart()
{
	cvar_NewServerIP 				= CreateConVar("ServerPromoter_NewServerIP", 				"0.0.0.0:00000",	"What is the new server's IP address?");

	cvar_SendChatMessages 			= CreateConVar("ServerPromoter_ChatMessages", 				"1", 		"Should the players receive a message in their chat? - [Yes = 1 | No = 0]");
	cvar_SendHudMessages 			= CreateConVar("ServerPromoter_HudMessages", 				"1", 		"Should the players receive a message in the bottom of their screen? - [Yes = 1 | No = 0]");
	cvar_SendConsoleMessages 		= CreateConVar("ServerPromoter_ConsoleeMessages", 			"1", 		"Should the players receive a message in their console? - [Yes = 1 | No = 0]");
	cvar_SendCenterMessages 		= CreateConVar("ServerPromoter_CenterMessages", 			"1", 		"Should the players receive a message in the middle of their screen? - [Yes = 1 | No = 0]");

	cvar_FrequencyChatMessage 		= CreateConVar("ServerPromoter_ChatMessagesFrequency", 		"6.0", 		"How frequently, in seconds, should the player receive a message in their chat? - [Default = 6.0]");
	cvar_FrequencyHudMessage 		= CreateConVar("ServerPromoter_HudMessagesFrequency", 		"2.0", 		"How frequently, in seconds, should the player receive a message in the bottom of their screen? - [Default = 2.0]");
	cvar_FrequencyConsoleMessage 	= CreateConVar("ServerPromoter_ConsoleeMessagesFrequency", 	"8.0", 		"How frequently, in seconds, should the player receive a message in their console? - [Default = 8.0]");
	cvar_FrequencyCenterMessage 	= CreateConVar("ServerPromoter_CenterMessagesFrequency", 	"0.9", 		"How frequently, in seconds, should the player receive a message in the middle of their screen? - [Default = 0.9]");

	// Automatically generates a config file that contains our variables
	AutoExecConfig(true, "custom_ServerPromoter");

	// Creates a timer that will send out chat messages every (Default: 5.0) seconds
	CreateTimer(GetConVarFloat(cvar_FrequencyChatMessage), Timer_ChatMessages, _, TIMER_REPEAT);

	// Creates a timer that will send out chat messages every (Default: 1.0) seconds
	CreateTimer(GetConVarFloat(cvar_FrequencyHudMessage), Timer_HudMessages, _, TIMER_REPEAT);

	// Creates a timer that will send out chat messages every (Default: 5.0) seconds
	CreateTimer(GetConVarFloat(cvar_FrequencyConsoleMessage), Timer_ConsoleMessages, _, TIMER_REPEAT);

	// Creates a timer that will send out chat messages every (Default: 1.0) seconds
	CreateTimer(GetConVarFloat(cvar_FrequencyCenterMessage), Timer_CenterMessages, _, TIMER_REPEAT);

	// Loads the translaltion file which we intend to use
	LoadTranslations("custom_ServerPromoter.phrases");
}



///////////////////////////////
// - Timer Based Functions - //
///////////////////////////////


// This happens once every (Default: 6.0) seconds
public Action Timer_ChatMessages(Handle timer)
{
	// If chat messages are supposed to be sent to the players then execute this section
	if(!GetConVarBool(cvar_SendChatMessages))
	{
		return Plugin_Continue;
	}

	// Obtains the new server's specified IP from our configurable convar
	GetConVarString(cvar_NewServerIP, serverIP, sizeof(serverIP));

	// Loops through all of the clients
	for (int client = 1; client <= MaxClients; client++)
	{
		// If the client does not meet our validation criteria then execute this section
		if(!IsValidClient(client))
		{
			continue;
		}

		// If the client is a bot then execute this section
		if(IsFakeClient(client))
		{
			continue;
		}

		// Formats the message and sends it in the hint area of the player's screen
		SendChatMessages(client);
	}

	return Plugin_Continue;
}


// This happens once every (Default: 2.0) seconds
public Action Timer_HudMessages(Handle timer)
{
	// If hud messages are supposed to be sent to the players then execute this section
	if(!GetConVarBool(cvar_SendHudMessages))
	{
		return Plugin_Continue;
	}

	// Obtains the new server's specified IP from our configurable convar
	GetConVarString(cvar_NewServerIP, serverIP, sizeof(serverIP));

	// Loops through all of the clients
	for (int client = 1; client <= MaxClients; client++)
	{
		// If the client does not meet our validation criteria then execute this section
		if(!IsValidClient(client))
		{
			continue;
		}

		// If the client is a bot then execute this section
		if(IsFakeClient(client))
		{
			continue;
		}

		// Formats the message and sends it in the clients console
		SendConsoleMessages(client);

		// Formats the message and sends it in the hint area of the player's screen
		SendHintMessages(client);
	}

	return Plugin_Continue;
}


// This happens once every (Default: 8.0) seconds
public Action Timer_ConsoleMessages(Handle timer)
{
	// If console messages are supposed to be sent to the players then execute this section
	if(!GetConVarBool(cvar_SendConsoleMessages))
	{
		return Plugin_Continue;
	}

	// Obtains the new server's specified IP from our configurable convar
	GetConVarString(cvar_NewServerIP, serverIP, sizeof(serverIP));

	// Loops through all of the clients
	for (int client = 1; client <= MaxClients; client++)
	{
		// If the client does not meet our validation criteria then execute this section
		if(!IsValidClient(client))
		{
			continue;
		}

		// If the client is a bot then execute this section
		if(IsFakeClient(client))
		{
			continue;
		}

		// Formats the message and sends it in the clients console
		SendConsoleMessages(client);
	}

	return Plugin_Continue;
}


// This happens once every (Default: 0.9) seconds
public Action Timer_CenterMessages(Handle timer)
{
	// If screen center messages are supposed to be sent to the players then execute this section
	if(!GetConVarBool(cvar_SendCenterMessages))
	{
		return Plugin_Continue;
	}

	// Obtains the new server's specified IP from our configurable convar
	GetConVarString(cvar_NewServerIP, serverIP, sizeof(serverIP));

	// Loops through all of the clients
	for (int client = 1; client <= MaxClients; client++)
	{
		// If the client does not meet our validation criteria then execute this section
		if(!IsValidClient(client))
		{
			continue;
		}

		// If the client is a bot then execute this section
		if(IsFakeClient(client))
		{
			continue;
		}

		// Formats the message and sends it in the center of the player's screen
		SendCenterMessages(client);
	}

	return Plugin_Continue;
}



///////////////////////////
// - Regular Functions - //
///////////////////////////


// This happens once every (default: 6.0) seconds if the chat messages are enabled
public void SendChatMessages(int client)
{
	// Sends a message in the player's chat area
	PrintToChat(client, " ");
	CPrintToChat(client, "%t", "Message - Chat", serverIP);
}


// This happens once every (default: 2.0) seconds if the hint messages are enabled
public void SendHintMessages(int client)
{
	// Sends a message in the hud area of the player's screen
	PrintHintText(client, "%t", "Message - Hint Area", serverIP);
}


// This happens once every (default: 8.0) seconds if the console messages are enabled
public void SendConsoleMessages(int client)
{
	// Sends a message in the player's console
	PrintToConsole(client, "");
	PrintToConsole(client, "");
	PrintToConsole(client, "%t", "Message - Player Console First Line");
	PrintToConsole(client, "%t", "Message - Player Console Second Line");
	PrintToConsole(client, serverIP);
	PrintToConsole(client, "");
	PrintToConsole(client, "");
}


// This happens once every (default: 9.0) seconds if the center screen messages are enabled
public void SendCenterMessages(int client)
{
	// Defines the hud message parameters 
	SetHudTextParams(-1.0, 0.2, 5.0, 255, 255, 255, 255, 0, 6.0, 0.1, 0.2);

	// Sends a message in the top of the counter-terrorist players' screen
	ShowHudText(client, 5, "%t", "Message - Center Screen", serverIP);
}



////////////////////////////////
// - Return Based Functions - //
////////////////////////////////


// Returns true if the client meets the validation criteria. elsewise returns false
public bool IsValidClient(int client)
{
	if(!(1 <= client <= MaxClients) || !IsClientConnected(client) || !IsClientInGame(client) || IsClientSourceTV(client) || IsClientReplay(client))
	{
		return false;
	}

	return true;
}
