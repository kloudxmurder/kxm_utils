kxm_peds = {}

---@class pedData
---@field model string: automatically joaat'd
---@field coords vector4: z is automatically subtracted by one
---@field networked boolean

---Model is automatically requested thru ox_lib
---
---Models: https://docs.fivem.net/docs/game-references/ped-models/
---
---Returns created ped's entity ID
---@param data pedData
---@return entityID
kxm.create_ped = function(data)
    local model = joaat(data.model)
    local resource = GetInvokingResource()

    if not HasModelLoaded(model) then
        lib.requestModel(model)
    end

    local ped = CreatePed(3, model, data.coords.x, data.coords.y, data.coords.z - 1, data.coords.w, data.networked or false, true)

    kxm_peds[#kxm_peds+1] = {
        entity = ped,
        resource = resource,
        id = data.id or nil
    }

    SetModelAsNoLongerNeeded(model)
    return ped
end

---@class animData
---@field dict string: animation dictionary
---@field name string: animation name
---@field duration number: duration in (ms) or -1
---@field upperbody boolean
---@field prop propData
---@field id number

---@class propData
---@field model string
---@field bone? number
---@field coords vector3
---@field rotation vector3

---@param data animData
kxm.ped_anim = function(data)
    local dict, name, duration, upperbody, prop, id in data
    local ped = nil
    for k, v in pairs(kxm_peds) do
        if v.id == data.id then
            ped = v.entity
        end
    end

    if not ped then return end

    kxm.play_anim({
        entity = ped,
        dict = dict,
        name = name,
        duration = duration,
        upperbody = upperbody,
        prop = prop
    })
end

kxm.ped_stop_anim = function(id)
    local ped = nil
    for k, v in pairs(kxm_peds) do
        if v.id == id then
            ped = v.entity
        end
    end

    kxm.stop_anim(ped)
end

RegisterNetEvent('kxm_utils:client:peds:pedAnim', kxm.ped_anim)
RegisterNetEvent('kxm_utils:client:peds:pedStopAnim', kxm.ped_stop_anim)

AddStateBagChangeHandler('kxm:create_ped', nil, function(_, _, data)
    kxm.create_ped(data)
end)

AddStateBagChangeHandler('kxm:ped_anim', nil, function(_, _, data)
    kxm.ped_anim(data)
end)

AddStateBagChangeHandler('kxm:stop_ped_anim', nil, function(_, _, id)
    kxm.stop_ped_anim(id)
end)

AddEventHandler('onResourceStop', function(name)
    for k, v in pairs(kxm_peds) do
        if name == v.resource then
            SetEntityAsMissionEntity(v.entity)
            kxm.delete_entity(v.entity)
            kxm_peds[k] = nil
        end
    end
end)
