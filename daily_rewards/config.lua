Config = {}

-- Daily Rewards Configuration
Config.Rewards = {
    [1] = {
        type = 'money',
        amount = 5000,
        label = 'Dinheiro',
        description = '$5,000'
    },
    [2] = {
        type = 'weapon',
        item = 'weapon_pistol50',
        amount = 1,
        label = 'Pistol .50',
        description = '1x Pistol .50'
    },
    [3] = {
        type = 'money',
        amount = 10000,
        label = 'Dinheiro',
        description = '$10,000'
    },
    [4] = {
        type = 'item',
        item = 'armor',
        amount = 10,
        label = 'Colete',
        description = '10x Colete'
    },
    [5] = {
        type = 'weapon',
        item = 'weapon_pistol50',
        amount = 2,
        label = 'Pistol .50',
        description = '2x Pistol .50'
    },
    [6] = {
        type = 'money',
        amount = 5000,
        label = 'Dinheiro',
        description = '$5,000'
    },
    [7] = {
        type = 'weapon',
        item = 'weapon_combatpdw',
        amount = 1,
        label = 'Combat PDW',
        description = '1x Combat PDW'
    }
}

-- UI Configuration
Config.UI = {
    title = 'Daily Rewards',
    subtitle = 'Claim your daily rewards',
    buttonText = 'CLAIM',
    claimedText = 'CLAIMED',
    resetTime = 24 -- hours until reset
}

-- Database Configuration
Config.Database = {
    table = 'daily_rewards'
}