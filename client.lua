local antiLagStatus = {}  
local explosionMaxSpeed = Config.explosionMaxSpeed 
local explosionMinSpeed = Config.explosionMinSpeed 
local revLimiterRPM = Config.revLimiterRPM
local flameSize = Config.flameSize
local reverse = 0
local basePitch = Config.basePitch
local exhausts = { "exhaust", "exhaust_2", "exhaust_3", "exhaust_4","exhaust_5", "exhaust_6", "exhaust_7", "exhaust_8", "exhaust_9", "exhaust_10", "exhaust_11", "exhaust_12", "exhaust_13", "exhaust_14", "exhaust_15", "exhaust_16" }
local fxName = "veh_backfire"
local fxGroup = "core"




RegisterCommand("antilag", function()
    local playerPed = PlayerPedId()
    local veh = GetVehiclePedIsIn(playerPed, false)
    if veh and veh ~= 0 then 
        local vehicleID = NetworkGetNetworkIdFromEntity(veh)
        antiLagStatus[vehicleID] = not antiLagStatus[vehicleID]
        PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
        message("~" .. (antiLagStatus[vehicleID] and "g" or "r") .. "~Anti-lag is now " .. (antiLagStatus[vehicleID] and "enabled" or "disabled") .. " for this vehicle~")
    end
end, false)

TriggerEvent('chat:addSuggestion', '/antilag', 'Toggles Anti-Lag effect on/off for the current vehicle', {})

RegisterCommand("antilagmaxspeed", function(source, args, rawCommand)
    if args[1] then
        local newSpeed = tonumber(args[1])
        if newSpeed and newSpeed >= 50 and newSpeed <= 1000 then
            if newSpeed < explosionMinSpeed then
                message("~r~Invalid speed! The maximum speed cannot be smaller than the minimum speed (" .. explosionMinSpeed .. ").")
            else
                explosionMaxSpeed = newSpeed
                PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
                message("~g~Explosion Maximum speed has been set to " .. explosionMaxSpeed)
            end
        else
            message("~r~Invalid explosion speed! Please enter a value between 50 and 1000. (Maximum is the slowest it can be at high RPM)")
        end
    else
        message("~r~Please provide a valid explosion speed value (50-1000).")
    end
end, false)

RegisterCommand("antilagminspeed", function(source, args, rawCommand)
    if args[1] then
        local newSpeed = tonumber(args[1])
        if newSpeed and newSpeed >= 50 and newSpeed <= 1000 then
            if newSpeed > explosionMaxSpeed then
                message("~r~Invalid speed! The minimum speed cannot be greater than the maximum speed (" .. explosionMaxSpeed .. ").")
            else
                explosionMinSpeed = newSpeed
                PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
                message("~g~Explosion Minimum speed has been set to " .. explosionMinSpeed)
            end
        else
            message("~r~Invalid explosion speed! Please enter a value between 50 and 1000. (Minimum is the fastest it can be at high RPM)")
        end
    else
        message("~r~Please provide a valid explosion speed value (50-1000).")
    end
end, false)

TriggerEvent('chat:addSuggestion', '/antilagmaxspeed', 'Sets the explosion speed', {
    { name="Bigger Value", help="The speed of explosion. Range: 50-1000. (Maximum is the Maximum delay at high RPM)" }
})

TriggerEvent('chat:addSuggestion', '/antilagminspeed', 'Sets the explosion speed', {
    { name="Small Value", help="The speed of explosion. Range: 50-1000. (Minimum is the Minimum delay at low RPM)" }
})

RegisterCommand("antilagmaxrpm", function(source, args, rawCommand)
    if args[1] then
        local newRPM = tonumber(args[1])
        if newRPM >= 0.9 and newRPM <= 1.0 then
            revLimiterRPM = newRPM
            PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
            message("~g~Rev limiter RPM has been set to " .. revLimiterRPM)
        else
            message("~r~Invalid RPM! Please enter a value between 0.9 and 1.0.")
        end
    else
        message("~r~Please provide a valid RPM value (0.9-1.0).")
    end
end, false)

TriggerEvent('chat:addSuggestion', '/antilagmaxrpm', 'Sets the Max RPM for Anti-Lag', {
    { name="minRPM", help="The Max RPM to activate Anti-Lag. Range: 0.9-1.0." }
})

RegisterCommand("antilagpitch", function(source, args, rawCommand)
    if args[1] then
        local newPitch = tonumber(args[1])
        if newPitch and newPitch >= 0.5 and newPitch <= 1.0 then
            basePitch = newPitch
            PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
            message("~g~Antilag base pitch set to " .. basePitch)
        else
            message("~r~Invalid pitch! Please enter a value between 0.4 and 1.0")
        end
    else
        message("~r~Please provide a valid pitch value (0.4-1.0)")
    end
end, false)

TriggerEvent('chat:addSuggestion', '/antilagpitch', 'Sets the base pitch of antilag sound', {
    { name="pitch", help="The pitch of the sound. Range: 0.4-1.0 (Lower = deeper sound)" }
})

CreateThread(function()
    while true do
        local minDelay = math.random(explosionMinSpeed, explosionMaxSpeed)
        local maxDelay = math.random(4000, 8000)
        local sleep = 1000
        local player = PlayerPedId()
        local veh = GetVehiclePedIsIn(player, false)
        local maxRPM = 0.85
        local maxRPMLimiter = 0.98

        if veh and GetPedInVehicleSeat(veh, -1) == player then
            local vehicleID = NetworkGetNetworkIdFromEntity(veh)

            if antiLagStatus[vehicleID] then
                sleep = 0
                local RPM = GetVehicleCurrentRpm(veh)
                local gear = GetVehicleCurrentGear(veh)
                local throttle = GetControlNormal(0, 71)
                local randomBias = math.random()
                local rpmScale = RPM / maxRPM
                local rpmScaleLimiter = RPM / maxRPMLimiter
                local delay = math.floor(minDelay + (maxDelay - minDelay) * (1 - rpmScale) * randomBias)
                local delayLimiter = math.floor(minDelay + (maxDelay - minDelay) * (1 - rpmScaleLimiter) * randomBias)

                if gear ~= reverse then
                    if RPM >= revLimiterRPM then
                        if throttle > 0.8 then
                            TriggerServerEvent("flames", VehToNet(veh))
                            TriggerServerEvent("sound_server:PlayWithinDistance", 250.0, tostring(math.random(1, 6)), GetPlayerServerId(PlayerId()))  
                            SetVehicleTurboPressure(veh, 25)
                            Wait(delayLimiter)
                        end
                    elseif RPM > Config.RPM and throttle < 0.000001 then
                        if not IsEntityInAir(veh) then
                            TriggerServerEvent("flames", VehToNet(veh))
                            TriggerServerEvent("sound_server:PlayWithinDistance", 250.0, tostring(math.random(1, 6)), GetPlayerServerId(PlayerId()))
                            SetVehicleTurboPressure(veh, 25)
                            Wait(delay)
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('sound_client:PlayWithinDistance')
AddEventHandler('sound_client:PlayWithinDistance', function(coords, disMax, audioFile, sourcePlayer)
    local entityCoords = GetEntityCoords(PlayerPedId())
    local distance = #(entityCoords - coords)
    local localPlayer = GetPlayerServerId(PlayerId())
    
    if distance <= disMax then
        local volume = 1.0 - (distance / disMax)
        volume = volume * volume
        
        SendNUIMessage({
            transactionType = 'playSound',
            transactionFile = audioFile,
            transactionVolume = volume,
            distance = distance,
            maxDistance = disMax,
            basePitch = basePitch,
            sourcePlayer = sourcePlayer,
            localPlayer = localPlayer
        })
    end
end)

RegisterNetEvent("client_flames")
AddEventHandler("client_flames", function(vehicle)
    if NetworkDoesEntityExistWithNetworkId(vehicle) then
        for _, bones in pairs(exhausts) do
            local boneIndex = GetEntityBoneIndexByName(NetToVeh(vehicle), bones)
            if boneIndex ~= -1 then
                UseParticleFxAssetNextCall(fxGroup)
                local startParticle = StartParticleFxLoopedOnEntityBone(fxName, NetToVeh(vehicle), 0.0, 0.0, 0.0, 0.0,
                    0.0,
                    0.0,
                    GetEntityBoneIndexByName(NetToVeh(vehicle), bones), flameSize, 0.0, 0.0, 0.0)
                StopParticleFxLooped(startParticle, true)
            end
        end
    end
end)

function message(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end
