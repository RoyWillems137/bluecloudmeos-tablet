tabletOpen, CurrentProp = false, nil
local Framework = nil
ESX = nil

Citizen.CreateThread(function()
    while Framework == nil do
        if Config.Framework == 'esx' then
            Citizen.CreateThread(function()
                while ESX == nil do
                    ESX = exports["es_extended"]:getSharedObject()
                    Citizen.Wait(0)
                end
            end)
        elseif Config.Framework == 'qb' then
            Framework = exports['qb-core']:GetCoreObject()
        end
        Wait(200)
    end
end)

RegisterNUICallback('CloseTablet', function(data)
    CloseTablet()
end)

OpenTablet = function(type)
    if Config.EnableAnimations then
        AddPropToPed()
        loadAnimDict('amb@code_human_in_bus_passenger_idles@female@tablet@base')
        TaskPlayAnim(GetPlayerPed(-1), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 3.0, 3.0, -1,
            49, 0, 0, 0, 0)
    end

    tabletOpen = true
    SetNuiFocus(true, true)

    SendNUIMessage({
        action = string.format('Open%sTablet', type)
    })
end

if Config.UseItem then
    exports('useTablet', function(data, slot)
        if not tabletOpen then
            OpenTablet('Police')
        end
    end)
end

CloseTablet = function()
    if Config.EnableAnimations then
        DeleteEntity(CurrentProp)
        ClearPedTasks(GetPlayerPed(-1))
    end
    SetNuiFocus(false, false)
    tabletOpen = false
end

AddPropToPed = function()
    RequestModelHash('prop_cs_tablet')
    CurrentProp = CreateObject(GetHashKey('prop_cs_tablet'), 0, 0, 0, true, false, false)
    local PropNetId = ObjToNet(CurrentProp)
    SetNetworkIdExistsOnAllMachines(PropNetId, true)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(CurrentProp), true)
    AttachEntityToEntity(CurrentProp, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 60309), 0.03, 0.002, -0.0,
        0.0, -20.0, 0.0, true, true, false, true, 1, true)
end

loadAnimDict = function(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(1)
    end
end

RequestModelHash = function(Model)
    RequestModel(Model)
    while not HasModelLoaded(Model) do
        Citizen.Wait(1)
    end
end
