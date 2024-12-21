RegisterNetEvent("flames", function(entity)
    local src = source
    if not DoesEntityExist(NetworkGetEntityFromNetworkId(entity)) then
        print(("Invalid entity ID from source %d: %s"):format(src, tostring(entity)))
        return
    end

    TriggerClientEvent("client_flames", -1, entity)
end)

RegisterNetEvent('sound_server:PlayWithinDistance', function(disMax, audioFile)
    local src = source
    local coords = GetEntityCoords(GetPlayerPed(src))

    if type(disMax) ~= "number" or disMax <= 0 or disMax > 1500 then
        print(("Invalid distance from source %d: %s"):format(src, tostring(disMax)))
        return
    end

    if type(audioFile) ~= "string" or #audioFile == 0 then
        print(("Invalid audio file from source %d: %s"):format(src, tostring(audioFile)))
        return
    end

    TriggerClientEvent('sound_client:PlayWithinDistance', -1, coords, disMax, audioFile)
end)
