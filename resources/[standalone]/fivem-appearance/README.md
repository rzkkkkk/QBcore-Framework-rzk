# aj-fivem-appearance

Original Script: https://github.com/pedr0fontoura/fivem-appearance

ESX Version: https://github.com/ZiggyJoJo/brp-fivem-appearance
## Requirments

- QBCore
- [qb-menu](https://github.com/qbcore-framework/qb-menu)
- [qb-input](https://github.com/qbcore-framework/qb-input)
- [qb-drawtext](https://github.com/IdrisDose/qb-drawtext) (not needed but thats what I used)

## Tattoos
- [qb-tattooshop](https://github.com/MrEvilGamer/qb-tattooshop)

## Setup
- Delete / stop from starting `qb-clothing`
- Delete `aj-` and `-main` from the file name
- Run RunSql.sql
- Put `setr fivem-appearance:locale "en"` in your server.cfg
- Put `ensure fivem-appearance` in your server.cfg
- Follow the code below to replace the events

## Replace the `qb-multicharacter:server:getSkin` callback with:
#### Line: 151 qb-multicharacter/server/main.lua
```lua
QBCore.Functions.CreateCallback("qb-multicharacter:server:getSkin", function(source, cb, cid)
    local result = MySQL.query.await('SELECT * FROM players WHERE citizenid = ?', {cid})
    local PlayerData = result[1]
    PlayerData.model = json.decode(PlayerData.skin)
    if PlayerData.skin ~= nil then
        cb(PlayerData.skin, PlayerData.model.model)
    else
        cb(nil)
    end
end)
```
## Replace the `RegisterNUICallback('cDataPed', function(data)'` callback  with:
#### Line: 109 qb-multicharacter/client/main.lua
```lua
RegisterNUICallback('cDataPed', function(data)
    local cData = data.cData  
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    if cData ~= nil then
        QBCore.Functions.TriggerCallback('qb-multicharacter:server:getSkin', function(data, gender)
            model = gender
            if model ~= nil then
                Citizen.CreateThread(function()
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Citizen.Wait(0)
                    end
                    charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                    data = json.decode(data)
                    exports['fivem-appearance']:setPedAppearance(charPed, data)
                end)
            else
                Citizen.CreateThread(function()
                    local randommodels = {
                        "mp_m_freemode_01",
                        "mp_f_freemode_01",
                    }
                    local model = GetHashKey(randommodels[math.random(1, #randommodels)])
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Citizen.Wait(0)
                    end
                    charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                end)
            end
        end, cData.citizenid)
    else
        Citizen.CreateThread(function()
            local randommodels = {
                "mp_m_freemode_01",
                "mp_f_freemode_01",
            }
            local model = GetHashKey(randommodels[math.random(1, #randommodels)])
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end
            charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
            SetPedComponentVariation(charPed, 0, 0, 0, 2)
            FreezeEntityPosition(charPed, false)
            SetEntityInvincible(charPed, true)
            PlaceObjectOnGroundProperly(charPed)
            SetBlockingOfNonTemporaryEvents(charPed, true)
        end)
    end
end)
```

## Preview

![Customization Preview](https://i.file.glass/XjXTIcvSpw.jpg "Customization Preview")
![Customization Preview](https://i.file.glass/ZcyR746rWk.jpg "Customization Preview")
![Customization Preview](https://i.file.glass/cE1Jk0d9Nk.jpg "Customization Preview")

## Known Bugs

- Creating a character using the export sometimes will scuff it and make you create a new character on every login
- The CreateFirstCharacter event dosent always want to work first try
- If you find anymore issues please report them on the Github issues page!
