fx_version 'cerulean'
game 'gta5'

description 'Toshi Dev Advanced Teleport System'
version '2.0.0'

shared_scripts {
    '@ox_lib/init.lua', -- ox_libがある場合は読み込む
    'config.lua'
}

client_script 'client.lua'
server_script 'server.lua'