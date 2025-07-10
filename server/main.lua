if Config.UseItem then
    if Config.Framework == 'esx' then
        ESX = exports['es_extended']:getSharedObject()

        ESX.RegisterUsableItem(Config.TabletItem, function(source)
            TriggerClientEvent('bluecloudmeos-tablet:client:useItem', source)
        end)

    elseif Config.Framework == 'qb' then
        QBCore = exports['qb-core']:GetCoreObject()

        QBCore.Functions.CreateUseableItem(Config.TabletItem, function(source, item)
            TriggerClientEvent('bluecloudmeos-tablet:client:useItem', source)
        end)
    end
end

Citizen.CreateThread(function()
    Wait(3000) -- wacht even zodat het niet conflicteert met andere server logs

    local v = Version
    print("^3[" .. v.resourceName .. "] Versie " .. v.localVersion .. " is geladen.^0")

    PerformHttpRequest("https://api.github.com/repos/" .. v.repo .. "/releases/latest", function(code, data, headers)
        if code == 200 then
            local body = json.decode(data)
            local latest = body.tag_name or body.name

            if latest and latest ~= v.localVersion then
                print("^1[" .. v.resourceName .. "] Er is een nieuwe versie beschikbaar: " .. latest .. "^0")
                print("^1Download de nieuwste versie hier: https://github.com/" .. v.repo .. "/releases/latest^0")
            else
                print("^2[" .. v.resourceName .. "] Je gebruikt de nieuwste versie.^0")
            end
        else
            print("^1[" .. v.resourceName .. "] Kon niet controleren op updates (HTTP " .. code .. ")^0")
        end
    end, "GET", "", {
        ["User-Agent"] = "BlueCloudMEOS-Updater"
    })
end)


