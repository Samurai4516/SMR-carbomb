bombedVehicles = {}
ped = PlayerPedId()

function playanimation()
    local animDict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@"
    local anim = "weed_spraybottle_crouch_base_inspector"

    while (not HasAnimDictLoaded(animDict)) do
        RequestAnimDict(animDict)
        Citizen.Wait(20)
    end

    TaskPlayAnim(ped, animDict, anim, 3.0, 1.0, -1, 49, 1, 0, 0, 0)
    local success = plantbomb()
    if not success then
        ClearPedTasks(ped)
    end
end

function playanimation2()
    local animDict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@"
    local anim = "weed_spraybottle_crouch_base_inspector"

    while (not HasAnimDictLoaded(animDict)) do
        RequestAnimDict(animDict)
        Citizen.Wait(20)
    end

    TaskPlayAnim(ped, animDict, anim, 3.0, 1.0, -1, 49, 1, 0, 0, 0)
    defusebomb()
end

function plantbomb()
    local bombChoice = lib.inputDialog("Choose Bomb Type", {{
        type = "select",
        label = "Bomb Type",
        options = { 
            { value = "speed", label = "Speed Bomb" }, 
            { value = "timer", label = "Timer Bomb" }, 
            { value = "engine_start", label = "Engine Start Bomb" } 
        }
    }})

    if not bombChoice then 
        return false 
    end

    local bombType = bombChoice[1]
    TriggerServerEvent('smr:removeitem')
    local bombArmed = false
    local speedLimit = 0
    defused = false
    bombPlanted = true

    targetVehicle = GetClosestVehicle(GetEntityCoords(ped), 10.0, 0, 70)

    if not targetVehicle or targetVehicle == 0 then
        lib.notify({
            title = "Error",
            description = "No nearby vehicle to plant the bomb on.",
            type = "error"
        })
        return false
    end

    bombedVehicles[targetVehicle] = { type = bombType, defused = false }

    if bombType == "timer" then
        local properties = lib.inputDialog("Timer Bomb Properties", {{
            type = "slider",
            label = "Timer (seconds)",
            min = 10,
            max = 120,
            step = 1,
            default = 30,
            required = true
        }})

        if not properties then 
            bombedVehicles[targetVehicle] = nil
            return false 
        end

        local timerDuration = properties[1]

        lib.progressBar({
            duration = Config.progressbartime,
            label = "Planting Timer Bomb",
            canCancel = false
        })
        ClearPedTasks(ped)

        lib.notify({
            title = "Bomb Planted",
            description = "Type: Timer Bomb, Duration: " .. timerDuration .. " seconds",
            type = "success"
        })

        Citizen.CreateThread(function()
            Wait(timerDuration * 1000)
            if not bombedVehicles[targetVehicle].defused then
                TriggerExplosion(targetVehicle, "timer")
            end
            bombPlanted = false
            bombedVehicles[targetVehicle] = nil
        end)

    elseif bombType == "speed" then
        local properties = lib.inputDialog("Speed Bomb Properties", {{
            type = "slider",
            label = "Speed Limit (km/h)",
            min = 50,
            max = 200,
            step = 5,
            default = 100,
            required = true
        }})

        if not properties then 
            bombedVehicles[targetVehicle] = nil
            return false 
        end

        speedLimit = properties[1]

        lib.progressBar({
            duration = Config.progressbartime,
            label = "Planting Speed Bomb",
            canCancel = false
        })
        ClearPedTasks(ped)

        lib.notify({
            title = "Bomb Planted",
            description = "Type: Speed Bomb, Speed Limit: " .. speedLimit .. " km/h",
            type = "success"
        })

        Citizen.CreateThread(function()
            while bombPlanted and not bombedVehicles[targetVehicle].defused do
                local speed = GetEntitySpeed(targetVehicle) * 3.6
                if speed > speedLimit and not bombArmed then
                    bombArmed = true
                    lib.notify({
                        title = "Bomb Armed",
                        description = "The bomb is now armed. Do not drop below " .. speedLimit .. " km/h or it will explode!",
                        type = "info"
                    })
                end
                if bombArmed and speed < speedLimit then
                    TriggerExplosion(targetVehicle, "speed")
                    break
                end
                Wait(500)
            end
            bombPlanted = false
            bombedVehicles[targetVehicle] = nil 
        end)

    elseif bombType == "engine_start" then
        lib.progressBar({
            duration = Config.progressbartime,
            label = "Planting Engine Bomb",
            canCancel = false
        })
        ClearPedTasks(ped)
        
        lib.notify({
            title = "Bomb Planted",
            description = "Type: Engine Start Bomb. The bomb will explode when the engine starts!",
            type = "success"
        })

        Citizen.CreateThread(function()
            while bombPlanted and not bombedVehicles[targetVehicle].defused do
                if IsVehicleEngineOn(targetVehicle) then
                    TriggerExplosion(targetVehicle, "engine_start")
                    break
                end
                Wait(500)
            end
            bombPlanted = false
            bombedVehicles[targetVehicle] = nil
        end)
    end
    return true
end

function defusebomb()
    if bombPlanted and not defused and bombedVehicles[targetVehicle] then
        defused = true
        bombedVehicles[targetVehicle].defused = true 
        lib.notify({ title = "Defuse Attempt", description = "Attempting to defuse the bomb...", type = "info" })
        TriggerServerEvent('smr:removeitem2')
        local success = lib.skillCheck({'easy', 'easy', { areaSize = 60, speedMultiplier = 2 }, 'easy'}, {'w', 'f', 's', 'd'})
        
        if success then
            lib.notify({ title = "Defused", description = "The bomb has been successfully defused!", type = "success" })
            ClearPedTasks(ped)
        else
            lib.notify({ title = "Defuse Failed", description = "The defuse attempt failed! Bomb will explode!", type = "error" })
            TriggerExplosion(targetVehicle, "failed_defuse")
        end
    else
        lib.notify({ title = "No Bomb", description = "There is no active bomb to defuse.", type = "error" })
    end
end


function TriggerExplosion(vehicle, type)
    AddExplosion(GetEntityCoords(vehicle), 2, 1.0, true, false, 1.0)
    lib.notify({
        title = "Boom!",
        description = type == "speed" and "Bomb exploded!" or (type == "timer" and "Time's up! Bomb exploded") or
            (type == "engine_start" and "The engine started! Bomb exploded!") or "Bomb exploded!",
        type = "error"
    })
end
