---@module Functions (server)
---@description Functions using fivem nattives

Ez_lib = Ez_lib or {}
Ez_lib.Functions = Ez_lib.Functions or {}

--- Function to get all players id
---@return table
---@usage local players = Ez_lib.Functions.GetPlayers()
local function get_players()
    local players = {}
    for _, playerId in ipairs(GetPlayers()) do
        table.insert(players, playerId)
    end
    return players
end

--- Function to execute sql queries
--- This function is used to execute sql queries
---@param query string The query to execute
---@return table
---@usage local result = Ez_lib.Functions.ExecuteSql("SELECT * FROM users")
local function execute_sql(query)
    local IsBusy = true
    local result = nil
    if Config.SQL == "oxmysql" then
        if MySQL == nil then
            exports.oxmysql:execute(query, function(data)
                result = data
                IsBusy = false
            end)
        else
            MySQL.query(query, {}, function(data)
                result = data
                IsBusy = false
            end)
        end
    elseif Config.SQL == "ghmattimysql" then
        exports.ghmattimysql:execute(query, {}, function(data)
            result = data
            IsBusy = false
        end)
    elseif Config.SQL == "mysql-async" then   
        MySQL.Async.fetchAll(query, {}, function(data)
            result = data
            IsBusy = false
        end)
    end
    while IsBusy do
        Citizen.Wait(0)
    end
    return result
end

local DISCORD_NAME = "EZ Scripts"
local DISCORD_IMAGE = "https://cdn.discordapp.com/attachments/890000000000000000/890000000000000000/ez_scripts.png"

--- Function to send message to discord
--- This function is used to send message to discord
--- @param webhook string The webhook to send message
--- @param name string The name of the message
--- @param message string The message to send
--- @param color integer The color of the message
--- @usage Ez_lib.Functions.SendToDiscord("CHANGE_WEBHOOK", "EZ Scripts", "Hello World", 16711680)
local function send_to_discord(webhook, name, message, color)
	if webhook == "CHANGE_WEBHOOK" then
	else
		local connect = {
            {
                ["color"] = color,
                ["title"] = "**".. name .."**",
                ["description"] = message,
                ["footer"] = {
                ["text"] = "EZ Scripts",
                },
            },
	    }
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatarrl = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
	end
end

---@section Assign Functions
Ez_lib.Functions.GetPlayers = get_players
Ez_lib.Functions.ExecuteSql = execute_sql
Ez_lib.Functions.SendToDiscord = send_to_discord
