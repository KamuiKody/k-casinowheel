Config = {}

Config.CarHash = 'adder' -- Spawn Code of the car // rng number for this is 19
Config.Garage = 'pillboxgarage' -- garage to store won vehicle
Config.Wheel = vector3(990.28, 42.84, 70.50) -- This you have to change
Config.CarCoords = vector4(975.69, 40.21, 71.71, 360.07) -- Car Coords
Config.WalkPos = vector3(988.16, 42.44, 71.27) -- Where your character walks from
Config.WheelPos = vector3(990.28, 42.84, 70.50) -- Wheel pos
Config.BaseWheelPos = vector3(983.17, 33.86, 46.46) -- Base wheel Pos
Config.Cost = 25000 -- Amount
Config.CostType = 'chips'
Config.Rewards = {
    items = {
        {name = 'weapon_snspistol', numbers = {17}, amount = {1}, label = 'SNS Pistol'},
        {name = 'markedbills', numbers = {4,8,11,16}, amount = {10000, 15000, 20000, 25000}, label = 'Marked Money'},
        {name = 'armor', numbers = {2}, amount = {5}, label = 'Armor'}, 
        {name = 'water_bottle', numbers = {6}, amount = {30}, label = 'Waters'},
        {name = 'repairkit', numbers = {18}, amount = {5}, label = 'Repair Kits'},
        {name = 'lockpick', numbers = {10}, amount = {15}, label = 'Lock Picks'},
        {name = 'thermite', numbers = {14}, amount = {1}, label = 'Thermite'},
    },
    money = {
        {name = 'cash', numbers = {5}, amount = {300000}, label = 'Cash'},
        {name = 'cash', numbers = {3,7,15,18}, amount = {10000,20000,30000,40000}, label = 'Cash'},
        {name = 'chips', numbers = {1,9,13}, amount = {10000,20000, 40000}, label = 'Casino Chips'},
        {name = 'chips', numbers = {12}, amount = {200000}, label = 'Casino Chips'}
    }
}
Config.Chances = {-- be sure to remove 20 from the numbers in this list if you arent using cryptos
    [1] = {
        max = 500,
        min = 1,
        numbers = {1,17,4,8,6,18,14,20}
    },
    [2] = {
        max = 850,
        min = 501,
        numbers = {2,3,10,17,4,8,20}
    },
    [3] = {
        max = 975,
        min = 851,
        numbers = {7,9,15,17,20}
    },
    [4] = {
        max = 995,
        min = 976,
        numbers = {11,17,13,16,1,20}
    },
    [5] = {
        max = 999,
        min = 996,
        numbers = {12,5}
    },
    [6] = {
        max = 1000,
        min = 1000,
        numbers = {19}
    },
}

Config.Cryptos = { -- only if using k-crypto or if you have a way to add in your own crypto system // rng number is 20
    {name = 'btc', min = 1, max = 1, label = 'Bitcoin'},
    {name = 'eth', min = 1, max = 25, label = 'Ethereum'},
    {name = 'bch', min = 1, max = 100, label = 'Bitcoin Cash'},
    {name = 'ltc', min = 1, max = 100, label = 'Litecoin'}
}