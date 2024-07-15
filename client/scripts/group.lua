kxm.group = {}
GroupData = {}

local function getMeta(key)
    if not next(GroupData) then return end
    return GroupData.metadata[key]
end

kxm.group.getMeta = getMeta

local function setMeta(key, value)
    if not next(GroupData) then return end
    TriggerServerEvent('kxm_utils:group:server:setMeta', GroupData.name, key, value)
end

kxm.group.setMeta = setMeta

local function ongoing()
    if not next(GroupData) then return end
    return GroupData.ongoing
end

kxm.group.ongoing = ongoing

local function getGroup()
    if not next(GroupData) then return end
    return GroupData
end

kxm.group.getGroup = getGroup

local function getMembers()
    if not next(GroupData) then return end
    return GroupData.members
end

kxm.group.getMembers = getMembers

local function isLeader()
    return GroupData.leader == cache.serverId
end

kxm.group.isLeader = isLeader

local function hasGroup()
    return next(GroupData)
end

kxm.group.hasGroup = hasGroup

local function createGroup()
    if next(GroupData) then return end

    local input = kxm.input({
        heading = 'Create Group',
        rows = {
            { type = 'input', label = 'Group Name', icon = 'user-group', required = true, placeholder = 'Name' }
        }
    })

    if not input then return end
    local name = input[1]

    TriggerServerEvent('kxm_utils:group:server:createGroup', name)
end

kxm.group.createGroup = createGroup

local function addMember()
    local input = kxm.input({
        heading = 'Recruit Group Member',
        rows = {
            { type = 'number', label = 'Server ID', required = true, icon = 'hashtag', placeholder = 'Server ID'}
        }
    })

    if not input then return end
    local serverId = input[1]

    if serverId == cache.serverId then kxm.core.notify('You can\'t recruit yourself.', 'error') return end

    TriggerServerEvent('kxm_utils:group:server:addMember', GroupData.name, serverId)
end

local function removeMember(member)
    local alert = kxm.alert({
        header = 'Kick ' .. member.name .. '?',
        centered = true,
        cancel = true,
        size = 'xs',
        labels = {
            cancel = 'Cancel',
            confirm = 'Kick'
        }
    })

    if not alert or alert == 'cancel' then return end

    TriggerServerEvent('kxm_utils:group:server:removeMember', GroupData.name, member.source)
end

local function groupMembers()
    local options = {}
    for id, member in pairs(GroupData.members) do
        options[#options+1] = {
            title = member.name,
            icon = 'user',
            readOnly = not isLeader() or member.citizenid == kxm.core.getPlayerData('citizenid'),
            arrow = isLeader() and member.citizenid ~= kxm.core.getPlayerData('citizenid'),
            onSelect = function()
                removeMember(member)
            end
        }
    end

    if isLeader() and #GroupData.members < 5 then
        options[#options+1] = {
            title = 'Add Member',
            icon = 'plus',
            readOnly = not isLeader(),
            arrow = isLeader(),
            onSelect = addMember
        }
    end

    kxm.context({
        menu = 'group',
        title = 'Group Members ' .. #GroupData.members .. '/5' ,
        options = options
    })
end

local function groupMenu()
    if not next(GroupData) then
        createGroup()
        return
    end

    local options = {}

    options[#options+1] = {
        title = 'Group Information',
        icon = 'circle-info',
        description = 'Group Name: ' .. GroupData.name .. '\nMembers: ' .. #GroupData.members,
        readOnly = true
    }

    options[#options+1] = {
        title = 'Members',
        icon = 'users-line',
        arrow = true,
        onSelect = groupMembers
    }

    if isLeader() then
        options[#options+1] = {
            title = 'Disband Group',
            icon = 'user-slash',
            arrow = true,
            onSelect = function()
                TriggerServerEvent('kxm_utils:group:server:disbandGroup', GroupData.name)
            end
        }
    end

    kxm.context({
        id = 'group',
        title = 'Group',
        options = options
    })
end

kxm.group.groupMenu = groupMenu

RegisterCommand('group', groupMenu)
AddStateBagChangeHandler('GroupData', nil, function(_, _, value)
    local citizenid = kxm.core.getPlayerData('citizenid')
    local hasGroup = false
    for name, data in pairs(value) do
        for id, member in pairs(data.members) do
            if member.citizenid == citizenid then
                GroupData = value[name]
                hasGroup = true
            end
        end
    end

    if not hasGroup then GroupData = {} end
end)

lib.callback.register('kxm_utils:group:client:cb:joinGroup', function(data)
    local alert = kxm.alert({
        header = data.name .. ' has invited you to join ' .. data.group .. '.',
        centered = true,
        cancel = true,
        size = 'xs',
        labels = {
            cancel = 'Cancel',
            confirm = 'Accept'
        }
    })

    if not alert or alert == 'cancel' then return false end
    return true
end)
