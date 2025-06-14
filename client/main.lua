local spawnedFarms = 0
local farmPlants = {}
local isPickingUp = false
local isWashing = false

CreateThread(function()
	while true do
		Wait(700)
		local coords = GetEntityCoords(PlayerPedId())

		if #(coords - Config.CircleZones.FarmField.coords) < 200 then
			SpawnFarmPlants()
		end
	end
end)

function MessageUpLeftCorner(msg)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

CreateThread(function()
    while true do
        local Sleep = 500
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local nearbyObject, nearbyID

        for i = 1, #farmPlants, 1 do
            if #(coords - GetEntityCoords(farmPlants[i])) < 2.5 then
                nearbyObject, nearbyID = farmPlants[i], i
            end
        end

        if nearbyObject and IsPedOnFoot(playerPed) then
            Sleep = 0
            if not isPickingUp then
                MessageUpLeftCorner("Press ~INPUT_CONTEXT~ to mine Stone")
            end

            if IsControlJustReleased(0, 38) and not isPickingUp then
                isPickingUp = true

                ESX.TriggerServerCallback('stone:canPickUp', function(canPickUp)
                    if canPickUp then
                        local canMine = false

                        if Config.RequirePickaxe.mode == "weapon" then
                            canMine = (GetSelectedPedWeapon(playerPed) == GetHashKey(Config.RequirePickaxe.name))

                            if canMine then
                                startMining(nearbyObject, nearbyID)
                            else
                                ESX.ShowNotification('You need a Pickaxe!')
                                isPickingUp = false
                            end

                        elseif Config.RequirePickaxe.mode == "item" then
                            ESX.TriggerServerCallback('stone:hasItem', function(hasItem)
                                if hasItem then
                                    startMining(nearbyObject, nearbyID)
                                else
                                    ESX.ShowNotification('You need a Pickaxe!')
                                    isPickingUp = false
                                end
                            end, Config.RequirePickaxe.name)
                        else
                            ESX.ShowNotification('Invalid pickaxe requirement mode in config!')
                            isPickingUp = false
                        end

                    else
                        ESX.ShowNotification(TranslateCap('Your inventory is full!'))
                        isPickingUp = false
                    end
                end, Config.Item)
            end
        end

        Wait(Sleep)
    end
end)

function startMining(nearbyObject, nearbyID)
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, true)
    exports['xsound']:PlayUrl('miningsound', './sounds/mining.ogg', 0.25, false)

    if lib.progressCircle({
        duration = 8000,
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
            car = false,
            combat = true,
        },
        anim = {
            dict = 'melee@large_wpn@streamed_core',
            clip = 'ground_attack_on_spot_body',
        },
    }) then
        local randomValue = math.random(1, 2)
        local skillCheckDifficulty = (randomValue == 1) and "medium" or "hard"

        local success = lib.skillCheck(skillCheckDifficulty)
        if success then
            ESX.Game.DeleteObject(nearbyObject)
            table.remove(farmPlants, nearbyID)
            spawnedFarms = spawnedFarms - 1
            TriggerServerEvent('stone:pickedUpItem')
        end
    else
        print('cancelled')
    end

    FreezeEntityPosition(playerPed, false)
    isPickingUp = false
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(farmPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnFarmPlants()
	while spawnedFarms < 20 do
		Wait(0)
		local farmCoords = GenerateFarmCoords()

		ESX.Game.SpawnLocalObject(Config.Prop, farmCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(farmPlants, obj)
			spawnedFarms = spawnedFarms + 1
		end)
	end
end

function ValidateFarmCoord(plantCoord)
	if spawnedFarms > 0 then
		for _, v in pairs(farmPlants) do
			if #(plantCoord - GetEntityCoords(v)) < 5 then
				return false
			end
		end

		if #(plantCoord - Config.CircleZones.FarmField.coords) > 200 then
			return false
		end
	end

	return true
end

function GenerateFarmCoords()
	while true do
		Wait(0)
		local configCoords = Config.SpawnProp.coords
		local coord = configCoords[math.random(1, #configCoords)]

		if ValidateFarmCoord(coord) then
			return coord
		end
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = Config.Heights

	for _, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)
		if foundGround then
			return z
		end
	end

	return Config.Returner
end

function CreateBlipCircle(coords, text, radius, color, sprite)
	if Config.Blipumrandung then
		local blip = AddBlipForRadius(coords, radius)
		SetBlipHighDetail(blip, true)
		SetBlipColour(blip, 1)
		SetBlipAlpha(blip, 128)
	end

	local blip = AddBlipForCoord(coords)
	SetBlipHighDetail(blip, true)
	SetBlipSprite(blip, sprite)
	SetBlipScale(blip, 0.6)
	SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandSetBlipName(blip)
end

CreateThread(function()
	if Config.Blip then
		for _, zone in pairs(Config.CircleZones) do
			CreateBlipCircle(zone.coords, zone.name, zone.radius, zone.color, zone.sprite)
		end
	end
end)
