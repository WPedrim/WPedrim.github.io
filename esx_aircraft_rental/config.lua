Config = {}

-- Aircraft rental locations
Config.Locations = {
    {
        pos = {x = -1037.775, y = -2738.252, z = 20.169}, -- Los Santos Airport
        blip = true,
        blipName = "Aircraft Rental",
        blipSprite = 423,
        blipColor = 3,
        blipScale = 0.8
    },
    {
        pos = {x = 1747.518, y = 3239.693, z = 42.022}, -- Sandy Shores Airfield
        blip = true,
        blipName = "Aircraft Rental",
        blipSprite = 423,
        blipColor = 3,
        blipScale = 0.8
    }
}

-- Aircraft rental options
Config.Aircraft = {
    {
        name = "Dodo",
        model = "dodo",
        price = 5000,
        label = "Dodo - $5,000"
    },
    {
        name = "Maverick",
        model = "maverick", 
        price = 7500,
        label = "Maverick - $7,500"
    },
    {
        name = "Buzzard",
        model = "buzzard2",
        price = 10000,
        label = "Buzzard - $10,000"
    },
    {
        name = "Luxor",
        model = "luxor",
        price = 15000,
        label = "Luxor - $15,000"
    }
}

-- Cooldown time in seconds (5 minutes = 300 seconds)
Config.CooldownTime = 300

-- Interaction distance
Config.InteractionDistance = 3.0

-- Marker settings
Config.MarkerType = 22
Config.MarkerSize = {x = 0.3, y = 0.3, z = 0.3}
Config.MarkerColor = {r = 0, g = 255, b = 255, a = 180}