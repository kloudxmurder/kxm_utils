---@param isAdvanced boolean: is using advanced lockpick?
---@param difficulty number: Default: 2
---@param pins number: Default: 4
kxm.minigame.lockpick = function(isAdvanced, difficulty, pins)
    local success = exports.t3_lockpick:startLockpick(isAdvanced and 0.75 or 0.5, difficulty, pins)

    return success
end