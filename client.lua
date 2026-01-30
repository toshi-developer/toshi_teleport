local QBCore = nil
local ESX = nil
local CurrentJob = nil

-- 初期化とフレームワーク取得
CreateThread(function()
    if Config.Framework == 'qb' then
        QBCore = exports['qb-core']:GetCoreObject()
    elseif Config.Framework == 'qbox' then
        -- QBOXは qbx_core または qb-core 互換を使用
        QBCore = exports['qb-core']:GetCoreObject()
    elseif Config.Framework == 'esx' then
        ESX = exports["es_extended"]:getSharedObject()
    end
    
    UpdateJobInfo()
end)

function UpdateJobInfo()
    if Config.Framework == 'qb' or Config.Framework == 'qbox' then
        local p = QBCore.Functions.GetPlayerData()
        if p and p.job then CurrentJob = p.job.name end
        RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo) CurrentJob = JobInfo.name end)
    elseif Config.Framework == 'esx' then
        local p = ESX.GetPlayerData()
        if p and p.job then CurrentJob = p.job.name end
        RegisterNetEvent('esx:setJob', function(job) CurrentJob = job.name end)
    end
end

function IsAuthorized(point)
    -- ジョブチェック
    if point.jobs and Config.Framework ~= 'standalone' then
        local hasJob = false
        if CurrentJob then
            for _, job in ipairs(point.jobs) do
                if job == CurrentJob then hasJob = true break end
            end
        end
        if not hasJob then return false end
    end
    
    -- アイテムチェック (Config関数を使用)
    if point.requiredItem then
        if not Config.Functions.HasItem(point.requiredItem) then
            -- Config.Functions.Notify('鍵がありません', 'error') -- 必要なら通知
            return false
        end
    end

    return true
end

function TeleportAction(point)
    local ped = PlayerPedId()
    local isInVehicle = IsPedInAnyVehicle(ped, false)

    if isInVehicle and not Config.TeleportInVehicle then
        Config.Functions.Notify('車両からは降りてください', 'error')
        return
    end

    if not IsAuthorized(point) then
        Config.Functions.Notify('権限またはアイテムがありません', 'error')
        return
    end

    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(10) end
    
    local targetVec = point.targetCoords
    if isInVehicle and Config.TeleportInVehicle then
        local vehicle = GetVehiclePedIsIn(ped, false)
        if GetPedInVehicleSeat(vehicle, -1) == ped then
            SetEntityCoords(vehicle, targetVec.x, targetVec.y, targetVec.z)
            SetEntityHeading(vehicle, 0.0)
        else
            SetEntityCoords(ped, targetVec.x, targetVec.y, targetVec.z)
        end
    else
        SetEntityCoords(ped, targetVec.x, targetVec.y, targetVec.z)
    end
    
    TriggerServerEvent('toshi_teleport:server:SendLog', point.name, point.targetName)
    Wait(500)
    DoScreenFadeIn(500)
end

-- ■ Target System Logic
if Config.UseTarget then
    CreateThread(function()
        for i, point in ipairs(Config.TeleportPoints) do
            local zoneName = 'toshi_teleport_' .. point.id
            
            local options = {
                {
                    name = zoneName,
                    icon = 'fas fa-door-open',
                    label = point.targetName .. 'へ移動',
                    onSelect = function()
                        TeleportAction(point)
                    end,
                    canInteract = function()
                        return IsAuthorized(point)
                    end,
                    distance = 2.0
                }
            }

            if Config.TargetSystem == 'ox_target' then
                exports.ox_target:addBoxZone({
                    coords = point.coords,
                    size = vector3(1.5, 1.5, 2.0),
                    rotation = 0,
                    debug = false,
                    options = options
                })
            elseif Config.TargetSystem == 'qb-target' then
                exports['qb-target']:AddBoxZone(zoneName, point.coords, 1.5, 1.5, {
                    name = zoneName,
                    heading = 0,
                    debugPoly = false,
                    minZ = point.coords.z - 1.0,
                    maxZ = point.coords.z + 1.0,
                }, {
                    options = {
                        {
                            type = "client",
                            action = function() TeleportAction(point) end,
                            icon = "fas fa-door-open",
                            label = point.targetName .. 'へ移動',
                            canInteract = function() return IsAuthorized(point) end,
                        }
                    },
                    distance = 2.0
                })
            end
        end
    end)

-- ■ DrawMarker Logic (Legacy)
else
    CreateThread(function()
        while true do
            local sleep = 1000
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            
            for _, point in ipairs(Config.TeleportPoints) do
                local dist = #(coords - point.coords)
                if dist < Config.DrawDistance and IsAuthorized(point) then
                    sleep = 0
                    DrawMarker(27, point.coords.x, point.coords.y, point.coords.z - 0.9, 0,0,0, 0,0,0, 1.5, 1.5, 0.5, point.markerColor.r, point.markerColor.g, point.markerColor.b, 100, false, false, 2, false, nil, nil, false)
                    
                    if dist < Config.InteractDistance then
                        -- シンプルな描画 (ox_libがあれば使う)
                        if GetResourceState('ox_lib') == 'started' then
                            lib.showTextUI('[E] ' .. point.targetName)
                        else
                            BeginTextCommandDisplayHelp('STRING')
                            AddTextComponentSubstringPlayerName('~g~[E]~w~ ' .. point.targetName)
                            EndTextCommandDisplayHelp(0, false, true, -1)
                        end

                        if IsControlJustReleased(0, 38) then
                            if GetResourceState('ox_lib') == 'started' then lib.hideTextUI() end
                            TeleportAction(point)
                        end
                    else
                         -- 離れたらTextUI消去の保険
                        if GetResourceState('ox_lib') == 'started' and dist < Config.DrawDistance then
                            lib.hideTextUI() 
                        end
                    end
                end
            end
            Wait(sleep)
        end
    end)
end