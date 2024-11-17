Config = {}
Config.Framework = 'esx' -- esx --- newqb -- oldqb
Config.NewESX = true -- if u are using esx legacy set this to true else false [esx only]
Config.NotUseDiscord = false
Config.Defaultimage = "https://cdn.discordapp.com/attachments/913877366147801088/939971460280229948/Artboard_1.png"
Config.permaName = true
Config.Distance = 10.0
Config.mChat = false -- if u are using mChat set this to true else false for trigger chat:addMessage

Config.GetFrameWork = function()
    local object = nil
    if Config.Framework == "esx" then
        while object == nil do
            if Config.NewESX then
                object = exports['es_extended']:getSharedObject()
            else
                TriggerEvent('esx:getSharedObject', function(obj) object = obj end)
            end
            Citizen.Wait(0)
        end
    end
    if Config.Framework == "newqb" then
        object = exports["qb-core"]:GetCoreObject()
    end
    if Config.Framework == "oldqb" then
        while object == nil do
            TriggerEvent('QBCore:GetObject', function(obj) object = obj end)
            Citizen.Wait(200)
        end
    end
    return object
end