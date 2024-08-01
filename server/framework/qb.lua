if GetConvar('kxm:framework', 'auto') ~= 'auto' and GetConvar('kxm:framework', 'auto') ~= 'qb' then return end

if GetResourceState('qb-core') ~= 'started' then
    if GetConvar('kxm:framework', 'auto') ~= 'auto' then
        Wait(5000)
        print('^1kxm:framework is set to qb but qb-core is not started.^7')
    end

    return
end

CreateThread(function()
    while not kxm.inv do Wait(100) end
    kxm.inv = kxm.inv
end)

QB = exports['qb-core']:GetCoreObject()

local function getPlayer(source)
    local player = QB.Functions.GetPlayer(source)
    return player
end

kxm.core.getPlayer = getPlayer
exports('getPlayer', getPlayer)

local function getPlayerById(id)
    local player = QB.Functions.GetPlayerByCitizenId(id)
    if player then
        return player.PlayerData
    end

    return nil
end

kxm.core.getPlayerById = getPlayerById
exports('getPlayerById', getPlayerById)

local function getPlayers()
    return QB.Functions.GetQBPlayers()
end

kxm.core.getPlayers = getPlayers
exports('getPlayers', getPlayers)

---@param source number
---@param type? string: job, jobname, jobgrade, jobboss, duty, money, bank, name, firstname, lastname, identifier, citizenid, inventory. Default: returns PlayerData table
local function getPlayerData(source, type)
    local Player = QB.Functions.GetPlayer(source)
    if not Player then return end

    if type == 'job' then
        return Player.PlayerData.job
    elseif type == 'jobname' then
        return Player.PlayerData.job.name
    elseif type == 'jobgrade' then
        return Player.PlayerData.job.grade.level
    elseif type == 'jobboss' then
        return Player.PlayerData.job.isboss
    elseif type == 'duty' then
        return Player.PlayerData.job.onduty
    elseif type == 'gang' then
        return Player.PlayerData.gang
    elseif type == 'gangname' then
        return Player.PlayerData.gang.name
    elseif type == 'ganggrade' then
        return Player.PlayerData.gang.grade.level
    elseif type == 'gangrep' then
        return Player.PlayerData.gang.reputation
    elseif type == 'money'then
        return Player.PlayerData.money.cash
    elseif type == 'bank' then
        return Player.PlayerData.money.bank
    elseif type == 'name' then
        return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
    elseif type == 'firstname' then
        return Player.PlayerData.charinfo.firstname
    elseif type == 'lastname' then
        return Player.PlayerData.charinfo.lastname
    elseif type == 'identifier' then
        return Player.PlayerData.license
    elseif type == 'citizenid' then
        return Player.PlayerData.citizenid
    elseif type == 'source' then
        return Player.PlayerData.source
    elseif type == 'inventory' then
        return Player.PlayerData.items or kxm.inv.getInventoryItems(source)
    elseif type == nil then
        return Player.PlayerData
    else
        return Player.PlayerData[type]
    end
end

kxm.core.getPlayerData = getPlayerData
exports('getPlayerData', getPlayerData)

local function getCops()
    local cops = 0
    local players = QB.Functions.GetQBPlayers()

    for k, v in pairs(players) do
        local jobName = getPlayerData(tonumber(k), 'jobname')
        if jobName[kxmConfig.policeJobs] then
            cops += 1
        end
    end

    return cops
end

kxm.core.getCops = getCops
exports('getCops', getCops)

---@param source number
---@param type string: money, bank
local function getAccount(source, type)
    local Player = QB.Functions.GetPlayer(source)

    if type == 'money' then type = 'cash' end

    return Player.Functions.GetMoney(type)
end

kxm.core.getAccount = getAccount
exports('getAccount', getAccount)

---@param source number
---@param type string: money, bank
---@param amount integer
---@param reason? string
local function addMoney(source, type, amount, reason)
    local Player = QB.Functions.GetPlayer(source)
    local playerName = getPlayerData(source, 'name')
    local reason = reason or ''

    if type == 'money' then type = 'cash' end

    kxm.logs({
        message = playerName .. ' +' .. amount .. ' ' .. type .. ' ' .. reason,
        playerID = source,
        channel = 'addMoney'
    })

    return Player.Functions.AddMoney(type, amount, reason)
end

RegisterNetEvent('kxm_utils:server:addMoney', function(type, amount, reason)
    local src = source
    addMoney(src, type, amount, reason)
end)

kxm.core.addMoney = addMoney
exports('addMoney', addMoney)

---@param source number
---@param type string: money, bank
---@param amount integer
---@param reason? string
local function removeMoney(source, type, amount, reason)
    local Player = QB.Functions.GetPlayer(source)
    local playerName = getPlayerData(source, 'name')
    local reason = reason or ''

    if type == 'money' then type = 'cash' end

    kxm.logs({
        message = playerName .. ' +' .. amount .. ' ' .. type .. ' ' .. reason,
        playerID = source,
        channel = 'removeMoney'
    })

    return Player.Functions.RemoveMoney(type, amount, reason)
end

RegisterNetEvent('kxm_utils:server:removeMoney', function(type, amount, reason)
    local src = source
    removeMoney(src, type, amount, reason)
end)

kxm.core.removeMoney = removeMoney
exports('removeMoney', removeMoney)

---@param source number
---@param item string
---@param amount number
---@param meta? table
---@param reason? string
local function addItem(source, inv, item, amount, meta, slot, reason)
    local Player = QB.Functions.GetPlayer(source)
    local playerName = getPlayerData(source, 'name')
    reason = reason or ''

    kxm.logs({
        message = playerName .. ' ' .. inv .. ' +' .. amount .. ' ' .. item .. ' ' .. reason,
        playerID = source,
        channel = 'addItem'
    })

    return kxm.inv.addItem(source, inv, item, amount, meta, slot, reason)
end

RegisterNetEvent('kxm_utils:server:addItem', function(inv, item, amount, meta, slot, reason)
    local src = source
    addItem(src, inv, item, amount, meta, slot, reason)
end)

kxm.core.addItem = addItem
exports('addItem', addItem)

local function removeItem(source, inv, item, amount, meta, slot, reason)
    local Player = QB.Functions.GetPlayer(source)
    local playerName = getPlayerData(source, 'name')
    reason = reason or ''

    kxm.logs({
        message = playerName .. ' ' .. inv .. ' -' .. amount .. ' ' .. item .. ' ' .. reason,
        playerID = source,
        channel = 'removeItem'
    })

    return kxm.inv.removeItem(source, inv, item, amount, meta, slot, reason)
end

RegisterNetEvent('kxm_utils:server:removeItem', function(inv, item, amount, meta, slot, reason)
    local src = source
    removeItem(src, inv, item, amount, meta, slot, reason)
end)

kxm.core.removeItem = removeItem
exports('removeItem', removeItem)

---@param source number
---@param message string
---@param type string: info, success, error
local function notify(source, message, type, icon, iconColor)
    if type == 'info' then type = 'inform' end
    local notifData = {
        -- id = 'id',
        description = message,
        type = type or 'inform',
        duration = duration or 5000,
        position = 'top-right',
        icon = icon or nil,
        iconColor = iconColor or nil,
    }

    TriggerClientEvent('QBCore:Notify', source, notifData)
end

kxm.core.notify = notify
exports('notify', notify)

---@param player number|string: Inventory name / Player ID
---@param item string: Item Name
---@return number
local function getItemCount(player, item)
    local plyInv = kxm.inv.getInventoryItems(player)
    local invItems = {}
    local itemCount = 0
    for k, v in pairs(plyInv) do
        if v.name == item then
            itemCount = itemCount + v.count
        end
    end

    return itemCount or 0
end

kxm.core.getItemCount = getItemCount
exports('getItemCount', getItemCount)

--- You can still use getItemCount, this is just a shortcut
---@param item string
---@param amount integer
---@return boolean: returns true if player has greater than or equal to the amount of the item
local function hasItem(player, item, amount)
    return getItemCount(player, item) >= amount
end

kxm.core.hasItem = hasItem
exports('hasItem', hasItem)

local function registerUsableItem(name, func)
    QB.Functions.CreateUseableItem(name, func)
end

kxm.core.registerUsableItem = registerUsableItem
exports('registerUsableItem', registerUsableItem)

---@param source number
---@param key string
---@param value boolean
local function setPlayerMeta(source, key, value)
    local player = getPlayer(source)
    player.Functions.SetMetaData(key, value)
end

RegisterNetEvent('kxm_utils:server:setPlayerMeta', function(key, value)
    local src = source
    setPlayerMeta(tonumber(src), key, value)
end)

kxm.core.setPlayerMeta = setPlayerMeta
exports('setPlayerMeta', setPlayerMeta)

local function loadPlayerMeta(source)
    local playerMeta = getPlayerData(source, 'metadata')
    return playerMeta
end

kxm.core.loadPlayerMeta = loadPlayerMeta
exports('loadPlayerMeta', loadPlayerMeta)

local function getPlayerMeta(source)
    local playerMeta = getPlayerData(source, 'metadata')
    return playerMeta
end

lib.callback.register('kxm_utils:cb:getPlayerMeta', function(source)
    local src = source
    return getPlayerMeta(tonumber(src))
end)

kxm.core.getPlayerMeta = getPlayerMeta
exports('getPlayerMeta', getPlayerMeta)

local function getDutyCount(_, job)
    local dutyCount = 0
    local Players = getPlayers()

    for k, v in pairs(Players) do
        local jobName = getPlayerData(tonumber(k), 'jobname')
        local onDuty = getPlayerData(tonumber(k), 'duty')
        if jobName == job and onDuty then
            dutyCount += 1
        end
    end

    return dutyCount
end

lib.callback.register('kxm_utils:server:getDutyCount', getDutyCount)

local function getJobs()
    return QB.Shared.Jobs
end

kxm.core.getJobs = getJobs
exports('getJobs', getJobs)

local function toggleDuty(data)
    local src = source
    local Player = QB.Functions.GetPlayer(src)

    if Player.PlayerData.job.name ~= data.name then
        Player.Functions.SetJob(data.name, tonumber(data.grade))
        Player.Functions.SetJobDuty(true)
        kxm.core.notify(src, 'You went on duty as a ' .. Player.PlayerData.job.label, 'inform')
    else
        if Player.PlayerData.job.onduty then
            Player.Functions.SetJobDuty(false)
        else
            Player.Functions.SetJobDuty(true)
        end

        kxm.core.notify(src, not Player.PlayerData.job.onduty and 'You\'re now on duty' or 'You\'re now off duty', 'inform')
    end

    TriggerEvent('QBCore:Server:SetDuty', src, Player.PlayerData.job.onduty)
    TriggerClientEvent('QBCore:Client:SetDuty', src, Player.PlayerData.job.onduty)
    TriggerClientEvent("dutycount:toggleduty", src, Player.PlayerData.job.onduty)
end

kxm.core.toggleDuty = toggleDuty
exports('toggleDuty', toggleDuty)

RegisterServerEvent('kxm_utils:server:toggleDuty', toggleDuty)
