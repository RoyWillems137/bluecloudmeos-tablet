RegisterNetEvent('bluecloud:meos:trigger')
AddEventHandler('bluecloud:meos:trigger', function()
    if not tabletOpen then
        OpenTablet('Police')
        tabletOpen = true
    else
        CloseTablet()
        tabletOpen = false
    end
end)
