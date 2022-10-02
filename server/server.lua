ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('gusti_simcards:useSimCard')
AddEventHandler('gusti_simcards:useSimCard', function(number)
    local _source = source
    local rawNumber = number
    local xPlayer = ESX.GetPlayerFromId(_source)
    local numFirstThree = string.sub(rawNumber, 1, 3)
    local numLastFour = string.sub(rawNumber, 4, 7)
    local numFinal = numFirstThree .. '-' .. numLastFour
    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE phone_number = @phone_number", {['@phone_number'] = numFinal})
    if result[1] ~= nil then
        TriggerClientEvent('esx:showNotification', _source, '~r~That number is already in use')
    else       
        TriggerClientEvent('gusti_simcards:startNumChange', _source, numFinal)
    end     
end)

RegisterServerEvent('gusti_simcards:changeNumber')
AddEventHandler('gusti_simcards:changeNumber', function(newNum)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)               
    MySQL.Async.execute('UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier,
        ['@phone_number'] = newNum
    })
    xPlayer.removeInventoryItem('sim_card', 1)
    TriggerClientEvent('gusti_simcards:success', _source, newNum)
end)

ESX.RegisterUsableItem('sim_card', function(source)
	local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    TriggerClientEvent('gusti_simcards:changeNumber', xPlayer.source)
end)

--[[ Version Checker ]]--
local version = "1.1.0"

if Config.CheckForUpdates then
    AddEventHandler("onResourceStart", function(resource)
        if resource == GetCurrentResourceName() then
            CheckFrameworkVersion()
        end
    end)
end

function CheckFrameworkVersion()
    PerformHttpRequest("https://raw.githubusercontent.com/Gustiagung19/gusti-simcards/master/version.txt", function(err, text, headers)
        if string.match(text, version) then
            print(" ")
            print("--------- ^4GUSTI SIMCARDS VERSION^7 ---------")
            print("gusti-simcards ^2is up to date^7 and ready to go!")
            print("Running on Version: ^2" .. version .."^7")
            print("^4https://github.com/Gustiagung19/gusti-simcards^7")
            print("--------------------------------------------")
            print(" ")
        else
          print(" ")
          print("--------- ^4GUSTI SIMCARDS VERSION^7 ---------")
          print("gusti-simcards ^1is not up to date!^7 Please update!")
          print("Curent Version: ^1" .. version .. "^7 Latest Version: ^2" .. text .."^7")
          print("^4https://github.com/Gustiagung19/gusti-simcards^7")
          print("--------------------------------------------")
          print(" ")
        end

    end, "GET", "", {})

end