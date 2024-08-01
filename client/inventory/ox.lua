if GetConvar('kxm:inventory', 'auto') ~= 'auto' and GetConvar('kxm:inventory', 'auto') ~= 'ox' then return end

if GetResourceState('ox_inventory') ~= 'started' then
    if GetConvar('kxm:inventory', 'auto') ~= 'auto' then
        Wait(6000)
        print('^1kxm:inventory is set to ox but ox_inventory is not started.^7')
    end

    return
end

kxm = kxm
kxm.inv = {}

local ox = exports.ox_inventory

local function openInventory(invType, data)
    ox:openInventory(invType, data)
end

kxm.inv.openInventory = openInventory

local function getItems(item)
    return ox:Items(item or nil)
end

kxm.inv.getItems = getItems

local function useItem(data, cb)
    ox:useItem(data, cb)
end

kxm.inv.useItem = useItem

local function getCurrentWeapon()
    return ox:getCurrentWeapon()
end

kxm.inv.getCurrentWeapon = getCurrentWeapon

local function displayMetadata(metadata, value)
    ox:displayMetadata(metadata, value)
end

kxm.inv.displayMetadata = displayMetadata

local function getItemCount(itemName, metadata, strict)
    return ox:GetItemCount(itemName, metadata, strict)
end

kxm.inv.getItemCount = getItemCount

local function getInventoryItems()
    return ox:GetPlayerItems()
end

kxm.inv.getInventoryItems = getInventoryItems

local function getPlayerWeight()
    return ox:GetPlayerWeight()
end

kxm.inv.getPlayerWeight = getPlayerWeight

local function getPlayerMaxWeight()
    return ox:GetPlayerMaxWeight()
end

kxm.inv.getPlayerMaxWeight = getPlayerMaxWeight

local function setInvBusy(state)
    LocalPlayer.state.invBusy = state
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
