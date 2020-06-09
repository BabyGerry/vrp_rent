-------------------------------------------------------------------------
------    ▒█▀▀█ ░█▀▀█ ▒█▀▀█ ▒█░░▒█ ▒█▀▀█ ▒█▀▀▀ ▒█▀▀█ ▒█▀▀█ ▒█░░▒█  ------    
------    ▒█▀▀▄ ▒█▄▄█ ▒█▀▀▄ ▒█▄▄▄█ ▒█░▄▄ ▒█▀▀▀ ▒█▄▄▀ ▒█▄▄▀ ▒█▄▄▄█  ------    
------    ▒█▄▄█ ▒█░▒█ ▒█▄▄█ ░░▒█░░ ▒█▄▄█ ▒█▄▄▄ ▒█░▒█ ▒█░▒█ ░░▒█░░  ------  
-----------------------       Copyright 2020       ----------------------  
-----------------     Do not repost or sell this script     -------------
-------------------------------------------------------------------------
vRP = Proxy.getInterface("vRP")

local pos = {x=-696.81286621094,y=5810.95703125,z=17.330966949462} -- Coords for the Notify {IMPORTANT}

local babycar = {
  [1] = { ["model"] = "the car you need to see", ["x"] = -696.81, ["y"] = 5810.95, ["z"] = 16.33, ["h"] = 67.65 }, -- Rember play with the ([Z] position) to be able to put the car below {IMPORTANT}
}

local function RGBRainbow( frequency )
  local result = {}
  local curtime = GetGameTimer() / 50
  
  result.r = math.floor( math.sin( curtime * frequency + 10 ) * 127 + 128 )
  result.g = math.floor( math.sin( curtime * frequency + 12 ) * 127 + 128 )
  result.b = math.floor( math.sin( curtime * frequency + 14 ) * 127 + 128 )
    
  return result
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    local baby = RGBRainbow( 1 )
    DrawMarker(36, pos.x,pos.y,pos.z+0.60, 0, 0, 0, 0, 0, 0, 0.6,0.6,0.6, baby.r, baby.g, baby.b, 200, 1, 1, 0, 1, 0, 0, 0) -- if you don't want rainbow color, replaces baby.r and the others,put your color in rgb style | site (https://www.rapidtables.com/web/color/RGB_Color.html)
    text_overflow(pos.x,pos.y, pos.z + 1, "~w~Price: ~s~100 ~w~$ ~w~| Duration: ~s~2 ~w~minuts") -- if you don't want rainbow color, change the ~s~ to your color | ~r~ RED , ~b~ BLUE etc..
    text_overflow(pos.x,pos.y, pos.z + 1.25, "~w~Rent ~s~YOUR CAR NAME")
      if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, GetEntityCoords(GetPlayerPed(-1))) < 3.0 then
        license_text("Press ~INPUT_CONTEXT~ to ~r~rent ~b~this ~o~car")
      if IsControlJustPressed(1, 51) then -- Change the number [51 = E] to your key | site (https://docs.fivem.net/docs/game-references/controls/)
        if IsInVehicle() then
          TriggerEvent('baby_rent:pedincar')
        else
          TriggerServerEvent('baby_rent:payment')
        end
      end
    end
  end
end)

RegisterNetEvent('baby_rent:spawncar')
AddEventHandler('baby_rent:spawncar', function()  
  local myPed = GetPlayerPed(-1)
  local player = PlayerId()
  local car = GetHashKey('the car you need to spawn')
  RequestModel(car)
  while not HasModelLoaded(car) do
    Wait(1)
  end
	vRP.teleport({-681.45184326172,5828.357421875,17.331310272216}) -- Change these coordinates with the ones where you want to spawn the rented car
  local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)
  local spawned_car = CreateVehicle(car, coords, GetEntityHeading(myPed), true, false)
  SetVehicleOnGroundProperly(spawned_car)
  SetVehicleNumberPlateText(spawned_car, "BABYGERRY") -- Change the Plate
  SetModelAsNoLongerNeeded(car)
  SetPedIntoVehicle(myPed,spawned_car,-1)
 -- SetVehicleDoorsLocked(car, 1)
  Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(spawned_car))
end)

RegisterNetEvent('baby_rent:message')
AddEventHandler('baby_rent:message', function()
  SetNotificationTextEntry("STRING")
  AddTextComponentString("You just rented a Bmw M3 E92 for 2 minutes")
  SetNotificationMessage("CHAR_CARSITE3", "CHAR_CARSITE3", true, 1, "AGENCY.NAME | Rented now!")
  DrawNotification(false, true)
end)

RegisterNetEvent('baby_rent:pedincar')
AddEventHandler('baby_rent:pedincar', function()
  SetNotificationTextEntry("STRING")
  AddTextComponentString("Esti intr-o masina inchiriata! :)")
  SetNotificationMessage("CHAR_CARSITE3", "CHAR_CARSITE3", true, 1, "AGENCY.NAME | Rented now!")
  DrawNotification(false, true)
end)

RegisterNetEvent('baby_rent:notenough')
AddEventHandler('baby_rent:notenough', function()
  SetNotificationTextEntry("STRING")
  AddTextComponentString("Nu ai destui bani pentru a inchiria!")
  SetNotificationMessage("CHAR_CARSITE3", "CHAR_CARSITE3", true, 1, "AGENCY.NAME | Rented now!")
  DrawNotification(false, true)
end)

RegisterNetEvent( 'baby_rent:deleteveh' )
AddEventHandler( 'baby_rent:deleteveh', function()
    local ped = GetPlayerPed( -1 )
    if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
      local pos = GetEntityCoords( ped )
        if ( IsPedSittingInAnyVehicle( ped ) ) then 
          local car = GetHashKey(pos,'the car you need to spawn', false)    
          local licenseplate = GetVehicleNumberPlateText(car)
            if licenseplate == "BaByGeRRy" then
              SetEntityAsMissionEntity( car, true, true )
              deleteCar( car )
            end
            if ( DoesEntityExist( car ) ) then 
              ShowNotification( "~r~I didn't find any rented cars!" )
            else 
              ShowNotification( "~g~Rent time has expired!" )
            end 
        else
            local playerPos = GetEntityCoords( ped, 1 )
            local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, 5.0, 0.0 )
            local car = GetHashKey(playerPos, inFrontOfPlayer, 'the car you need to spawn')
            local licenseplate = GetVehicleNumberPlateText(car)
            if ( DoesEntityExist( car ) ) then 
            if licenseplate == "BaByGeRRy" then
              SetEntityAsMissionEntity( car, true, true )
              deleteCar( car )
            end
            if ( DoesEntityNotExist( car ) ) then 
              ShowNotification( "~r~I didn't find any rented cars!" )
            else 
              ShowNotification( "~g~Rent time has expired!" )
              end 
            else 
              ShowNotification( "You need to be close to the vehicle!" )
            end 
        end 
    end 
end ) 

function text_overflow(x,y,z, text) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*130
    local scale = scale*fov
    
    if onScreen then
      SetTextScale(0.2*scale, 0.5*scale)
      SetTextFont(1)
      SetTextProportional(1)
      local baby = RGBRainbow( 1 )
      SetTextColour( baby.r, baby.g, baby.b, 255 )
      SetTextDropshadow(0, 0, 0, 0, 255)
      SetTextEdge(2, 0, 0, 0, 150)
      SetTextDropShadow()
      SetTextOutline()
      SetTextEntry("STRING")
      SetTextCentre(1)
      AddTextComponentString(text)
      World3dToScreen2d(x,y,z, 0)
      DrawText(_x,_y)
  end
end

function ShowNotification( text )
  SetNotificationTextEntry( "STRING" )
  AddTextComponentString( text )
  DrawNotification( false, false )
end

function deleteCar( entity )
  Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end

function GetVehicleInDirection( coordFrom, coordTo )
  local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed( -1 ), 0 )
  local _, _, _, _, car = GetRaycastResult( rayHandle )
  return car
end

function timp(x,y ,width,height,scale, text, r,g,b,a, outline)
  SetTextFont(4)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour( 0,0,0, 255 )
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x - width/2, y - height/2 + 0.005)
end

function IsInVehicle()
  local ply = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ply) then
    return true
  else
    return false
  end
end

function license_text(str)
  SetTextComponentFormat("STRING")
  AddTextComponentString(str)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
  for i = 0,#babycar do
      if babycar[i] then
        local carmodel = GetHashKey(babycar[i].model)
        RequestModel(carmodel)
        while not HasModelLoaded(carmodel) do
          Wait(0)
        end
        babymodel = CreateVehicle(carmodel, babycar[i].x, babycar[i].y, babycar[i].z, babycar[i].h, false, false)
        FreezeEntityPosition(babymodel, true)
     -- SetVehicleDoorsLocked(vehicle, 1)
        SetEntityInvincible(babymodel, true)
    end  
  end
end)