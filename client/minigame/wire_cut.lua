---@param timer? number: in seconds, automatically converted by multiplying to 1000. Default: 60 seconds
kxm.minigame.wire_cut = function(timer)
    local success = nil
    exports.boii_minigames:wire_cut({
        style = 'default',
        timer = timer * 1000 or 60000
    }, function(succ)
        success = succ
    end)

    while success == nil do
        Wait(100)
    end

    return success
end