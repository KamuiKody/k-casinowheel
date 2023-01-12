local QBCore = exports['qb-core']:GetCoreObject()
local used = {}
local spinning = false

local GeneratePlate = function()
    local plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return GeneratePlate()
    else
        return plate:upper()
    end
end



local ResetReward = function()
    reward = {
        category = '',
        name = '',
        amount = 0,
    }
    return reward
end
local reward = ResetReward()

local GiveReward = function()
    if not reward then return end
    local src = reward.winner 
    if not src then return end
    local Player = QBCore.Functions.GetPlayer(src)
    local category = reward.category    
    local amount = reward.amount
    local name = reward.name
    if category == 'item' then
        local info = {}
        if name == 'markedbills' then
            info = {worth = amount}
            amount = 1
        end
        Player.Functions.AddItem(name, amount, nil, info)
    elseif category == 'money' then
        if amount >= 200000 then
            TriggerClientEvent("chCasinoWall:bigWin", -1)
        end
        Player.Functions.AddMoney(name, amount)
    elseif category == 'crypto' then
        exports['k-crypto']:addCrypto(src, name, amount)
    elseif category == 'vehicle' then
        TriggerClientEvent("chCasinoWall:bigWin", -1)
        MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
            Player.PlayerData.license,
            Player.PlayerData.citizenid,
            Config.CarHash,
            GetHashKey(Config.CarHash),
            '{}',
            GeneratePlate(),
            Config.Garage,
            1
        })
        Player.Functions.AddItem('carkeys', 1, false, {plate = plate})
    end
    reward = ResetReward()
end

function wheelSpin(src) -- This needs to be like this in order to call itself (if the resource 'k-crypto' is missing)
    local rng = math.random(1,1000)
    local Player = QBCore.Functions.GetPlayer(src)
    local label = ''
    local amount = 0
    for _,v in pairs(Config.Chances) do
        if v.max >= rng or v.min <= rng then
            rng = v.numbers[math.random(1,#v.numbers)]
            break
        end
    end
    local _wheelIndex = rng
    for k,v in pairs(Config.Rewards.items) do
        for i = 1,#v.numbers do
            if v.numbers[i] == rng then
                rng = k
                amount = v.amount[math.random(1,#v.amount)]
                local info = {}
                if v.name == 'markedbills' then
                    info = {worth = amount}
                    amount = 1
                end
                label = v.label
                reward.category = 'item'
                reward.name = v.name
                reward.amount = amount
                break
            end
        end
    end
    for k,v in pairs(Config.Rewards.money) do
        for i = 1,#v.numbers do
            if v.numbers[i] == rng then
                amount = v.amount[math.random(1,#v.amount)]
                label = v.label
                reward.category = 'money'
                reward.name = v.name
                reward.amount = amount
                break
            end
        end
    end
    if rng == 19 then
        label = QBCore.Shared.Vehicles[Config.CarHash].name
        amount = 1
        reward.category = 'vehicle'
    elseif rng < 20 then return {label = label, amount = amount, index = _wheelIndex} end
    if GetResourceState('k-crypto') == 'missing' then
        print("You need to remove the number 20 under each 'numbers' tables in 'Config.Chances'")
        return wheelSpin(src)
    else
        rng = math.random(1,#Config.Cryptos)
        local amount = math.random(Config.Cryptos[rng].min,Config.Cryptos[rng].max)
        local name = Config.Cryptos[rng].name
        label = Config.Cryptos[rng].label
        reward.category = 'crypto'
        reward.name = name
        reward.amount = amount
        -- exports['k-crypto']:addCrypto(src, Config.Cryptos[rng].name, amount)
        return {label = label, amount = amount}
    end
    return {label = label, amount = amount, index = _wheelIndex}
end

QBCore.Functions.CreateCallback('k-casinowheel:cb:getValues', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if spinning then TriggerClientEvent('QBCore:Notify', src, 'Only one person can spin the wheel at a time', 'error') return end
    reward = ResetReward()
    reward.winner = src

    if used[Player.PlayerData.citizenid] then TriggerClientEvent('QBCore:Notify', src, 'You can only use the wheel once.', 'error') return end
    if not Player.Functions.RemoveMoney(Config.CostType,Config.Cost) then TriggerClientEvent('QBCore:Notify', src, 'You don\'t have enough '..Config.CostType..'.', 'error') return end
    used[Player.PlayerData.citizenid] = true
    cb(wheelSpin(src))
    spinning = true
end)

RegisterNetEvent('k-casinowheel:server:applyRewards', function()
    GiveReward()
    spinning = false
end)

RegisterCommand('derp', function()
    TriggerClientEvent("chCasinoWall:bigWin", -1)
end)