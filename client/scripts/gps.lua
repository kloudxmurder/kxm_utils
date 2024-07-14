local route_resource = nil

---@class gpsData
---@field color number: Reference https://docs.fivem.net/docs/game-references/hud-colors/
---@field coords vector3
---Colors: https://docs.fivem.net/docs/game-references/hud-colors/
---@param data gpsData
kxm.create_route = function(data)
    ClearGpsMultiRoute()

    StartGpsMultiRoute(data.color, true, true)

    AddPointToGpsMultiRoute(data.coords.x, data.coords.y, data.coords.z)
    SetGpsMultiRouteRender(true)

    route_resource = GetInvokingResource()
end

kxm.remove_route = function()
    ClearGpsMultiRoute()
end

AddEventHandler('onResourceStop', function(name)
    if route_resource ~= name then return end

    ClearGpsMultiRoute()
    route_resource = nil
end)