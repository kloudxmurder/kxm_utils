---@param difficulty number  Default 4
---@param guesses number Default 5
---@param timer number Default 30
kxm.minigame.anagram = function(difficulty, guesses, timer)
    local success = nil
    exports.boii_minigames:anagram({
        style = 'default',
        loading_time = 5000,
        difficulty = difficulty or 4,
        guesses = guesses or 5,
        timer = timer * 1000
    }, function(succ)
        success = succ
    end)

    while success == nil do
        Wait(100)
    end

    return success
end
