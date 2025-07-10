
if Config.UseCommand then
RegisterCommand(Config["command"], function(source, args, rawCommand)
    if not tabletOpen then
        OpenTablet('Police')
    end
end, false)
end

RegisterCommand(Config["resetcommand"], function()
    SendNUIMessage({
        action = "reload"
    })

    if CurrentProp and DoesEntityExist(CurrentProp) then
        DeleteEntity(CurrentProp)
        CurrentProp = nil
    end

    ClearPedTasks(PlayerPedId())
end, false)


if Config.UseItem then
    RegisterNetEvent('bluecloudmeos-tablet:client:useItem', function()
        if not tabletOpen then
            OpenTablet('Police')
        end
    end)
end