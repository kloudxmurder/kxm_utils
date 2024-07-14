---@class cookData
---@field difficultyFactor? number The closer it is to 0, the more frequent the direction changes, increasing the difficulty.
---@field lineSpeedUp? number It sets how fast the bar you're tracking moves when you press and release the 'E' key.
---@field time? number It indicates the maximum amount of time in seconds within which you need to reach 100%.
---@field halfSuccessMin? number It specifies the minimum percentage completed when the time runs out for the task to be considered partially completed.
---@field valueUpSpeed? number It indicates the percentage increase per second while inside the bar area.
---@field valueDownSpeed? number It specifies the percentage decrease per second when outside the bar area.
---@field areaMoveSpeed? number It determines how fast the area we need to track moves.
---@field img? path | url Please ensure that the visuals you use are a maximum of 250px and in webp format.

---@param data cookData
kxm.minigame.cook = function(data)
    local success = nil
    local half = nil

    local minigameData = {
        difficultyFactor = data.difficultyFactor or 0.98,
        lineSpeedUp = data.lineSpeedUp or 1,
        time = data.time or 15,
        halfSuccessMin = data.halfSuccessMin or 80,
        valueUpSpeed = data.valueUpSpeed or 0.5,
        valueDownSpeed = data.valueDownSpeed or 0.3,
        areaMoveSpeed = data.areaMoveSpeed or 0.5,
        img = data.img or "img/fire.webp"

    }

    exports['nakres_skill_minigame']:GetMiniGame().Start(minigameData, function()
        -- success
        success = true
        half = false
    end, function()
        -- fail
        success = false
        half = false
    end, function()
        -- halfFail
        half = true
        success = false
    end)

    while success == nil and half == nil do
        Wait(100)
    end

    return success, half
end
