ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local isNearMarker = false
local currentLocation = nil
local cooldownRemaining = 0

-- Create blips for aircraft rental locations
Citizen.CreateThread(function()
    for k, v in pairs(Config.Locations) do
        if v.blip then
            local blip = AddBlipForCoord(v.pos.x, v.pos.y, v.pos.z)
            SetBlipSprite(blip, v.blipSprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, v.blipScale)
            SetBlipColour(blip, v.blipColor)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.blipName)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

-- Main thread for marker detection and drawing
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        isNearMarker = false
        
        for k, v in pairs(Config.Locations) do
            local distance = GetDistanceBetweenCoords(playerCoords, v.pos.x, v.pos.y, v.pos.z, true)
            
            if distance < Config.InteractionDistance then
                isNearMarker = true
                currentLocation = v
                
                -- Draw the marker as specified in the problem statement
                if v.blip then
                    DrawMarker(22, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 255, 180, false, true, 2, false)
                end
                
                -- Show help text
                ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to access Aircraft Rental')
                
                if IsControlJustReleased(0, 38) then -- E key
                    OpenAircraftRentalMenu()
                end
                break
            end
        end
        
        if not isNearMarker then
            Citizen.Wait(500)
        end
    end
end)

-- Function to open the aircraft rental menu
function OpenAircraftRentalMenu()
    -- Check cooldown before opening menu
    TriggerServerEvent('esx_aircraft_rental:checkCooldown')
end

-- Handle cooldown response
RegisterNetEvent('esx_aircraft_rental:cooldownResponse')
AddEventHandler('esx_aircraft_rental:cooldownResponse', function(remainingTime)
    cooldownRemaining = remainingTime
    
    if cooldownRemaining > 0 then
        ESX.ShowNotification('You must wait ' .. cooldownRemaining .. ' seconds before renting another aircraft.')
        return
    end
    
    -- Create menu elements
    local elements = {}
    
    for k, v in pairs(Config.Aircraft) do
        table.insert(elements, {
            label = v.label,
            value = v
        })
    end
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'aircraft_rental', {
        title = 'Aircraft Rental',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        local selectedAircraft = data.current.value
        menu.close()
        
        -- Confirm rental
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'confirm_rental', {
            title = 'Confirm Rental',
            align = 'top-left',
            elements = {
                {label = 'Yes, rent ' .. selectedAircraft.name .. ' for $' .. selectedAircraft.price, value = 'yes'},
                {label = 'No, cancel', value = 'no'}
            }
        }, function(data2, menu2)
            menu2.close()
            if data2.current.value == 'yes' then
                TriggerServerEvent('esx_aircraft_rental:rentAircraft', selectedAircraft)
            end
        end, function(data2, menu2)
            menu2.close()
        end)
        
    end, function(data, menu)
        menu.close()
    end)
end)

-- Handle aircraft spawning
RegisterNetEvent('esx_aircraft_rental:spawnAircraft')
AddEventHandler('esx_aircraft_rental:spawnAircraft', function(aircraftData)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    -- Find a suitable spawn location near the rental location
    local spawnCoords = vector3(currentLocation.pos.x + 10.0, currentLocation.pos.y + 10.0, currentLocation.pos.z + 2.0)
    
    -- Load the aircraft model
    RequestModel(aircraftData.model)
    while not HasModelLoaded(aircraftData.model) do
        Citizen.Wait(100)
    end
    
    -- Create the aircraft
    local aircraft = CreateVehicle(aircraftData.model, spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0, true, false)
    
    -- Set vehicle properties
    SetEntityAsNoLongerNeeded(aircraft)
    SetVehicleOnGroundProperly(aircraft)
    SetVehicleNumberPlateText(aircraft, "RENTAL")
    
    -- Put player in the aircraft
    TaskWarpPedIntoVehicle(playerPed, aircraft, -1)
    
    ESX.ShowNotification('Your ' .. aircraftData.name .. ' has been spawned nearby!')
end)