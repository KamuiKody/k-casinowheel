Config = {}

Config.CarHash = 'adder' -- Spawn Code of the car // rng number for this is 19
Config.RotationSpeed = 0.5 -- How fast the car spins
Config.RotationInterval = 60 -- In miliseconds, how often rotation speed will be added

Config.Garage = 'pillboxgarage' -- garage to store won vehicle
Config.Wheel = vector3(978.01, 50.35, 73.95) -- This you have to changevector3(978.32, 50.83, 74.68)
Config.CarCoords = vector3(963.56, 47.87, 74.9)--vector3(963.49, 48.22, 75.14) -- Car Coords
Config.WalkPos = vector3(976.54, 50.8, 74.68) -- Where your character walks from
Config.WheelPos = vector3(978.01, 50.35, 73.95) -- Wheel pos
Config.BaseWheelPos = vector3(0.17, 0.35, 0.68) -- Base wheel Pos
Config.Cost = 25000 -- Amount
Config.CostType = 'cash'
Config.Rewards = {
    items = {
        {name = 'weapon_snspistol', numbers = {17}, amount = {1}, label = 'SNS Pistol'},
        {name = 'markedbills', numbers = {4,8,11,16}, amount = {10000, 15000, 20000, 25000}, label = 'Marked Money'},
        {name = 'armor', numbers = {2}, amount = {5}, label = 'Armor'}, 
        {name = 'water_bottle', numbers = {5}, amount = {30}, label = 'Waters'},
        {name = 'repairkit', numbers = {18}, amount = {5}, label = 'Repair Kits'},
        {name = 'lockpick', numbers = {10}, amount = {15}, label = 'Lock Picks'},
        {name = 'thermite', numbers = {14}, amount = {1}, label = 'Thermite'},
    },
    money = {
        {name = 'cash', numbers = {6}, amount = {300000}, label = 'Cash'},
        {name = 'cash', numbers = {3,7,15,18}, amount = {10000,20000,30000,40000}, label = 'Cash'},
        {name = 'cash', numbers = {1,9,13}, amount = {10000,20000, 40000}, label = 'Cash'},
        {name = 'cash', numbers = {12}, amount = {200000}, label = 'Cash'}
    }
}
Config.Chances = {-- be sure to remove 20 from the numbers in this list if you arent using cryptos <--ignore him hes crazy
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