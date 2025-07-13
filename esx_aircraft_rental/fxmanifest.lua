fx_version 'adamant'

game 'gta5'

author 'WPedrim'
description 'ESX Aircraft Rental System'
version '1.0.0'

shared_script '@es_extended/imports.lua'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'es_extended',
    'esx_menu_default'
}