--- @module Framework (Client Side)
--- @description Framework system bridge for FiveM

Framework = Framework or nil
Ez_lib = Ez_lib or {}
Ez_lib.Functions = Ez_lib.Functions or {}

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
    else
        -- Your custom code here
    end
end)

--- @section Callback functions

--- Callback function has_item Function to check if player has item
---@param item string The item to check
---@param amount integer The amount of the item to check
---@param cb function Callback function
---@Deprecated
local function has_item(item, amount)
    local item = tostring(item)
    local amount = tonumber(amount) or 1
    DebugPrint("Checking if player has item", amount)
    return Ez_lib.Functions.TriggerCallback(ResourceName..":server:has_item", {item = item, amount = amount})
end

--- @section Functions

--- Retrieves player data based on the framework
--- @return table
--- @usage local player = Ez_lib.Functions.GetPlayerData(source)
local function get_player_data()
    DebugPrint("Getting player data", "this player")
    local player
    if Config.Framework == 'qb-core' then
        player = Framework.Functions.GetPlayerData()
    elseif Config.Framework == 'es_extended' then
        player = Framework.GetPlayerData()
    else
        -- Your custom code here
    end
    return player
end

--- Gets the player's job based on the framework
--- @return string
--- @usage local job = Ez_lib.Functions.GetPlayerJob()
local function get_player_job()
    local playerData = get_player_data()
    return playerData.job.name
end

--- Gets all players in server
--- @return table
--- @usage local players = Ez_lib.Functions.GetPlayers()
local function get_players()
    local players = {}
    if Config.Framework == 'qb-core' then
        players = Framework.Functions.GetPlayers()
    elseif Config.Framework == 'es_extended' then
        players = Framework.Game.GetPlayers()
    else
        -- Your custom code here
    end
    return players
end

--- Get player items
--- @return table
--- @usage local items = Ez_lib.Functions.GetPlayerItems()
local function get_player_items()
    local playerData = get_player_data()
    local items = {}

    if Config.Framework == 'qb-core' then
        local countingName = "amount"
        if Config.Inventory == "ox_inventory" then countingName = "count" end
        for k, v in pairs(playerData.items) do
            if items[v.name] then
                items[v.name].amount = items[v.name].amount + v[countingName]
            else     
                items[v.name] = { amount = v[countingName], label = v.label, name = v.name, weight = v.weight or 1 }
            end
        end
    elseif Config.Framework == 'es_extended' then
        for k,v in pairs(playerData.inventory) do
            if v.count > 0 then
                if items[v.name] then
                    items[v.name].amount = items[v.name].amount + v.count
                else
                    items[v.name] = { amount = v.count, label = v.label, name = v.name, weight = v.weight }
                end
            end
        end
    else
        -- Your custom code here
    end

    DebugPrint("Getting player items", json.encode(items))
    return items
end

--- @Section Assign Functions
Ez_lib.Functions.HasItem = has_item -- Deprecated
Ez_lib.Functions.GetPlayerData = get_player_data
Ez_lib.Functions.GetPlayerJob = get_player_job
Ez_lib.Functions.GetPlayers = get_players
Ez_lib.Functions.GetPlayerItems = get_player_items


--- @section Client Events



