if GetResourceState(OXTarget or 'ox_target') == 'started' then
    OXTarget = exports[OXTarget or 'ox_target']
elseif GetResourceState(QBTarget or 'qb-target') == 'started' then
    QBTarget = exports[QBTarget or 'qb-target']
else
    print("No target found for " .. GetCurrentResourceName(), true)
    print('Did you rename your target? Go to config.lua at the end.')
end


RegisterNetEvent('smr:getresults', function(result)
    if result then
        createbombtarget()
    else
        return
    end
end)


Citizen.CreateThread(function()
    while true do
        TriggerServerEvent('smr:checkitem')
        Citizen.Wait(Config.awaittime)
    end
end)

RegisterNetEvent('smr:getresults2', function(result)
    if result then
        createdefusetarget()
    else
        return
    end
end)


Citizen.CreateThread(function()
    while true do
        TriggerServerEvent('smr:checkitem2')
        Citizen.Wait(Config.awaittime)
    end
end)