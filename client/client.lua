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

function doRoll()
    if not _isRolling then
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
end

local playAnim = function(ped, lib, anim)
    TaskPlayAnim(ped, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
    while IsEntityPlayingAnim(ped, lib, anim, 3) do
        Wait(0)
        DisableAllControlActions(0)
    end
end

local LoadModel = function(hash,isVehicle, pos)
    local obj
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
    if isVehicle then
       obj = CreateVehicle(hash, pos, false, false)
    else
        obj = CreateObject(hash, pos.x, pos.y, pos.z, false, false, true)
        SetEntityHeading(obj, 328.0)
    end
    SetModelAsNoLongerNeeded(obj)
    return obj
end

CreateThread(function()
    -- Base wheel
    _basewheel = LoadModel(baseWheelModel, false, _baseWheelPos)
    -- Wheel
    _wheel = LoadModel(model, false, Config.Wheel) 
    -- Car
    local vehicle = LoadModel(carmodel, true, Config.CarCoords)
    FreezeEntityPosition(vehicle, true)
    local _curPos = GetEntityCoords(vehicle)
    SetEntityCoords(vehicle, _curPos.x, _curPos.y, _curPos.z + 1, false, false, true, true)
    _lambo = vehicle
    exports['qb-target']:AddTargetEntity(_wheel, {
        options = {
            {
                icon = 'fas fa-example',
                action = function(entity)
                    QBCore.Functions.TriggerCallback('k-casinowheel:cb:getValues', function(data)
                        if data then
                            if doRoll() then
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
                                        Wait(0)
                                    end
                                end)
                            end
                        end
                    end)
                end
            }
        },
        distance = 2.5
    })
end)
