kxm.group = {}
GroupCache = {}

local function getMeta(group, key)
    if not GroupCache[group] then return end
    return GroupCache[group].metadata[key]
end

kxm.group.getMeta = getMeta

local function setMeta(group, key, value)
    if not GroupCache[group] then return end
    GroupCache[group].metadata[key] = value

    GlobalState['GroupData'] = GroupCache
end

kxm.group.setMeta = setMeta

local function setOngoing(name, state)
    if not GroupCache[name] then return end
    GroupCache[name].ongoing = state

    GlobalState['GroupData'] = GroupCache
end

kxm.group.setOngoing = setOngoing

local function getGroup(name)
    if not GroupCache[name] then return end
    return GroupCache[name]
end

kxm.group.getGroup = getGroup

local function getMembers(name)
    if not GroupCache[name] then return end
    return GroupCache[name].members
end

kxm.group.getMembers = getMembers

local function hasGroup(citizenid)
    for name, data in pairs(GroupCache) do
        for id, member in pairs(data.members) do
            if member.citizenid == citzenid then return true end
        end
    end

    return false
end

local function updateGroupData(group)
    if not GroupCache[group] then return end

    for id, member in pairs(GroupCache[group].members) do
        local player = kxm.core.getPlayerById(member.citizenid)

        if not player.source then
            GroupCache[group].members[id] = nil
        end
    end

    GlobalState['GroupData'] = GroupCache
end

local function addMember(group, playerId)
    local src = source
    if not GroupCache[group] then return end
    if GetPlayerPed(playerId) == 0 then
        kxm.core.notify(src, 'Invalid ID.', 'error')
        return
    end

    local citizenid = kxm.core.getPlayerData(playerId, 'citizenid')
    local name = kxm.core.getPlayerData(playerId, 'name')

    if hasGroup(citizenid) then
        kxm.core.notify(src, name .. ' already has a group.', 'error')
        return
    end

    local accepted = lib.callback.await('kxm_utils:group:client:cb:joinGroup', playerId, {
        name = kxm.core.getPlayerData(src, 'name'),
        group = group
    })

    if not accepted then return end

    local members = GroupCache[group].members

    members[#members+1] = {
        name = name,
        citizenid = citizenid,
        source = playerId
    }

    GroupCache[group].members = members
    updateGroupData(group)
end

local function removeMember(group, playerId)
    local src = source
    if not GroupCache[group] then return end

    for id, member in pairs(GroupCache[group].members) do
        if member.source == playerId then
            kxm.core.notify(src, GroupCache[group].members[id].name .. ' has been removed from your group.', 'success')
            GroupCache[group].members[id] = nil
        end
    end

    updateGroupData(group)
end

local function getGroupMembers(source, group)
    local src = source
    if not GroupCache[group] then return end

    return GroupCache[group].members
end

local function disbandGroup(group)
    if not GroupCache[group] then return end
    GroupCache[group] = nil

    GlobalState['GroupData'] = GroupCache
end

local function createGroup(group)
    local src = source
    local citizenid = kxm.core.getPlayerData(src, 'citizenid')
    local name = kxm.core.getPlayerData(src, 'name')
    local members = {}

    if GroupCache[group] then
        kxm.core.notify(src, 'Group name already taken.', 'error')
        return
    end

    members[#members+1] = {
        name = name,
        citizenid = citizenid,
        source = src
    }

    GroupCache[group] = {
        name = group,
        leader = src,
        members = members,
        metadata = {},
        ongoing = false
    }

    kxm.core.notify(src, 'Group ' .. group .. ' created.', 'inform')

    updateGroupData(group)
end

RegisterServerEvent('kxm_utils:group:server:addMember', addMember)
RegisterServerEvent('kxm_utils:group:server:removeMember', removeMember)
RegisterServerEvent('kxm_utils:group:server:setMeta', setMeta)
RegisterServerEvent('kxm_utils:group:server:createGroup', createGroup)
RegisterServerEvent('kxm_utils:group:server:disbandGroup', disbandGroup)
lib.callback.register('kxm_utils:group:cb:getGroupMembers', getGroupMembers)

AddEventHandler('playerDropped', function()
    local src = source
    for name, data in pairs(GroupCache) do
        if data.leader == src then
            GroupCache[name] = nil
            GlobalState['GroupData'] = GroupCache
            return
        end

        for id, member in pairs(data.members) do
            if member.source == src then
                GroupCache[name].members[id] = nil
                GlobalState['GroupData'] = GroupCache
            end
        end
    end
end)
