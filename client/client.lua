ESX                           = nil
local PlayerData              = {}

Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
      Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
end)
  
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer    
end)

RegisterNetEvent('gusti_simcards:changeNumber')
AddEventHandler('gusti_simcards:changeNumber', function(xPlayer) 
    PlayerData = xPlayer   
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'number', {
        title = "Enter your new cellphone number"
    }, function(data, menu)
        local number = data.value
        if number ~= nil then
            local rawNumber = number
            local isValid = tonumber(rawNumber) ~= nil
            if string.len(rawNumber) == 7 then
                if isValid then
                    local inventory = ESX.GetPlayerData().inventory
                    local simCardCount = nil
                    for i=1, #inventory, 1 do                          
                        if inventory[i].name == 'sim_card' then
                            simCardCount = inventory[i].count
                        end
                    end
                    if simCardCount > 0 then
                        TriggerServerEvent('gusti_simcards:useSimCard', number)               
                    else 
                        ESX.ShowNotification(_U('no_sim'))
                    end  
                else
                    ESX.ShowNotification(_U('digits'))
                end             
            else
                ESX.ShowNotification(_U('max_digits'))
            end
            menu.close()                 
        else
            ESX.ShowNotification(_U('no_number'))
            menu.close()
        end

    end, 
    function(data, menu)
        menu.close()
    end) 
end)

RegisterNetEvent('gusti_simcards:startNumChange')
AddEventHandler('gusti_simcards:startNumChange', function(newNum)
    if Config.UseAnimation then
        exports.dpemotes:OnEmotePlay({"cellphone@", "cellphone_text_read_base", "Phone", AnimationOptions =
        {
            Prop = "prop_npc_phone_02",
            PropBone = 28422,
            PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
            EmoteLoop = true,
            EmoteMoving = true,
        }})

        local complete = false
        Citizen.Wait(Config.TimeToChange)
        complete = true     
        if complete then
            TriggerServerEvent('gusti_simcards:changeNumber', newNum)        
            exports.dpemotes:EmoteCancel()                                              
            ESX.ShowNotification(('updated')' ~g~' .. newNum)                                        
            if Config.gcphoneEnabled then
                Citizen.Wait(2000)
                TriggerServerEvent('gcPhone:allUpdate')
            end         
        end   
    else
        TriggerServerEvent('gusti_simcards:changeNumber', newNum)   
        ESX.ShowNotification(('updated')' ~g~' .. newNum)
        Citizen.Wait(2000)                             
        if Config.gcphoneEnabled then
            TriggerServerEvent('gcPhone:allUpdate')
        end  
    end
	 
end)

function loadanimdict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
	end
end