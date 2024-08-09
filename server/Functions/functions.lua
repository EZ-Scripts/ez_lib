---@module Functions (server)
---@description Functions using fivem nattives

Ez_lib = Ez_lib or {}
Ez_lib.Functions = Ez_lib.Functions or {}

--- Function to get all players
---@return table
---@usage local players = Ez_lib.Functions.GetPlayers()
local function get_players()
    local players = {}
    for _, playerId in ipairs(GetPlayers()) do
        table.insert(players, playerId)
    end
    return players
end

---@section Assign Functions
Ez_lib.Functions.GetPlayers = get_players