fx_version "cerulean"
game "gta5"
lua54 'yes'

name "ns_lib"
version "1.0"
description "Ns Script Library"


shared_scripts { 'config.lua'}

server_scripts {'server/*.lua', 'server/**/*.lua' }

client_scripts {
    'client/*.lua', 'client/**/*.lua',
    '@PolyZone/client.lua', '@PolyZone/BoxZone.lua', '@PolyZone/EntityZone.lua', '@PolyZone/CircleZone.lua', '@PolyZone/ComboZone.lua'
}