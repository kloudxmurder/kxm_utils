local is_busy = false

---@return boolean
kxm.is_busy = function()
    return is_busy
end

kxm.set_busy = function(bool)
    is_busy = bool
    kxm.target.disableTargeting(bool)
    LocalPlayer.state:set('invBusy', bool, false)
    LocalPlayer.state.busy = bool
    TriggerEvent('kloud:point:client:setPointingState', false)
end

AddEventHandler("onResourceStop", function(name)
    if name ~= GetCurrentResourceName() then return end

    kxm.set_busy(false)
end)
