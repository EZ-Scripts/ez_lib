---@module Ox vs Qb Menus
---@description Ox vs Qb Menus

Ez_lib = Ez_lib or {}
Ez_lib.Functions = Ez_lib.Functions or {}

--- Function for input menu
---@param title string The title of the menu
---@param submitText string The text for the submit button
---@param options table The options for the menu (String type, String label, String value, String name, Table options, Boolean required)
---@usage Ez_lib.Functions.InputMenu("Test", "Submit", {type = "text", label = "Test", value = "Test"})
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

--- Function for menu
---@param title string The title of the menu
---@param options table The options for the menu(String title, String label, String image, String event, Table args, Boolean disabled)
---@usage Ez_lib.Functions.Menu("Test",)
local function Menu(title, options)
    local menu = {}
    if Config.Menu.Menu == "qb" then
        menu[#menu + 1] = { header = title, txt = "", isMenuHeader = true }
        menu[#menu+1] = { icon = "fas fa-circle-xmark", header = "", txt = "close", params = { event = "" } }
    end
    for k, v in pairs(options) do
        if Config.Menu.Menu == "qb" then
            v.label = string.gsub(v.label, "\n", "<br>")
        end
        v.header = v.title
        v.txt = v.label
        v.params = { event = v.event, args = v.args }
        v.description = v.label
        v.icon = v.image
        menu[#menu+1] = v
    end
    if Config.Menu.Menu == "qb" then
        exports['qb-menu']:openMenu(menu)
    elseif Config.Menu.Menu == "ox" then
        exports.ox_lib:registerContext({id = 'Ez_lib', title = title, position = 'top-right', options = menu })
		exports.ox_lib:showContext("Ez_lib")
    else
    end
end

---@section Assign Functions
Ez_lib.Functions.InputMenu = InputMenu
Ez_lib.Functions.Menu = Menu
