fx_version 'cerulean'
game 'gta5'

author 'WPedrim'
description 'Daily Rewards System for ESX Legacy'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

dependencies {
    'es_extended',
    'ox_lib',
    'oxmysql'
}

lua54 'yes'