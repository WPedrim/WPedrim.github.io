ESX = exports["kissmyass"]:getSharedObject()

local playerData = {}
local isUIOpen = false

-- Initialize player data when they spawn
RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    ESX.TriggerServerCallback('daily_rewards:getPlayerData', function(data)
        playerData = data or {}
    end)
end)

-- Update UI when data changes
RegisterNetEvent('daily_rewards:updateUI', function()
    ESX.TriggerServerCallback('daily_rewards:getPlayerData', function(data)
        playerData = data or {}
        if isUIOpen then
            showDailyRewards()
        end
    end)
end)

-- Show daily rewards UI
function showDailyRewards()
    if isUIOpen then return end
    isUIOpen = true
    
    ESX.TriggerServerCallback('daily_rewards:getPlayerData', function(data)
        playerData = data or {}
        
        local elements = {}
        
        for day = 1, 7 do
            local reward = Config.Rewards[day]
            local status = 'locked'
            local buttonText = 'LOCKED'
            local iconColor = '#6b7280'
            
            if day <= playerData.currentDay then
                status = 'claimed'
                buttonText = 'CLAIMED'
                iconColor = '#22c55e'
            elseif day == playerData.currentDay + 1 and playerData.canClaim then
                status = 'claimable'
                buttonText = 'CLAIM'
                iconColor = '#f59e0b'
            end
            
            table.insert(elements, {
                title = 'Day ' .. day,
                description = reward.label .. '\n' .. reward.description,
                icon = getRewardIcon(reward.type),
                iconColor = iconColor,
                disabled = status ~= 'claimable',
                metadata = {
                    {label = 'Status', value = buttonText},
                    {label = 'Reward', value = reward.description}
                },
                onSelect = function()
                    if status == 'claimable' then
                        claimReward(day)
                    elseif status == 'claimed' then
                        lib.notify({
                            title = 'Daily Rewards',
                            description = 'You already claimed this reward!',
                            type = 'inform'
                        })
                    else
                        lib.notify({
                            title = 'Daily Rewards',
                            description = 'This reward is still locked!',
                            type = 'error'
                        })
                    end
                end
            })
        end
        
        -- Add header element
        local headerElement = {
            title = Config.UI.title,
            description = Config.UI.subtitle .. '\nCurrent day: ' .. (playerData.currentDay + 1) .. '/7',
            icon = 'fa-solid fa-calendar-days',
            iconColor = '#3b82f6',
            disabled = true
        }
        
        table.insert(elements, 1, headerElement)
        
        lib.registerContext({
            id = 'daily_rewards_menu',
            title = 'Daily Rewards System',
            options = elements
        })
        
        lib.showContext('daily_rewards_menu')
    end)
end

-- Get reward icon based on type
function getRewardIcon(rewardType)
    if rewardType == 'money' then
        return 'fa-solid fa-dollar-sign'
    elseif rewardType == 'weapon' then
        return 'fa-solid fa-gun'
    elseif rewardType == 'item' then
        return 'fa-solid fa-box'
    else
        return 'fa-solid fa-gift'
    end
end

-- Get status color
function getStatusColor(status)
    if status == 'claimed' then
        return '#22c55e' -- green
    elseif status == 'claimable' then
        return '#f59e0b' -- yellow
    elseif status == 'locked' then
        return '#6b7280' -- gray
    else
        return '#3b82f6' -- blue
    end
end

-- Claim reward
function claimReward(day)
    if not playerData.canClaim then
        lib.notify({
            title = 'Daily Rewards',
            description = 'You need to wait 24 hours between claims!',
            type = 'error'
        })
        return
    end
    
    if day ~= playerData.currentDay + 1 then
        lib.notify({
            title = 'Daily Rewards',
            description = 'You can only claim the next day in sequence!',
            type = 'error'
        })
        return
    end
    
    local reward = Config.Rewards[day]
    if not reward then
        lib.notify({
            title = 'Daily Rewards',
            description = 'Invalid reward configuration!',
            type = 'error'
        })
        return
    end
    
    -- Show confirmation dialog
    local input = lib.alertDialog({
        header = 'Claim Day ' .. day .. ' Reward',
        content = 'Do you want to claim: ' .. reward.description .. '?',
        centered = true,
        cancel = true,
        labels = {
            confirm = 'Claim Reward',
            cancel = 'Cancel'
        }
    })
    
    if input == 'confirm' then
        TriggerServerEvent('daily_rewards:claimReward')
        isUIOpen = false
    end
end

-- Command to open daily rewards
RegisterCommand('dailyrewards', function()
    showDailyRewards()
end, false)

-- Key mapping
RegisterKeyMapping('dailyrewards', 'Open Daily Rewards', 'keyboard', 'F7')

-- Close UI event
RegisterNetEvent('daily_rewards:closeUI', function()
    isUIOpen = false
end)

-- Chat suggestion
TriggerEvent('chat:addSuggestion', '/dailyrewards', 'Open daily rewards menu')

-- Handle UI closing
CreateThread(function()
    while true do
        Wait(100)
        if isUIOpen then
            if not lib.getOpenContextMenu() then
                isUIOpen = false
            end
        end
    end
end)