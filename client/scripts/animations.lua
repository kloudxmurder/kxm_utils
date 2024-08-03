
---@class propData
---@field model string
---@field bone? number
---@field coords vector3
---@field rotation vector3

---@class animData
---@field entity any: entity ID
---@field dict string: animation dictionary
---@field name string: animation name
---@field duration number: duration in (ms) or -1
---@field upperbody boolean
---@field prop propData

local prop

---@param data animData
kxm.play_anim = function(data)
    local flag = data.upperbody and 49 or 1
    local duration = data.duration or -1
    if not HasAnimDictLoaded(data.dict) then
        lib.requestAnimDict(data.dict)
    end

    if NetworkHasControlOfEntity(data.entity) then
        TaskPlayAnim(data.entity, data.dict, data.name, 8.0, 8.0, duration, flag, 0.0, false, false, false)
    else
        kxm.execute_from_owner("TaskPlayAnim", data.entity, data.dict, data.name, 8.0, 8.0, duration, flag, 0.0, false, false, false)
    end

    if data.prop then
        if IsModelInCdimage(data.prop.model) then
            lib.requestModel(data.prop.model)
            prop = CreateObject(data.prop.model, GetEntityCoords(data.entity), true, true, true)
            repeat Wait(100) until DoesEntityExist(prop)
            AttachEntityToEntity(prop, data.entity, GetPedBoneIndex(data.entity, data.prop.bone or 60309), data.prop.coords.x or 0.0, data.prop.coords.y or 0.0, data.prop.coords.z or 0.0, data.prop.rotation.x or 0.0, data.prop.rotation.y or 0.0, data.prop.rotation.z or 0.0, 1, 1, 0, 1, 0, 1)
            SetModelAsNoLongerNeeded(data.prop.model)
        end
    end

    RemoveAnimDict(data.dict)
end

kxm.stop_anim = function(entity)
    ClearPedTasks(entity)
    if not prop then return end

    kxm.delete_entity(prop)
    prop = nil
end

kxm.emote = function(name)
    ExecuteCommand('e ' .. name)
end
