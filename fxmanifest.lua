fx_version 'cerulean'

game 'gta5'
lua54 'yes'
author 'Samurai'




client_scripts {
    'client/targets.lua',
    'client/functions.lua',
	'client/client.lua',
}

server_scripts {
   '@oxmysql/lib/MySQL.lua',
	'server/server.lua',
	'server/opensource.lua',
}


shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

escrow_ignore {
    'config.lua',
    'server/opensource.lua',
    'client/opensource.lua'
}