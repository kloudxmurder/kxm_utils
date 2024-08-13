
---@class propData
---@field model string
---@field bone? number
---@field coords vector3
---@field rotation vector3

---@class animData
---@field entity any: entity ID
---@field dict string: animation dictionary
---@field name string: animation name
---@field scenario? string: scenario name
---@field scenarioIntro? boolean: play scenario intro?
---@field duration? number: duration in (ms) or -1
---@field upperbody? boolean
---@field prop? propData

local prop

---@param data animData
kxm.play_anim = function(data)
    local entity, dict, name, scenario, scenarioIntro, duration, upperbody, prop in data
    if not entity then
        entity = cache.ped
    end

    if scenario then
        TaskStartScenarioInPlace(entity, scenario, -1, scenarioIntro)
        return
    end

    local flag = upperbody and 49 or 1
    local duration = duration or -1

    if data.flag then
        flag = data.flag
    end

    if not HasAnimDictLoaded(dict) then
        lib.requestAnimDict(dict)
    end

    if NetworkHasControlOfEntity(entity) then
        TaskPlayAnim(entity, dict, name, 8.0, 8.0, duration, flag, 0.0, false, false, false)
    else
        kxm.execute_from_owner("TaskPlayAnim", entity, dict, name, 8.0, 8.0, duration, flag, 0.0, false, false, false)
    end

    if prop then
        if IsModelInCdimage(prop.model) then
            lib.requestModel(prop.model)
            prop = CreateObject(prop.model, GetEntityCoords(entity), true, true, true)
            repeat Wait(100) until DoesEntityExist(prop)
            AttachEntityToEntity(prop, entity, GetPedBoneIndex(entity, prop.bone or 60309), prop.coords.x or 0.0, prop.coords.y or 0.0, prop.coords.z or 0.0, prop.rotation.x or 0.0, prop.rotation.y or 0.0, prop.rotation.z or 0.0, 1, 1, 0, 1, 0, 1)
            SetModelAsNoLongerNeeded(prop.model)
        end
    end

    RemoveAnimDict(dict)
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
