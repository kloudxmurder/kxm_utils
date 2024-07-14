---@param iterations number: Iterations
---@param difficulty number: number (1-100) is the difficulty of the minigame, this will affect the speed of the circle.
kxm.minigame.progress = function(iterations, difficulty)
    local success = exports.bl_ui:Progress(iterations, difficulty)

    return success
end