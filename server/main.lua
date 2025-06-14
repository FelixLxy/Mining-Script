ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('stone:canPickUp', function(source, cb, itemName)
    local canCarry = exports.ox_inventory:CanCarryItem(source, itemName, 1)
    cb(canCarry)
end)

RegisterServerEvent('stone:pickedUpItem')
AddEventHandler('stone:pickedUpItem', function()
    local itemName = Config.Item or 'stone'
    local amount = math.random(1, 3)

    if Config.UseOxInventory then
        local canCarry = exports.ox_inventory:CanCarryItem(source, itemName, amount)
        if canCarry then
            exports.ox_inventory:AddItem(source, itemName, amount)
        end
    else
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            xPlayer.addInventoryItem(itemName, amount)
        end
    end
end)
