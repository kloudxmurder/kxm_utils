---@param id string
---@param msg string
---@param keybind string
kxm.draw_text = function (id, msg, keybind)
    if not id then id = 'default' end
    exports['five-textui']:showTextUI(id, msg, keybind)
end

---@param id string
kxm.hide_text = function(id)
    if not id then id = "default" end
    exports['five-textui']:hideTextUI(id)
end