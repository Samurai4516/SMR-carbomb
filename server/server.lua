local playerItemStatus = {}

RegisterNetEvent('smr:checkitem', function()
    local src = source
    local hasItem = false


    if Config.framework == 'esx' then
        ESX = exports['es_extended']:getSharedObject()
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer and xPlayer.getInventoryItem(Config.item) then
            hasItem = xPlayer.getInventoryItem(Config.item).count >= 1
        end
    elseif Config.frameowrk == 'qb' then
        local QBCore = exports['qb-core']:GetCoreObject()
        local Player = QBCore.Functions.GetPlayer(src)
        if Player and Player.Functions.GetItemByName(Config.item) then
            hasItem = Player.Functions.GetItemByName(Config.item).amount >= 1
        end
    end


    if playerItemStatus[src] ~= hasItem then
        TriggerClientEvent('smr:getresults', src, hasItem)
        playerItemStatus[src] = hasItem
    end
end)

local playerItemStatus2 = {}

RegisterNetEvent('smr:checkitem2', function()
    local src = source
    local hasItem = false


    if Config.framework == 'esx' then
        ESX = exports['es_extended']:getSharedObject()
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer and xPlayer.getInventoryItem(Config.defuseitem) then
            hasItem = xPlayer.getInventoryItem(Config.defuseitem).count >= 1
        end
    elseif Config.frameowrk == 'qb' then
        local QBCore = exports['qb-core']:GetCoreObject()
        local Player = QBCore.Functions.GetPlayer(src)
        if Player and Player.Functions.GetItemByName(Config.defuseitem) then
            hasItem = Player.Functions.GetItemByName(Config.defuseitem).amount >= 1
        end
    end


    if playerItemStatus2[src] ~= hasItem then
        TriggerClientEvent('smr:getresults2', src, hasItem)
        playerItemStatus2[src] = hasItem
    end
end)

RegisterNetEvent('smr:removeitem', function()
    local src = source

    if Config.framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            xPlayer.removeInventoryItem(Config.item, 1)
        end
    elseif Config.framework == 'qb' then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            Player.Functions.RemoveItem(Config.item, 1)
        end
    end
end)

RegisterNetEvent('smr:removeitem2', function()
    local src = source

    if Config.framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            xPlayer.removeInventoryItem(Config.defuseitem, 1)
        end
    elseif Config.framework == 'qb' then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            Player.Functions.RemoveItem(Config.defuseitem, 1)
        end
    end
end)