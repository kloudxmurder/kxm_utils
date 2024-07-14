---@class ptfxData
---@field asset string: ptfx asset
---@field name string: ptfx name
---@field coords? vector3
---@field entity? number: entity ID
---@field looped boolean
---@field duration? number: in (ms)

kxm.load_particle = function (dict)
    if not HasNamedPtfxAssetLoaded(dict) then
        RequestNamedPtfxAsset(dict)
    end

    repeat Wait(0) until HasNamedPtfxAssetLoaded(dict)

    SetPtfxAssetNextCall(dict)
end

---@param data ptfxData
kxm.ptfx = function(data)
    kxm.load_particle(data.asset)
    if data.coords then
        if data.looped then
            ptfx = StartParticleFxLoopedAtCoord(data.name, data.coords, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
        else
            ptfx = StartParticleFxNonLoopedAtCoord(data.name, data.coords, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
        end
    elseif data.entity then
        if data.looped then
            ptfx = StartParticleFxLoopedOnEntity(data.name, data.entity, 0.0, 2.0, 0.0, 0.0, 0.0, 0.0, 2.0, 0, 0, 0, 0)
        else
            ptfx = StartParticleFxNonLoopedOnEntity(data.name, data.entity, 0, 0, 0, 0, 0, 0, 1.6, false, false, false)
        end
    end

    if data.duration then
        Wait(data.duration)
    end

    if data.looped then
        StopParticleFxLooped(ptfx, false)
    end

    return ptfx
end

kxm.stop_ptfx = function(id)
    StopParticleFxLooped(id, 0)
end

RegisterNetEvent('kxm_utils:client:ptfx', kxm.ptfx)

---@param data ptfxData
kxm.start_ptfx = function(data)
    TriggerServerEvent('kxm_utils:server:ptfx', data)
end
