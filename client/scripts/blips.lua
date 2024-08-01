local blips_data = {}

---@class blipData
---@field coords vector3
---@field sprite integer: Reference: https://docs.fivem.net/docs/game-references/blips/
---@field scale number
---@field color number: Reference: https://docs.fivem.net/docs/game-references/blips/#blip-colors
---@field label string
---@param data blipData
kxm.add_blip = function(data)
    local blipID = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
    local color = GetConvar('kxm:bnw', 'false') == 'true' and 0 or data.color
    SetBlipSprite(blipID, data.sprite)
    SetBlipDisplay(blipID, 4)
    SetBlipScale(blipID, data.scale)
    SetBlipColour(blipID, color)
    SetBlipAsShortRange(blipID, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.label)
    EndTextCommandSetBlipName(blipID)

    blips_data[blipID] = {
        id = blipID,
        resource = GetInvokingResource()
    }

    return blipID
end

kxm.add_blip_radius = function(data)
    local coords = { x = data.coords.x, y = data.coords.y, z = data.coords.z}
    if data.displace then
        for k, v in pairs(coords) do
            local negative = (math.random(1, 2) == 2) and -1 or 1
            local min = math.floor(data.radius * 0.15)
            local max = math.floor(data.radius * 0.5)
            coords[k] = coords[k] + (math.random(min, max) * negative)
        end
    end

    local blipID = AddBlipForRadius(coords.x, coords.y, coords.z, data.radius)
    SetBlipColour(blipID, data.color)
    SetBlipAlpha(blipID, data.alpha)

    blips_data[blipID] = {
        id = blipID,
        resource = GetInvokingResource()
    }
    return blipID
end
---@param id blipID
kxm.remove_blip = function(id)
    RemoveBlip(id)
    blips_data[id] = nil
end

AddEventHandler('onResourceStop', function(name)
    if not next(blips_data) then return end
    for _, v in pairs(blips_data) do
        if v.resource == name then
            kxm.remove_blip(v.id)
        end
    end
end)
