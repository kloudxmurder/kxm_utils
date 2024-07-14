local peds_data = {}

kxm.create_ped = function(data)
    local ped_id = CreatePed(3, data.model, data.coords.x, data.coords.y, data.coords.z, data.coords.w, data.networked, true, true)
    while not DoesEntityExist(ped_id) do Wait(100) end

    peds_data[#peds_data+1] = {
        netId = NetworkGetNetworkIdFromEntity(ped_id),
        ped = ped_id,
        resource = GetInvokingResource()
    }

    return ped_id
end

AddEventHandler('onServerResourceStop', function(name)
    for k, v in pairs(peds_data) do
        if name == v.resource then
            if DoesEntityExist(NetworkGetEntityFromNetworkId(v.ped_id)) then
                DeleteEntity(NetworkGetEntityFromNetworkId(v.ped_id))
                print('Deleted ped from ' .. v.resource)
            end

            peds_data[k] = nil
        end
    end
end)
