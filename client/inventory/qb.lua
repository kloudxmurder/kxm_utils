local invStarted = false
local qbInv = nil
local invList = {
    'qb-inventory', 'lj-inventory', 'ps-inventory'
}

for _, inv in pairs(invList) do
    if GetResourceState(inv) == 'started' then invStarted = true qbInv = inv end
end

if not invStarted then return end

kxm = kxm
kxm.inv = {}

qbInv = exports[qbInv]
local weapons = exports['qb-weapons']
local QBCore = exports['qb-core']:GetCoreObject()

local function openInventory(invType, data)
    TriggerServerEvent('kxm_utils:server:openInventory', invType, data)
end

kxm.inv.openInventory = openInventory

local function closeInventory()
    TriggerServerEvent('qb-inventory:server:closeInventory')
end

kxm.inv.closeInventory = closeInventory

local function getItems(item)
    if item then
        return QBCore.Shared.Items[item]
    else
        return QBCore.Shared.Items
    end
end

kxm.inv.getItems = getItems

local function getCurrentWeapon()
    return weapons:getCurrentWeaponData()
end

kxm.inv.getCurrentWeapon = getCurrentWeapon

local function displayMetadata(metadata, value)
    -- does qb-inventory even have one!?
end

kxm.inv.displayMetadata = displayMetadata

local function getItemCount(itemName, metadata, strict)
    local plyInv = kxm.core.getPlayerData('inventory')
    local invItems = {}
    local itemCount = 0
    for k, v in pairs(plyInv) do
        if v.name == item then
            itemCount = itemCount + v.count
        end
    end

    return itemCount or 0
end

kxm.inv.getItemCount = getItemCount

local function getInventoryItems()
    return kxm.core.getPlayerData('inventory')
end

kxm.inv.getInventoryItems = getInventoryItems

local function getPlayerWeight()
    -- WIP
end

kxm.inv.getPlayerWeight = getPlayerWeight

local function getPlayerMaxWeight()
    -- WIP
end

kxm.inv.getPlayerMaxWeight = getPlayerMaxWeight

local function setInvBusy(state)
    LocalPlayer.state['inv_busy'] = state
end

kxm.inv.setInvBusy = setInvBusy

local function invOpen()
    return LocalPlayer.state.invOpen
end

kxm.inv.invOpen = invOpen

local function canUseWeapons(state)
    LocalPlayer.state.canUseWeapons = state
end

kxm.inv.canUseWeapons = canUseWeapons
