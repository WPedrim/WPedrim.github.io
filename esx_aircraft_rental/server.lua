local playerCooldowns = {}

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Register server event for aircraft rental
RegisterServerEvent('esx_aircraft_rental:rentAircraft')
AddEventHandler('esx_aircraft_rental:rentAircraft', function(aircraftData)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local playerIdentifier = xPlayer.identifier
    
    -- Check if player is on cooldown
    if playerCooldowns[playerIdentifier] and playerCooldowns[playerIdentifier] > GetGameTimer() then
        local remainingTime = math.ceil((playerCooldowns[playerIdentifier] - GetGameTimer()) / 1000)
        TriggerClientEvent('esx:showNotification', _source, 'You must wait ' .. remainingTime .. ' seconds before renting another aircraft.')
        return
    end
    
    -- Check if player has enough money
    if xPlayer.getMoney() >= aircraftData.price then
        -- Remove money from player
        xPlayer.removeMoney(aircraftData.price)
        
        -- Set cooldown for player (5 minutes)
        playerCooldowns[playerIdentifier] = GetGameTimer() + (Config.CooldownTime * 1000)
        
        -- Notify player and spawn aircraft
        TriggerClientEvent('esx:showNotification', _source, 'You rented a ' .. aircraftData.name .. ' for $' .. aircraftData.price)
        TriggerClientEvent('esx_aircraft_rental:spawnAircraft', _source, aircraftData)
    else
        TriggerClientEvent('esx:showNotification', _source, 'You don\'t have enough money to rent this aircraft.')
    end
end)

-- Register server event to check cooldown
RegisterServerEvent('esx_aircraft_rental:checkCooldown')
AddEventHandler('esx_aircraft_rental:checkCooldown', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local playerIdentifier = xPlayer.identifier
    
    local remainingTime = 0
    if playerCooldowns[playerIdentifier] and playerCooldowns[playerIdentifier] > GetGameTimer() then
        remainingTime = math.ceil((playerCooldowns[playerIdentifier] - GetGameTimer()) / 1000)
    end
    
    TriggerClientEvent('esx_aircraft_rental:cooldownResponse', _source, remainingTime)
end)