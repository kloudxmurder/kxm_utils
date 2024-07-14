---@param difficulty? number: This increases the amount of lock a player needs to unlock max: 5
kxm.minigame.safe_crack = function(difficulty)
    local success = nil
    exports.boii_minigames:safe_crack({
        style = 'default',
        difficulty = 5
    }, function(succ)
        success = succ
    end)

    while success == nil do
        Wait(100)
    end

    return success
end
