-------------------------------------------------------------------------
------    ▒█▀▀█ ░█▀▀█ ▒█▀▀█ ▒█░░▒█ ▒█▀▀█ ▒█▀▀▀ ▒█▀▀█ ▒█▀▀█ ▒█░░▒█  ------    
------    ▒█▀▀▄ ▒█▄▄█ ▒█▀▀▄ ▒█▄▄▄█ ▒█░▄▄ ▒█▀▀▀ ▒█▄▄▀ ▒█▄▄▀ ▒█▄▄▄█  ------    
------    ▒█▄▄█ ▒█░▒█ ▒█▄▄█ ░░▒█░░ ▒█▄▄█ ▒█▄▄▄ ▒█░▒█ ▒█░▒█ ░░▒█░░  ------  
-----------------------       Copyright 2020       ----------------------  
-----------------     Do not repost or sell this script     -------------
-------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","baby_rent")

local babyrent = false
local babysecunde = 120

RegisterServerEvent('baby_rent:payment')
AddEventHandler('baby_rent:payment', function()
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if vRP.tryPayment({user_id,100}) then
		babyrent = true
		TriggerClientEvent('baby_rent:spawncar', player)
		TriggerClientEvent('baby_rent:message', player)
		while babyrent do
			Citizen.Wait(1000)
			babysecunde = babysecunde - 1
			if babysecunde == 0 then
				TriggerClientEvent('baby_rent:deleteveh', player)
				babysecunde = 120
				babyrent = false
			end
		end
	else
		TriggerClientEvent('baby_rent:notenough', player)
	end
end)
