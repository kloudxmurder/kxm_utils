---@param speed number in (secs)
---@param dots number dot count
kxm.minigame.untangle = function(speed, dots)
    local success = nil
    exports.kxm_minigames:Untangle(function(done)
        if done then success = true else success = false end
    end, speed, dots)

    while success == nil do
        Wait(100)
    end

    return success
end
