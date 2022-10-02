fx_version 'adamant'
game 'gta5'

author 'Gusti Agung'
description 'This gusti-simcards script adds a cellphone simcard, and allows players to change their cellphone numbers'
version '1.0.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'server/server.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'client/client.lua'
}