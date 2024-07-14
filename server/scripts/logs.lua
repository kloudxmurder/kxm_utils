---@class logsData
---@field message string
---@field playerID number
---@field playerID2 number
---@field channel string
---@field screenshot boolean
---@field screenshot2 boolean
---@field title string
---@field color table
---@field icon string

---@param data logsData
kxm.logs = function(data)
    if GetResourceState('JD_logsV3') ~= 'started' then return end

    exports.JD_logsV3:createLog({
        EmbedMessage = data.message,
        player_id = data.playerID,
        player_2_id = data.playerID2,
        channel = data.channel,
        screenshot = data.screenshot,
        screenshot2 = data.screenshot2,
        title = data.title,
        color = data.color,
        icon = data.icon
    })
end

RegisterNetEvent('kloud:server:logs', kxm.logs)