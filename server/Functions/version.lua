---@module version
---@description Check the version of a script against the latest version on GitHub

--- Branding for the version checker
local label =
[[ 
  
███████╗███████╗  ░██████╗░█████╗░██████╗░██╗██████╗░████████╗░██████╗
██╔════╝╚════██║  ██╔════╝██╔══██╗██╔══██╗██║██╔══██╗╚══██╔══╝██╔════╝
█████╗░░░░███╔═╝  ╚█████╗░██║░░╚═╝██████╔╝██║██████╔╝░░░██║░░░╚█████╗░
██╔══╝░░██╔══╝░░  ░╚═══██╗██║░░██╗██╔══██╗██║██╔═══╝░░░░██║░░░░╚═══██╗
███████╗███████╗  ██████╔╝╚█████╔╝██║░░██║██║██║░░░░░░░░██║░░░██████╔╝
╚══════╝╚══════╝  ╚═════╝░░╚════╝░╚═╝░░╚═╝╚═╝╚═╝░░░░░░░░╚═╝░░░╚═════╝░

]]

--- Function which outputs version to console and checks for updates
--- @param resourceName string The name of the resource to check the version of
--- @usage CheckVersion("resourceName")
local function CheckVersion(resourceName)
    -- Grabs the latest version number from the web GitHub
    PerformHttpRequest( "https://raw.githubusercontent.com/EZ-Scripts/versions/main/"..resourceName, function( err, text, headers )
        -- Wait to reduce spam
        Citizen.Wait( 2000 )

        -- Print the branding!
        print( label )

        -- Get the resource version
        local curVer = GetResourceMetadata(resourceName, "version" )

        print( "Current version: " .. curVer )

        if ( text ~= nil ) then
            -- Print latest version
            print( "Latest recommended version: " .. text)

            -- If the versions are different, print it out
            if ( tonumber(curVer) ~= tonumber(text) ) then
                print( "^1This script is outdated, visit your keymaster to get the latest version." )
            else
                print( "^This script is up to date!\n^0" )
            end
        else
            -- In case the version can not be requested, print out an error message
            print( "^1There was an error getting the latest version information. Make sure you have not renamed the script.\n^0" )
        end
    end )
end

-- Export the function
exports("CheckVersion", CheckVersion)

