---@param attempts? number
kxm.minigame.fallout = function(attempts)
    local success = exports['tgiann-fallouthacker']:openMenu(attempts)

    while success == nil do
        Wait(100)
    end

    return success
end
