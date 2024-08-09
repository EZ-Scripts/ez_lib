fx_version "cerulean"
game "gta5"
lua54 'yes'

name "ez_lib"
version "1.0"
description "Ns Script Library"


shared_scripts {'@ox_lib/init.lua', 'config.lua'} -- Remove ox_lib if you are not using it

server_scripts {'server/*.lua', 'server/**/*.lua' }

client_scripts {
    'client/*.lua', 'client/**/*.lua',
    '@PolyZone/client.lua', '@PolyZone/BoxZone.lua', '@PolyZone/EntityZone.lua', '@PolyZone/CircleZone.lua', '@PolyZone/ComboZone.lua'
}