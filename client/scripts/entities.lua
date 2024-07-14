---@class coordsData
---@field entity number: entityID
---@field coords vector4

---@class headingData
---@field entity number: entityID
---@field heading number

---@param entity number: entity ID
kxm.delete_entity = function(entity)
    if NetworkHasControlOfEntity(entity) then
        DeleteEntity(entity)
    else
        kxm.execute_from_owner("DeleteEntity", entity)
    end
end

---@param data coordsData
kxm.set_entity_coords = function(data)
    if NetworkHasControlOfEntity(data.entity) then
        SetEntityCoords(data.entity, data.coords.x, data.coords.y, data.coords.z)
        SetEntityHeading(data.entity, data.coords.w)
    else
        kxm.execute_from_owner("SetEntityCoords", data.entity, data.coords.x, data.coords.y, data.coords.z)
        kxm.execute_from_owner("SetEntityHeading", data.entity, data.coords.w)
    end
end

---@param data headingData
kxm.set_entity_heading = function(data)
    if NetworkHasControlOfEntity(data.entity) then
        SetEntityHeading(data.entity, data.heading)
    else
        kxm.execute_from_owner("SetEntityHeading", data.entity, data.heading)
    end
end

RegisterNetEvent("kxm_utils:client:deleteEntity", function(entity)
    kxm.delete_entity(entity)
end)
