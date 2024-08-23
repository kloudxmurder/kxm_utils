local ServerVehicle = CreateVehicleServerSetter

kxm.create_vehicle = function(source, data)
    local routing = GetPlayerRoutingBucket(source)
    local randomRoute = math.random(100, 999)

    SetPlayerRoutingBucket(source, randomRoute)

    local vehicle = ServerVehicle and ServerVehicle(data.model, data.type, data.coord, data.heading) or CreateVehicle(data.model, data.coord.x, data.coord.y, data.coord.z, data.heading, true, true)
    while not ServerVehicle and not DoesEntityExist(vehicle) do Wait(0) end

    Entity(vehicle).state.fuel = 100
    SetEntityRoutingBucket(vehicle, randomRoute)
    while NetworkGetEntityOwner(vehicle) == -1 do Wait(0) end

    if data.prop and data.prop.plate then
        SetVehicleNumberPlateText(vehicle, data.prop.plate)
    end

    SetPedIntoVehicle(GetPlayerPed(source), vehicle, -1)

    while NetworkGetEntityOwner(vehicle) ~= source do
        SetPedIntoVehicle(GetPlayerPed(source), vehicle, -1)
        Wait(10)
    end

    local netId = NetworkGetNetworkIdFromEntity(vehicle)

    if data.prop and data.prop.plate then
        Entity(vehicle).state.plate = data.prop.plate
        TriggerClientEvent('kxm_utils:client:setVehicleProperties', NetworkGetEntityOwner(vehicle), netId, data.prop, data.prop.plate)
    end

    SetTimeout(1000, function()
        SetPlayerRoutingBucket(source, routing)
        SetEntityRoutingBucket(vehicle, routing)
        SetPedIntoVehicle(GetPlayerPed(source), vehicle, -1)
    end)

    return netId
end

lib.callback.register('kxm_utils:callback:createVehicle', kxm.create_vehicle)
