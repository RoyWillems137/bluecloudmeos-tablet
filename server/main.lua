local pendingVehicleSyncs = {}

local function notifyPlayer(source, message)
    if source and source > 0 and GetResourceState('chat') == 'started' then
        TriggerClientEvent('chat:addMessage', source, {
            color = { 0, 153, 255 },
            multiline = false,
            args = { 'BlueCloud MEOS', message }
        })
    end
end

local function hasTabletSyncConfig()
    return tonumber(Config.OrganisationId or 0) and tonumber(Config.OrganisationId or 0) > 0
        and type(Config.ApiBaseUrl) == 'string' and Config.ApiBaseUrl ~= ''
        and type(Config.ApiKey) == 'string' and Config.ApiKey ~= ''
end

local function getVehicleSyncQuery()
    if Config.Framework == 'esx' then
        return [[
            SELECT DISTINCT JSON_UNQUOTE(JSON_EXTRACT(vehicle, '$.model')) AS model_hash
            FROM owned_vehicles
            WHERE vehicle IS NOT NULL
              AND JSON_EXTRACT(vehicle, '$.model') IS NOT NULL
        ]]
    end

    return [[
        SELECT DISTINCT hash AS model_hash
        FROM player_vehicles
        WHERE hash IS NOT NULL
          AND hash <> ''
    ]]
end

local function collectVehicleHashes(callback)
    if GetResourceState('oxmysql') ~= 'started' then
        callback(false, 'oxmysql is niet gestart. Deze sync gebruikt oxmysql om voertuig hashes uit de FiveM database te lezen.')
        return
    end

    exports.oxmysql:query(getVehicleSyncQuery(), {}, function(rows)
        if type(rows) ~= 'table' then
            callback(false, 'Kon geen voertuig hashes ophalen uit de database.')
            return
        end

        local hashes = {}
        local seen = {}

        for _, row in ipairs(rows) do
            local modelHash = row.model_hash and tostring(row.model_hash) or nil
            if modelHash and modelHash ~= '' and not seen[modelHash] then
                seen[modelHash] = true
                hashes[#hashes + 1] = modelHash
            end
        end

        callback(true, hashes)
    end)
end

RegisterNetEvent('bluecloudmeos-tablet:server:syncVehicleHashes', function()
    local source = source

    if source == 0 then
        print('^1[BlueCloud MEOS] Gebruik dit sync-commando in-game zodat een client de modelnamen kan vertalen.^0')
        return
    end

    if not hasTabletSyncConfig() then
        notifyPlayer(source, 'De tablet sync is nog niet ingesteld. Vul OrganisationId, ApiBaseUrl en ApiKey in.')
        print('^1[BlueCloud MEOS] Tablet sync configuratie ontbreekt in config.lua.^0')
        return
    end

    collectVehicleHashes(function(success, result)
        if not success then
            notifyPlayer(source, result)
            print('^1[BlueCloud MEOS] ' .. result .. '^0')
            return
        end

        if #result == 0 then
            notifyPlayer(source, 'Er zijn geen voertuig hashes gevonden om te synchroniseren.')
            return
        end

        pendingVehicleSyncs[source] = true
        TriggerClientEvent('bluecloudmeos-tablet:client:resolveVehicleModels', source, result)
        notifyPlayer(source, ('%s voertuig hashes gevonden. Import wordt verzonden naar het MEOS.'):format(#result))
    end)
end)

RegisterNetEvent('bluecloudmeos-tablet:server:submitResolvedVehicleModels', function(vehicles)
    local source = source

    if not pendingVehicleSyncs[source] then
        return
    end

    pendingVehicleSyncs[source] = nil

    if type(vehicles) ~= 'table' or #vehicles == 0 then
        notifyPlayer(source, 'Er konden geen voertuigmodellen worden doorgestuurd naar het MEOS.')
        return
    end

    local endpoint = string.format('%s/importVehicleModels.php', tostring(Config.ApiBaseUrl):gsub('/+$', ''))
    local payload = json.encode({
        org_id = tonumber(Config.OrganisationId),
        api_key = Config.ApiKey,
        vehicles = vehicles
    })

    PerformHttpRequest(endpoint, function(statusCode, responseBody)
        local response = {}
        if responseBody and responseBody ~= '' then
            response = json.decode(responseBody) or {}
        end

        if statusCode >= 200 and statusCode < 300 and response.success then
            local imported = tonumber(response.imported or 0) or 0
            notifyPlayer(source, ('%s voertuigmodellen succesvol gesynchroniseerd naar het MEOS.'):format(imported))
            print(('^2[BlueCloud MEOS] %s voertuigmodellen gesynchroniseerd voor organisatie %s.^0'):format(imported, Config.OrganisationId))
        else
            local errorMessage = response.error or ('HTTP ' .. tostring(statusCode))
            notifyPlayer(source, 'De voertuigsync is mislukt: ' .. errorMessage)
            print('^1[BlueCloud MEOS] Voertuigsync mislukt: ' .. errorMessage .. '^0')
        end
    end, 'POST', payload, {
        ['Content-Type'] = 'application/json'
    })
end)

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

