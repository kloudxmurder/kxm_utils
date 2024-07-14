---@param chips? number: Amount of chips required to find. Default: 2
---@param timer? number: Total allowed game time in seconds. Default: 20
kxm.minigame.chip_hack = function(chips, timer)
    local success = nil
    exports.boii_minigames:chip_hack({
        style = 'default',
        loading_time = 8000,
        chips = chips or 2,
        timer = timer * 1000 or 20000
    }, function(succ)
        success = succ
    end)

    while success == nil do
        Wait(100)
    end

    return success
end