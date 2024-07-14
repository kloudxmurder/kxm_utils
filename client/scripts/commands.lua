---@class commandData
---@field command string
---@field func any
---@field helpText string
---@field params any

---@param data commandData
kxm.register_command = function(data)
    RegisterCommand(data.command, data.func)
    TriggerEvent('chat:addSuggestion', '/'..data.command, data.helpText, data.params)
end