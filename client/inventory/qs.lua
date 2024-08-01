if GetConvar('kxm:inventory', 'auto') ~= 'auto' and GetConvar('kxm:inventory', 'auto') ~= 'qs' then return end

if GetResourceState('qs-inventory') ~= 'started' then
    if GetConvar('kxm:inventory', 'auto') ~= 'auto' then
        Wait(6000)
        print('^1kxm:inventory is set to qs but qs-inventory is not started.^7')
    end

    return
end

kxm = kxm
kxm.inv = {}

local qs = exports['qs-inventory']

local function openInventory(invType, data)
    -- i don't have a copy of qs-inventory and i can't find this sht on the docs so WIP
end

kxm.inv.openInventory = openInventory

local function closeInventory()
    -- i don't have a copy of qs-inventory and i can't find this sht on the docs so WIP
end

kxm.inv.closeInventory = closeInventory

local function getItems(item)
    local itemList = qs:GetItemList()

    if item then
        return itemList[item]
    else
        return itemList
    end
end

kxm.inv.getItems = getItems

local function getCurrentWeapon()
    return qs:GetCurrentWeapon()
end

kxm.inv.getCurrentWeapon = getCurrentWeapon

local function displayMetadata(metadata, value)
    -- does qs-inventory even have one!?
end

kxm.inv.displayMetadata = displayMetadata

local function getItemCount(itemName, metadata, strict)
    return qs:Search(itemName)
end

kxm.inv.getItemCount = getItemCount

local function getInventoryItems()
    return qs:getUserInventory()
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
    qs:setInventoryDisabled(state)
end

kxm.inv.setInvBusy = setInvBusy

local function invOpen()
    return qs:inInventory()
end

kxm.inv.invOpen = invOpen

local function canUseWeapons(state)
    -- not sure if qs has one
end

kxm.inv.canUseWeapons = canUseWeapons
