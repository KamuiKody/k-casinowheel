local QBCore = exports['qb-core']:GetCoreObject()
local used = {}

local GeneratePlate = function()
    local plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return GeneratePlate()
    else
        return plate:upper()
    end
end

local wheelSpin = function(src)
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
                rng = Config.Rewars.items[k]
                amount = v.amount[math.random(1,#v.amount)]
                local info = {}
                if v.name == 'markedbills' then
                    info = {worth = amount}
                    amount = 1
                end
                label = v.label
                Player.Functions.AddItem(v.name, amount, nil, info)                
                break
            end
        end
    end
    for k,v in pairs(Config.Rewards.money) do
        for i = 1,#v.numbers do
            if v.numbers[i] == rng then
                amount = v.amount[math.random(1,#v.amount)]
                label = v.label
                Player.Functions.AddMoney(v.name,amount)
                break
            end
        end
    end
    if rng == 19 then
        label = QBCore.Shared.Vehicles[Config.CarHash].name
        amount = 1
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
    elseif rng < 20 then return {label = label, amount = amount, index = _wheelIndex} end
    if GetResourceState('k-crypto') == 'missing' then
        print(You need to remove the number 20 under each 'numbers' tables in Config.Chances)
    else
        rng = math.random(1,#Config.Cryptos)
        local amount = math.random(Config.Cryptos[rng].min,Config.Cryptos[rng].max)
        exports['k-crypto']:addCrypto(src, Config.Cryptos[rng].name, amount)
        return {label = Config.Cryptos[rng].label, amount = amount}
    end
    return {label = label, amount = amount, index = _wheelIndex}
end

QBCore.Functions.CreateCallback('k-casinowheel:cb:getValues', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if used[Player.PlayerData.citizenid] then TriggerClientEvent('QBCore:Notify', src, 'You can only use the wheel once.', 'error') cb(false) end
    if not Player.Functions.RemoveMoney(Config.CostType,Config.Cost) then TriggerClientEvent('QBCore:Notify', src, 'You don\'t have enough '..Config.CostType..'.', 'error') cb(false) end
    used[Player.PlayerData.citizenid] = true
    cb(wheelSpin(src))
end)