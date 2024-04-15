---@module Functions (server)
---@description Functions using fivem nattives

Ns_lib = Ns_lib or {}
Ns_lib.Functions = Ns_lib.Functions or {}

--- Function to get all players
---@return table
---@usage local players = Ns_lib.Functions.GetPlayers()
local function get_players()
    local players = {}
    for _, playerId in ipairs(GetPlayers()) do
        table.insert(players, playerId)
    end
    return players
end

---@section Assign Functions
Ns_lib.Functions.GetPlayers = get_players