function createbombtarget()
    if OXTarget then
        exports.ox_target:addGlobalVehicle({
            {
                icon = 'fa-solid fa-bomb',
                label = 'Plant Bomb',
                onSelect = function(entity)
                   playanimation()
                end,
                distance = 2.5
            }
        })
    elseif QBTarget then
        exports['qb-target']:AddGlobalVehicle({
            options = {
                {
                    icon = 'fa-solid fa-bomb',
                    label = 'Plant Bomb',
                    action = function(entity)
                        playanimation()
                    end
                }
            },
            distance = 2.5
        })
    end
end

function createdefusetarget()
    if OXTarget then
        OXTarget:addGlobalVehicle({
            {
                name = 'defuse_bomb',
                icon = 'fas fa-cut',
                label = 'Defuse Bomb',
                onSelect = function() playanimation2() end,
                canInteract = function(vehicle)
                    return bombedVehicles[vehicle] and not bombedVehicles[vehicle].defused
                end
            }
        })
    elseif QBTarget then
        QBTarget:AddGlobalVehicle({
            options = {
                {
                    type = "client",
                    icon = 'fas fa-cut',
                    label = 'Defuse Bomb',
                    action = function() playanimation2() end,
                    canInteract = function(vehicle)
                        return bombedVehicles[vehicle] and not bombedVehicles[vehicle].defused
                    end
                }
            },
            distance = 2.5
        })
    end
end