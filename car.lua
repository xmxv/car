QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand("car", function()
    SetNuiFocus(true, true) -- Enables the custom UI and sets focus
    SendNUIMessage({
        type = "openCarMenu"
    })
end)

RegisterNUICallback("spawnCar", function(data, cb)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local spawnOffset = 5.0

    local vehicleName = data.vehicle or "npolvic"
    local primaryColor = data.primaryColor
    local secondaryColor = data.secondaryColor
    local upgrades = data.upgrades

    if not IsModelValid(vehicleName) then
        TriggerEvent("chat:addMessage", { color = {255, 0, 0}, args = {"System", "Invalid vehicle name!"} })
        cb("error")
        return
    end

    RequestModel(vehicleName)
    while not HasModelLoaded(vehicleName) do Wait(0) end

    local vehicle = CreateVehicle(GetHashKey(vehicleName), playerCoords.x + spawnOffset, playerCoords.y, playerCoords.z, GetEntityHeading(playerPed), true, false)
    SetPedIntoVehicle(playerPed, vehicle, -1)

    local r, g, b = tonumber("0x" .. primaryColor:sub(2, 3)), tonumber("0x" .. primaryColor:sub(4, 5)), tonumber("0x" .. primaryColor:sub(6, 7))
    local sr, sg, sb = tonumber("0x" .. secondaryColor:sub(2, 3)), tonumber("0x" .. secondaryColor:sub(4, 5)), tonumber("0x" .. secondaryColor:sub(6, 7))
    SetVehicleCustomPrimaryColour(vehicle, r, g, b)
    SetVehicleCustomSecondaryColour(vehicle, sr, sg, sb)

    ApplyVehicleUpgrades(vehicle, upgrades)

    TriggerEvent("chat:addMessage", { color = {0, 255, 0}, args = {"System", "Your custom car is ready!"} })
    cb("success")
end)

RegisterNUICallback("closeMenu", function(_, cb)
    SetNuiFocus(false, false)
    cb("closed")
end)

function ApplyVehicleUpgrades(vehicle, upgrades)
    if upgrades.turbo then ToggleVehicleMod(vehicle, 18, true) end
    if upgrades.bulletproof then SetVehicleTyresCanBurst(vehicle, false) end
    SetVehicleModKit(vehicle, 0) -- Enable upgrades

    SetVehicleMod(vehicle, 11, upgrades.engine or 0, false) -- Engine upgrades
    SetVehicleMod(vehicle, 12, upgrades.brakes or 0, false) -- Brakes
    SetVehicleMod(vehicle, 13, upgrades.transmission or 0, false) -- Transmission
    ToggleVehicleMod(vehicle, 22, upgrades.neon) -- Neon Lights
end
