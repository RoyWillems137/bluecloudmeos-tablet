Citizen.CreateThread(function()
        RegisterCommand(Config["command"], function(source, args, rawCommand)
            if not tabletOpen then
                OpenTablet('Police')
            end
        end, false)
end)

