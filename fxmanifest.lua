fx_version 'adamant'
game 'gta5'

author 'Gusti Agung'
description 'This gusti-simcards script adds a cellphone simcard, and allows players to change their cellphone numbers'
version '1.0.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/server.lua',
	'config.lua'
}

client_scripts {
	'client/client.lua',
	'config.lua'
}