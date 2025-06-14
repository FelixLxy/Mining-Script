Config = {}

Config.Locale = GetConvar('esx:locale', 'de')

Config.Blip = true --Blip
Config.Prop = 'prop_rock_1_f'
Config.Item = 'stone'
Config.UseOxInventory = true

Config.RequirePickaxe = {
    mode = "weapon", -- "weapon" ore "item"
    name = "WEAPON_FURY_PICKAXE_IRON" -- name the item/weapon
}


Config.CircleZones = {
	FarmField = {coords = vector3(2934.26, 2743.64, 44.99), name = TranslateCap('Mine'), color = 21, sprite = 745, radius = 80.0},
}


Config.SpawnProp = {
    coords = {
        vector3(2952.9092, 2775.0938, 39.3440),
        vector3(2942.9133, 2769.4473, 39.4343),
        vector3(-593.4782, 2080.8103, 131.4009),
        vector3(2935.4399, 2780.2429, 39.1981),
        vector3(2921.8586, 2792.9294, 40.5728),
        vector3(2922.7502, 2808.2146, 43.3073),
        vector3(2941.7134, 2813.0276, 42.4967),
        vector3(2956.2417, 2825.0415, 43.3678),
        vector3(2985.4580, 2811.1541, 44.3789),
        vector3(2993.7244, 2798.3796, 43.9409),
        vector3(3002.1348, 2780.5398, 43.4042),
        vector3(3000.4814, 2764.8538, 42.9033),
        vector3(2996.7722, 2751.2034, 44.1165),
        vector3(2967.8320, 2757.5618, 43.1590),
        vector3(2983.1282, 2767.5388, 42.5501),
        vector3(2988.7939, 2783.2698, 43.8269),
        vector3(2980.7688, 2801.7095, 43.8510),
        vector3(2984.0078, 2819.4539, 45.5548),
        vector3(2976.9443, 2831.6504, 46.1212),
        vector3(2958.3730, 2832.2700, 45.1883),
        vector3(2948.0752, 2835.9429, 47.1520),
        vector3(2944.3403, 2848.4580, 48.3917),
        vector3(2955.0781, 2852.0591, 48.4661),
        vector3(2964.4189, 2847.5310, 47.1823),
        vector3(2956.2986, 2808.3228, 41.937),
        vector3(2952.8677, 2795.5713, 40.8933),
        vector3(2949.9353, 2784.5437, 40.5211),
        vector3(2943.5007, 2774.9766, 39.2229),
        vector3(2940.6550, 2786.4548, 39.8873),
        vector3(2962.6826, 2786.4490, 39.9345),
        vector3(2974.1055, 2787.1265, 39.7111),
    }
}

Config.Heights = {32.0, 33.0, 34.0, 35.0, 36.0, 37.0, 38.0, 39.0, 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0}
Config.Returner = 40.0