local QBCore = nil
local ESX = nil

if Config.Framework == 'qb' or Config.Framework == 'qbox' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'esx' then
    ESX = exports["es_extended"]:getSharedObject()
end

RegisterNetEvent('toshi_teleport:server:SendLog', function(fromName, toName)
    local src = source
    if not Config.EnableLogs then return end

    local playerName = "Unknown"
    local uniqueId = "Unknown"

    if Config.Framework == 'qb' or Config.Framework == 'qbox' then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            playerName = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
            uniqueId = Player.PlayerData.citizenid
        end

    elseif Config.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            playerName = xPlayer.getName()
            uniqueId = xPlayer.getIdentifier()
        end

    elseif Config.Framework == 'standalone' then
        playerName = GetPlayerName(src)
        uniqueId = "ID:" .. src
    end

    local discordContent = string.format("**ユーザー:** %s (ID: %s)\n**移動:** %s ➡ %s", playerName, uniqueId, fromName, toName)
    SendToDiscord(discordContent)
end)

function SendToDiscord(message)
    if not Config.WebhookURL or Config.WebhookURL == "YOUR_WEBHOOK_URL" then return end
    
    local embed = {
        {
            ["color"] = 3447003,
            ["title"] = "テレポート使用ログ",
            ["description"] = message,
            ["footer"] = { ["text"] = os.date("%Y/%m/%d %H:%M:%S") },
        }
    }
    PerformHttpRequest(Config.WebhookURL, function(err, text, headers) end, 'POST', json.encode({username = Config.BotName, embeds = embed}), { ['Content-Type'] = 'application/json' })
end