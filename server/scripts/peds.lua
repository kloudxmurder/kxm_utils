kxm_peds = {}

kxm.create_ped = function(data)
    local ped_id = CreatePed(3, data.model, data.coords.x, data.coords.y, data.coords.z, data.coords.w, data.networked, true, true)
    while not DoesEntityExist(ped_id) do Wait(100) end

    kxm_peds[#kxm_peds+1] = {
        netId = NetworkGetNetworkIdFromEntity(ped_id),
        entity = ped_id,
        resource = GetInvokingResource()
    }

    return ped_id
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

kxm.ped_anim = function(data)
    GlobalState:set('kxm:ped_anim', data,true)
end

kxm.stop_ped_anim = function(id)
    GlobalState:set('kxm:stop_ped_anim', data,true)
end

AddEventHandler('onServerResourceStop', function(name)
    for k, v in pairs(kxm_peds) do
        if name == v.resource then
            if DoesEntityExist(NetworkGetEntityFromNetworkId(v.entity)) then
                DeleteEntity(NetworkGetEntityFromNetworkId(v.entity))
                print('Deleted ped from ' .. v.resource)
            end

            kxm_peds[k] = nil
        end
    end
end)
