---@module Ox vs Qb Menus
---@description Ox vs Qb Menus

Ns_lib = Ns_lib or {}
Ns_lib.Functions = Ns_lib.Functions or {}

--- Function for input menu
---@param title string The title of the menu
---@param submitText string The text for the submit button
---@param options table The options for the menu (String type, String label, String value, String name, Table options, Boolean required)
---@usage Ns_lib.Functions.InputMenu("Test", "Submit", {type = "text", label = "Test", value = "Test"})
local function InputMenu(title, submittext, options)
    if Config.Menu.Input == "qb" then
        local multi = {}
        for k, v in pairs(options) do
            v.text = v.label
            v.isRequired = v.required
            v.default = v.placeholder
            if v.type == "checkbox" then
                v.type = "select"
                v.options = {
                    {text = "Yes", value = true},
                    {text = "No", value = false}
                }
            elseif v.type == "input" then
                v.type = "text"
            elseif v.type == "slider" then
                v.type = "number"
            elseif v.type == "multi-select" then
                v.type = "checkbox"
                multi[v.name] = {}
                for i, t in pairs(v.options) do
                    table.insert(multi[v.name], t.value)
                end
            end
            if v.options then
                for i, t in pairs(v.options) do
                    t.text = t.label
                end
            end
        end
        local input = exports['qb-input']:ShowInput({header = title, submitText = submittext, inputs = options})
        if input then
            for h, j in pairs(multi) do
                input[h] = {}
                for i, t in pairs(j) do
                    if input[t] == "true" then
                        table.insert(input[h], t)
                    end
                    input[t] = nil
                end
            end
        end
        return input
    elseif Config.Menu.Input == "ox" then
        local input = lib.inputDialog(title, options)

        local res = {}
        
        if input == nil then
            return nil
        end
        for k, v in pairs(input) do
            res[options[k].name] = input[k]
        end
        return res
    else
    end
end

---@section Assign Functions
Ns_lib.Functions.InputMenu = InputMenu