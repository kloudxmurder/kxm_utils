local keybinds_disabled = false
local disabled_controls = {}

---@return boolean
kxm.keybinds_disabled = function()
    return keybinds_disabled
end

---@param bool boolean
kxm.disable_keybinds = function(bool)
    keybinds_disabled = bool
end

---@param key string: Key Name
---@param desc string: Description
---@param command string: Command name
kxm.add_keybind = function(key, desc, command)
    RegisterKeyMapping(command, desc, 'keyboard', key)
end

---@param controls number | table
kxm.disable_control = function(controls)
    local dataType = type(controls)

    if dataType == 'number' then
        disabled_controls[controls] = controls
    elseif dataType == 'table' and table.type(controls) == 'array' then
        for i = 1, #controls do
            for i2 = 1, #controls do
                disabled_controls[i2] = controls[i2]
            end
        end
    end
end

---@param controls number | table
kxm.enable_control = function(controls)
    local dataType = type(controls)

    if dataType == 'number' then
        for i = 1, #disabled_controls do
            if disabled_controls[i] == controls then
                disabled_controls[i] = nil
                break
            end
        end
    elseif dataType == 'table' and table.type(controls) == "array" then
        for i = 1, #disabled_controls do
            for i2 = 1, #controls do
                if disabled_controls[i] == controls[i2] then
                    disabled_controls[i] = nil
                end
            end
        end
    end
end

kxm.get_disabled_controls = function()
    return disabled_controls
end

CreateThread(function()
    SetInterval(function()
        for i = 1, #disabled_controls do
            DisableControlAction(2, disabled_controls[i], true)
        end
    end, 0)
end)