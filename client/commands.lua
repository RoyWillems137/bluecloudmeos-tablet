Citizen.CreateThread(function()
        RegisterCommand(Config["command"], function(source, args, rawCommand)
            if not tabletOpen then
                OpenTablet('Police')
            end
        end, false)

        RegisterCommand(Config["resetcommand"], function()
            SendNUIMessage({
                action = "reload"
            })
        end, false)
end)




