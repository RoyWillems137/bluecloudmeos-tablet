Config = {
    -- Framework
    ["Framework"] = 'esx', -- Welk Framework gebruik je? 'esx' of 'qb'?

    -- Commando's
    ["UseCommand"] = true, -- Wil je een commando gebruiken om de tablet te openen? 
    ["command"] = "meos", -- Welk command moet een speler typen om het MEOS te mogen gebruiken
    ["resetcommand"] = "resetmeos", -- Welk command moet een speler typen om het MEOS te kunnen resetten wanneer deze vastloopt
    ["SyncCommand"] = 'syncvehicles', -- Alleen voor ESX.  Commando om custom voertuig hashes naar het MEOS te synchroniseren

    -- Inventory
    ["UseItem"] = false, -- Wil je een item gebruiken om de tablet te openen?
    ["TabletItem"] = 'tablet', -- Naam van het item dat gebruikt moet worden

    -- Animatie
    ["EnableAnimations"] = true, -- Wil je tablet animaties in of uitgeschakeld hebben

    -- MEOS API instellingen - Alleen voor ESX
    ["OrganisationId"] = 0, -- Vul hier de organisatie ID uit je MEOS instellingen in
    ["ApiBaseUrl"] = 'https://meos.bluecloudhosting.nl/api', -- Basis URL van je MEOS API
    ["ApiKey"] = '', -- Vul hier de tablet API key uit je MEOS instellingen in
    
}
