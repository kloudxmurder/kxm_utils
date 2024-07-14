---@param iterations number: Iterations
---@param difficulty number: number (1-100) is the difficulty of the minigame, this will affect the speed of the circle.
kxm.minigame.key_spam = function(iterations, difficulty)
    local success = exports.bl_ui:KeySpam(iterations, difficulty)

    return success
end