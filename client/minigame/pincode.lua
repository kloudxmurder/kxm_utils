---@param difficulty? number: increasing the value increases the amount of numbers in the pincode; level 1 = 4 number, level 2 = 5 numbers and so on
---@param guesses? number:  Amount of guesses allowed before fail
kxm.minigame.pincode = function(difficulty, guesses)
    local success = nil
    exports.boii_minigames:pincode({
        style = 'default',
        difficulty = difficulty or 4,
        guesses = guesses or 5
    }, function(succ)
        success = succ
    end)

    while success == nil do
        Wait(100)
    end

    return success
end