Config = {}

-- 【フレームワーク設定】
-- 'qb'   : QBCore
-- 'qbox' : QBOX (New!)
-- 'esx'  : ESX Legacy
-- 'standalone': フレームワークなし
Config.Framework = 'qbox'

-- 【システム設定】
Config.UseTarget = true -- true: Targetを使用 (ox_target/qb-target), false: マーカーとEキー
Config.TargetSystem = 'ox_target' -- 'ox_target' or 'qb-target'

-- 【基本設定】
Config.TeleportInVehicle = true -- 車両に乗ったまま移動許可
Config.DrawDistance = 10.0 -- マーカー表示距離 (Target未使用時)

-- 【ログ設定】
Config.EnableLogs = true
Config.WebhookURL = "YOUR_WEBHOOK_URL"
Config.BotName = "Toshi Dev Teleport Log"

-- =============================================
--     カスタマイズ関数 (Bridge Functions)
-- =============================================
-- 環境に合わせてここを書き換えるだけで対応できます

Config.Functions = {
    -- ■ 通知システム (Notify)
    Notify = function(msg, type)
        -- 例: ox_libが使えるなら使う
        if GetResourceState('ox_lib') == 'started' then
            lib.notify({ title = 'Teleport', description = msg, type = type })
        -- QBCore / QBOX
        elseif Config.Framework == 'qb' or Config.Framework == 'qbox' then
            local QBCore = exports['qb-core']:GetCoreObject()
            QBCore.Functions.Notify(msg, type)
        -- ESX
        elseif Config.Framework == 'esx' then
            local ESX = exports["es_extended"]:getSharedObject()
            ESX.ShowNotification(msg)
        else
            -- その他 (チャット)
            TriggerEvent('chat:addMessage', { args = { '^1Teleport', msg } })
        end
    end,

    -- ■ アイテムチェック (Inventory)
    -- 特定の鍵を持っていないと通れない設定などに使用
    HasItem = function(item, amount)
        if not item then return true end -- アイテム指定がなければ許可

        -- ox_inventory / qb-inventory / qs-inventory などの処理を記述
        if GetResourceState('ox_inventory') == 'started' then
            local count = exports.ox_inventory:Search('count', item)
            return count >= (amount or 1)
        elseif Config.Framework == 'qb' or Config.Framework == 'qbox' then
            local QBCore = exports['qb-core']:GetCoreObject()
            return QBCore.Functions.HasItem(item)
        elseif Config.Framework == 'esx' then
            local ESX = exports["es_extended"]:getSharedObject()
            local xPlayer = ESX.GetPlayerData()
            for _, v in ipairs(xPlayer.inventory) do
                if v.name == item and v.count >= (amount or 1) then
                    return true
                end
            end
        end
        return true -- デフォルト許可
    end
}

-- 【テレポート地点の設定】
Config.TeleportPoints = {
    {
        id = 'mrpd_main',
        name = 'ロスサントス本署',
        jobs = {'police', 'sheriff'},
        -- requiredItem = 'police_card', -- アイテムが必要な場合はコメントを外す
        coords = vector3(463.15, -1006.14, 22.08),
        targetName = '北署',
        targetCoords = vector3(-447.88, 6014.28, 31.72),
        markerColor = {r = 0, g = 255, b = 0},
    },
    {
        id = 'mrpd_north',
        name = '北署',
        jobs = {'police', 'sheriff'},
        coords = vector3(-447.88, 6014.28, 31.72),
        targetName = 'ロスサントス本署',
        targetCoords = vector3(463.15, -1006.14, 22.08),
        markerColor = {r = 255, g = 0, b = 0}
    },
}