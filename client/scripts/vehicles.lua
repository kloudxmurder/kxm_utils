local vehicles_data = {}

---@class vehData
---@field model string: auto joaat'd and requested
---@field coords vector4
---@field networked boolean

---@class engineData
---@field entity number
---@field state boolean
---@field instantly boolean
---@field noAutoTurnOn boolean

kxm.get_vehicle_type = function(vehicle)
    if model == `submersible` or model == `submersible2` then
        return 'submarine'
    end

    local class = GetVehicleClassFromName(model)
    local types = {
        [8] = "bike",
        [11] = "automobile",
        [13] = "bike",
        [14] = "boat",
        [15] = "heli",
        [16] = "plane",
        [21] = "train",
    }

    return types[class] or "automobile"
end

---@param data vehData
---@return integer entityID
kxm.create_vehicle = function(data)
    local model = joaat(data.model)

    if not HasModelLoaded(model) then
        lib.requestModel(model)
    end

    local netId = lib.callback.await('kxm_utils:callback:createVehicle', false, {
        model = model,
        coord = data.coords,
        heading = data.coords.w,
        type = kxm.get_vehicle_type(model),
        prop = data.props or nil,
    })

    vehicles_data[#vehicles_data+1] = {
        entity = netId,
        resource = GetInvokingResource()
    }

    SetModelAsNoLongerNeeded(model)
    return netId
end

kxm.get_vehicle_properties = function(netId)
    return lib.getVehicleProperties(netId)
end

kxm.set_vehicle_properties = function(netId, data, plate)
    local veh = NetworkGetEntityFromNetworkId(netId)
    SetEntityAsMissionEntity(veh, true)

    while not IsPedInAnyVehicle(cache.ped) do Wait(0) end

    lib.setVehicleProperties(GetVehiclePedIsIn(cache.ped), data)
    SetVehicleNumberPlateText(veh, plate)
end

RegisterNetEvent('kxm_utils:client:setVehicleProperties', kxm.set_vehicle_properties)

---@param data engineData
kxm.set_vehicle_engine_on = function(data)
    if NetworkHasControlOfEntity(data.entity) then
        SetVehicleEngineOn(data.entity, data.state, data.instantly, data.noAutoTurnOn)
    else
        kxm.execute_from_owner("SetVehicleEngineOn", data.entity, data.state, data.instantly, data.noAutoTurnOn)
    end
end

kxm.set_boat_anchor = function(vehicle, state)
    if GetVehicleClass(vehicle) ~= 14 then
        print('[KXM] Tried to anchor a non boat vehicle')
        return
    end
    if NetworkHasControlOfEntity(vehicle) then
        SetBoatAnchor(vehicle, state)
        SetBoatFrozenWhenAnchored(vehicle, state)
    else
        kxm.execute_from_owner("SetBoatAnchor", vehicle, state)
        kxm.execute_from_owner("SetBoatFrozenWhenAnchored", vehicle, state)
    end
end

kxm.get_plate = function(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    plate = kxm.trim(plate)

    return plate
end


AddEventHandler('onResourceStop', function(name)
    for k, v in pairs(vehicles_data) do
        if name == v.resource then
            kxm.delete_entity(v.entity)
            vehicles_data[k] = nil
        end
    end
end)
