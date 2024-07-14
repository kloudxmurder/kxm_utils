---@param iterations number: the amount of iterations the player has to complete.
---@param difficulty number: number (1-100) is the difficulty of the minigame, this will affect the speed of the circle.
---@param numberOfKeys number: the amount of set of keys the player has to press.
kxm.minigame.number_slide = function(iterations, difficulty, numberOfKeys)
    local success = exports.bl_ui:NumberSlide(iterations, difficulty, numberOfKeys)

    return success
end