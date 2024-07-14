kxm.execute_from_owner = function(func, entity, ...)
    if DoesEntityExist(entity) then
        local owner = GetPlayerServerId(NetworkGetEntityOwner(entity))
        local netId = NetworkGetNetworkIdFromEntity(entity)
        TriggerServerEvent("kxm_utils:server:requestNativeSync", func, owner, netId, ...)
    end
end

kxm.sync_native_func = function(func, entity, ...)
    if NetworkHasControlOfEntity(entity) then
        if kxm[func] then
            kxm[func](entity, ...)
        end
    else
        kxm.execute_from_owner(func, entity, ...)
    end
end


RegisterNetEvent('kxm_utils:client:syncRequestedNative', function(func, netId, ...)
	if kxm[func] then
		local entity = NetworkGetEntityFromNetworkId(netId)
		kxm[func](entity, ...)
	end
end)
