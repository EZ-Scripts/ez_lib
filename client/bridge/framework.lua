--- @module Framework (Client Side)
--- @description Framework system bridge for FiveM

Framework = Framework or nil
Ns_lib = Ns_lib or {}
Ns_lib.Functions = Ns_lib.Functions or {}

--- @section Initialization

--- Initializes the connection to the specified framework when the resource starts.
-- Supports ''qb-core', 'es_extended', edit if needed
CreateThread(function()
    while GetResourceState(Config.Framework) ~= 'started' do
        Wait(500)
    end
    if Config.Framework == 'qb-core' then
        Framework = exports['qb-core']:GetCoreObject()
    elseif Config.Framework == 'es_extended' then
        Framework = exports['es_extended']:getSharedObject()
    end
end)

--- @section Callback functions

--- Callback function has_item Function to check if player has item
---@param item string The item to check
---@param amount integer The amount of the item to check
---@param cb function Callback function
local function has_item(item, amount)
    local item = tostring(item)
    local amount = tonumber(amount) or 1
    DebugPrint("^5Debug^7: ^2Checking if player has item: '^6" .. item .. "^7' Amount: '^6" .. amount)
    return Ns_lib.Functions.TriggerCallback('ns_lib:server:has_item', {item = item, amount = amount})
end

--- @section Functions

--- Retrieves player data based on the framework
--- @return table
--- @usage local player = Ns_lib.Functions.GetPlayerData(source)
local function get_player_data()
    DebugPrint("^5Debug^7: ^2Getting player data")
    local player
    if Config.Framework == 'qb-core' then
        player = Framework.Functions.GetPlayerData()
    elseif Config.Framework == 'es_extended' then
        player = Framework.GetPlayerData()
    end
    return player
end

--- Gets the player's job based on the framework
--- @return string
--- @usage local job = Ns_lib.Functions.GetPlayerJob()
local function get_player_job()
    local playerData = get_player_data()
    return playerData.job.name
end

--- Gets all players in server
--- @return table
--- @usage local players = Ns_lib.Functions.GetPlayers()
local function get_players()
    local players = {}
    if Config.Framework == 'qb-core' then
        players = Framework.Functions.GetPlayers()
    elseif Config.Framework == 'es_extended' then
        players = Framework.Game.GetPlayers()
    end
    return players
end

--- @Section Assign Functions
Ns_lib.Functions.HasItem = has_item
Ns_lib.Functions.GetPlayerData = get_player_data
Ns_lib.Functions.GetPlayerJob = get_player_job
Ns_lib.Functions.GetPlayers = get_players


--- @section Client Events



