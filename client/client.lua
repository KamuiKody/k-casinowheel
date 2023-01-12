local QBCore = exports['qb-core']:GetCoreObject()
local _wheel = nil
local _lambo = nil
local _wheelPos = Config.WheelPos
local _baseWheelPos = Config.BaseWheelPos
local _isRolling = false
local model = GetHashKey('vw_prop_vw_luckywheel_02a')
local baseWheelModel = GetHashKey('vw_prop_vw_luckywheel_01a')
local carmodel = GetHashKey(Config.CarModel)
local _basewheel

local playAnim = function(ped, lib, anim)
    TaskPlayAnim(ped, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
    while IsEntityPlayingAnim(ped, lib, anim, 3) do
        Wait(0)
        DisableAllControlActions(0)
    end
end

local LoadModel = function(hash, isVehicle, pos)
    local obj
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
    if isVehicle then
       obj = CreateVehicle(hash, pos.x, pos.y, pos.z, false, false)
       SetEntityHeading(obj, pos.w)
    else
        obj = CreateObject(hash, pos.x, pos.y, pos.z, false, false, true)
        SetEntityHeading(obj, 328.0)
    end
    SetModelAsNoLongerNeeded(obj)
    return obj
end

function doRoll()
    if _isRolling then return false end
    _isRolling = true
    local playerPed = PlayerPedId()
    local _lib = 'anim_casino_a@amb@casino@games@lucky7wheel@female'
    if IsPedMale(playerPed) then
        _lib = 'anim_casino_a@amb@casino@games@lucky7wheel@male'
    end
    local lib, anim = _lib, 'enter_right_to_baseidle'
    while (not HasAnimDictLoaded(lib)) do
        RequestAnimDict(lib)
        Wait(100)
    end
    local _movePos = Config.WalkPos
    TaskGoStraightToCoord(playerPed,  _movePos.x,  _movePos.y,  _movePos.z,  1.0,  -1,  312.2,  0.0)
    local _isMoved = false
    while not _isMoved do
        local coords = GetEntityCoords(PlayerPedId())
        if coords.x >= (_movePos.x - 0.01) and coords.x <= (_movePos.x + 0.01) and coords.y >= (_movePos.y - 0.01) and coords.y <= (_movePos.y + 0.01) then
            _isMoved = true
        end
        Wait(0)
    end
    playAnim(playerPed, lib, anim)
    playAnim(playerPed, lib, 'enter_to_armraisedidle')
    TaskPlayAnim(playerPed, lib, 'armraisedidle_to_spinningidle_high', 8.0, -8.0, -1, 0, 0, false, false, false)
    return true    
end

AddEventHandler('onResourceStop', function(resource) 
    if GetCurrentResourceName() ~= resource then return end
    DeleteObject(_wheel)
    DeleteVehicle(_lambo)
    exports['qb-target']:RemoveZone("wheel")
end)

CreateThread(function()
    exports['qb-target']:AddCircleZone("wheel", Config.Wheel, 1.5, {name = 'wheel' ,debugPoly = false},{
    options = {
        {
            icon = 'fas fa-diamond',
            label = 'Spin Wheel',
            action = function(entity)

                --START WHEEL SPIN
                QBCore.Functions.TriggerCallback('k-casinowheel:cb:getValues', function(data)
                    if not data then return end
                    if not doRoll() then return end
                    _isRolling = true
                    SetEntityHeading(_wheel, 328.0)
                    SetEntityRotation(_wheel, 0.0, 0.0, 0.0, 1, true)
                    if data.index == 20 then data.index = 12 end
                    CreateThread(function()
                        local speedIntCnt = 1
                        local rollspeed = 1.0
                        local _winAngle = (data.index - 1) * 18
                        local _rollAngle = _winAngle + (360 * 8)
                        local _midLength = (_rollAngle / 2)
                        local intCnt = 0
                        while speedIntCnt > 0 do
                            local retval = GetEntityRotation(_wheel, 1)
                            if _rollAngle > _midLength then
                                speedIntCnt = speedIntCnt + 1
                            else
                                speedIntCnt = speedIntCnt - 1
                                if speedIntCnt < 0 then
                                    speedIntCnt = 0
                                end
                            end
                            intCnt = intCnt + 1
                            rollspeed = speedIntCnt / 10
                            local _y = retval.y - rollspeed
                            _rollAngle = _rollAngle - rollspeed
                            SetEntityRotation(_wheel, 0.0, _y, -30.9754, 2, true)
                            Wait(5)
                        end
                        TriggerServerEvent('k-casinowheel:server:applyRewards')
                        QBCore.Functions.Notify('You won '..data.amount..' of '..data.label, 'success')
                    end)
                end)
            end
        }
    },
    distance = 2.5
})
end)

local PlayerData = {}
function SpawnVehicle()
    if _lambo then return end
    PlayerData = QBCore.Functions.GetPlayerData()
    QBCore.Functions.SpawnVehicle(Config.CarHash , function(veh)
        SetVehicleNumberPlateText(veh, 'WINNING')
        SetEntityInvincible(veh, true)
        SetVehicleDoorsLocked(veh, 3)
        FreezeEntityPosition(veh, true)
        _lambo = veh
    end, Config.CarCoords, true)
    local currentRotation = 0.0
    CreateThread(function()
        while true do
            if _lambo then
                currentRotation = currentRotation + Config.RotationSpeed
                SetEntityRotation(_lambo, 0, 0, currentRotation, 1, true)
            end
            Wait(Config.RotationInterval) 
        end
    end)
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(500)
    SpawnVehicle()
    if _wheel then return end
    _basewheel = LoadModel(baseWheelModel, false, _baseWheelPos)
    _wheel = LoadModel(model, false, Config.Wheel)
    
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        SpawnVehicle()
        if _wheel then return end
        _basewheel = LoadModel(baseWheelModel, false, _baseWheelPos)
        _wheel = LoadModel(model, false, Config.Wheel)
    end
end)
