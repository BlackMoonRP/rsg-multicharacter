local RSGCore = exports['rsg-core']:GetCoreObject()

-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/Rexshack-RedM/rsg-multicharacter/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

        --versionCheckPrint('success', ('Current Version: %s'):format(currentVersion))
        --versionCheckPrint('success', ('Latest Version: %s'):format(text))
        
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end

-----------------------------------------------------------------------

-- Functions
local identifierUsed = GetConvar('es_identifierUsed', 'steam')
local foundResources = {}
-- Functions

-- starter items
local StarterItems = {
    ['bread']      = { amount = 5, item = 'bread' },
    ['canteen100'] = { amount = 1, item = 'canteen100' }
}

-- give starter items
local function GiveStarterItems(source)
    local Player = RSGCore.Functions.GetPlayer(source)
    for k, v in pairs(StarterItems) do
        Player.Functions.AddItem(v.item, v.amount)
    end
end

RegisterNetEvent('rsg-multicharacter:server:disconnect', function(source)
    DropPlayer(source, "You have disconnected from RSG RedM")
end)

RegisterNetEvent('rsg-multicharacter:server:loadUserData', function(cData)
    local src = source
    if RSGCore.Player.Login(src, cData.citizenid) then
        print('^2[rsg-core]^7 '..GetPlayerName(src)..' (Citizen ID: '..cData.citizenid..') has succesfully loaded!')
        RSGCore.Commands.Refresh(src)
        TriggerClientEvent("rsg-multicharacter:client:closeNUI", src)
        TriggerClientEvent('rsg-spawn:client:setupSpawnUI', src, cData, false)
        TriggerEvent("rsg-log:server:CreateLog", "joinleave", "Loaded", "green", "**".. GetPlayerName(src) .. "** ("..cData.citizenid.." | "..src..") loaded..")
    end
end)

RegisterNetEvent('rsg-multicharacter:server:createCharacter', function(data, enabledhouses)
    local newData = {}
    local src = source
    newData.cid = data.cid
    newData.charinfo = data
    if RSGCore.Player.Login(src, false, newData) then
        RSGCore.ShowSuccess(GetCurrentResourceName(), GetPlayerName(src)..' has succesfully loaded!')
        RSGCore.Commands.Refresh(src)
        TriggerClientEvent("rsg-multicharacter:client:closeNUI", src)
        GiveStarterItems(src)
    end
end)

RegisterNetEvent('rsg-multicharacter:server:deleteCharacter', function(citizenid)
    RSGCore.Player.DeleteCharacter(source, citizenid)
end)

-- Callbacks

RSGCore.Functions.CreateCallback("rsg-multicharacter:server:setupCharacters", function(source, cb)
    local license = RSGCore.Functions.GetIdentifier(source, 'license')
    local plyChars = {}
    MySQL.Async.fetchAll('SELECT * FROM players WHERE license = @license', {['@license'] = license}, function(result)
        for i = 1, (#result), 1 do
            result[i].charinfo = json.decode(result[i].charinfo)
            result[i].money = json.decode(result[i].money)
            result[i].job = json.decode(result[i].job)
            plyChars[#plyChars+1] = result[i]
        end
        cb(plyChars)
    end)
end)

RSGCore.Functions.CreateCallback("rsg-multicharacter:server:GetNumberOfCharacters", function(source, cb)
    local license = RSGCore.Functions.GetIdentifier(source, 'license')
    local numOfChars = 0
    if next(Config.PlayersNumberOfCharacters) then
        for i, v in pairs(Config.PlayersNumberOfCharacters) do
            if v.license == license then
                numOfChars = v.numberOfChars
                break
            else
                numOfChars = Config.DefaultNumberOfCharacters
            end
        end
    else
        numOfChars = Config.DefaultNumberOfCharacters
    end
    cb(numOfChars)
end)

RSGCore.Functions.CreateCallback("rsg-multicharacter:server:getAppearance", function(source, cb, citizenid)
    local license = RSGCore.Functions.GetIdentifier(source, 'license')
    local skins = MySQL.Sync.fetchAll('SELECT * FROM playerskins WHERE citizenid = ? AND license = ?', {citizenid, license})
    if skins[1] then
        skin = skins[1].skin
        decoded = json.decode(skin)
    end
    local _clothes =  MySQL.Sync.fetchAll('SELECT * FROM playerclothe WHERE citizenid = ? AND license = ?', {citizenid, license})
    if _clothes[1] then
        _clothes = json.decode(_clothes[1].clothes)
    end
    local appearance = {
        skin = decoded,
        clothes = _clothes
    }
    cb(appearance)
end)

RSGCore.Commands.Add("logout", "Logout of Character (Admin Only)", {}, false, function(source)
    RSGCore.Player.Logout(source)
    TriggerClientEvent('rsg-multicharacter:client:chooseChar', source)
end, 'admin')

RSGCore.Commands.Add("closeNUI", "Close Multi NUI", {}, false, function(source)
    TriggerClientEvent('rsg-multicharacter:client:closeNUI', source)
end, 'user')

--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()
