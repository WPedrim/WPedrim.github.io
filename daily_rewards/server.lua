ESX = exports["kissmyass"]:getSharedObject()

-- Initialize database table on resource start
CreateThread(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `daily_rewards` (
            `identifier` varchar(60) NOT NULL,
            `current_day` int(11) NOT NULL DEFAULT 0,
            `last_claim` timestamp NULL DEFAULT NULL,
            `total_claims` int(11) NOT NULL DEFAULT 0,
            PRIMARY KEY (`identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]], {})
end)

-- Get player reward data
ESX.RegisterServerCallback('daily_rewards:getPlayerData', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(nil) end
    
    local identifier = xPlayer.identifier
    
    MySQL.Async.fetchAll('SELECT * FROM daily_rewards WHERE identifier = ?', {identifier}, function(result)
        if result[1] then
            local data = result[1]
            local lastClaim = data.last_claim and os.time{
                year = string.sub(data.last_claim, 1, 4),
                month = string.sub(data.last_claim, 6, 7),
                day = string.sub(data.last_claim, 9, 10),
                hour = string.sub(data.last_claim, 12, 13),
                min = string.sub(data.last_claim, 15, 16),
                sec = string.sub(data.last_claim, 18, 19)
            } or 0
            
            local now = os.time()
            local timeDiff = now - lastClaim
            local hoursDiff = timeDiff / 3600
            
            -- Reset if more than 48 hours passed (skip a day)
            if hoursDiff > 48 then
                data.current_day = 0
            end
            
            -- Check if can claim (24 hours passed)
            local canClaim = hoursDiff >= 24 or data.last_claim == nil
            
            cb({
                currentDay = data.current_day,
                lastClaim = lastClaim,
                canClaim = canClaim,
                totalClaims = data.total_claims
            })
        else
            -- First time player
            cb({
                currentDay = 0,
                lastClaim = 0,
                canClaim = true,
                totalClaims = 0
            })
        end
    end)
end)

-- Claim reward
RegisterServerEvent('daily_rewards:claimReward')
AddEventHandler('daily_rewards:claimReward', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        print('[daily_rewards] Error: Player not found')
        return 
    end
    
    local identifier = xPlayer.identifier
    
    ESX.TriggerServerCallback('daily_rewards:getPlayerData', source, function(data)
        if not data then
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Daily Rewards',
                description = 'Error loading player data!',
                type = 'error'
            })
            return
        end
        
        if not data.canClaim then
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Daily Rewards',
                description = 'You cannot claim rewards yet! Wait 24 hours.',
                type = 'error'
            })
            return
        end
        
        local nextDay = data.currentDay + 1
        if nextDay > 7 then
            nextDay = 1 -- Reset to day 1 after completing all 7 days
        end
        
        local reward = Config.Rewards[nextDay]
        if not reward then 
            print('[daily_rewards] Error: Invalid reward configuration for day ' .. nextDay)
            return 
        end
        
        -- Give reward based on type
        local success = false
        local rewardGiven = ''
        
        if reward.type == 'money' then
            xPlayer.addMoney(reward.amount)
            rewardGiven = '$' .. reward.amount
            success = true
        elseif reward.type == 'item' then
            if xPlayer.canCarryItem(reward.item, reward.amount) then
                xPlayer.addInventoryItem(reward.item, reward.amount)
                rewardGiven = reward.amount .. 'x ' .. reward.item
                success = true
            else
                TriggerClientEvent('ox_lib:notify', source, {
                    title = 'Daily Rewards',
                    description = 'Not enough inventory space for ' .. reward.item .. '!',
                    type = 'error'
                })
                return
            end
        elseif reward.type == 'weapon' then
            for i = 1, reward.amount do
                xPlayer.addWeapon(reward.item, 250) -- 250 ammo
            end
            rewardGiven = reward.amount .. 'x ' .. reward.item
            success = true
        end
        
        if success then
            -- Update database
            MySQL.Async.execute('INSERT INTO daily_rewards (identifier, current_day, last_claim, total_claims) VALUES (?, ?, NOW(), ?) ON DUPLICATE KEY UPDATE current_day = ?, last_claim = NOW(), total_claims = total_claims + 1', {
                identifier,
                nextDay,
                data.totalClaims + 1,
                nextDay
            }, function(affectedRows)
                if affectedRows > 0 then
                    TriggerClientEvent('ox_lib:notify', source, {
                        title = 'Daily Rewards',
                        description = 'Day ' .. nextDay .. ' claimed! Received: ' .. rewardGiven,
                        type = 'success',
                        duration = 5000
                    })
                    
                    -- Log the claim
                    print('[daily_rewards] Player ' .. xPlayer.getName() .. ' (' .. identifier .. ') claimed day ' .. nextDay .. ' reward: ' .. rewardGiven)
                    
                    TriggerClientEvent('daily_rewards:updateUI', source)
                else
                    TriggerClientEvent('ox_lib:notify', source, {
                        title = 'Daily Rewards',
                        description = 'Database error occurred!',
                        type = 'error'
                    })
                end
            end)
        end
    end)
end)