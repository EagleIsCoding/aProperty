ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local name = ''
local exit = ''
local label = ''
local inside = ''
local outside = ''
local ipl = ''
local isRoom = ''
local roommenu = ''
local price = ''
local entering = ''
local entrer = ''
local isSingle = ''
local garage = ''
local price = 0 

local Menu = { 

    action = {
        'Motel',
        'Petit',
        'Middle',
        'Modern',
        'High',
        'Luxe',
        'Entrepot (grand)',
        'Entrepot (moyen)',
        'Entrepot (petit)'
    },  

    list = 1
}


local debug = false -- debug mode

local zones = { 
['AIRP'] = "Los Santos International Airport",
['ALAMO'] = "Alamo Sea", 
['ALTA'] = "Alta", 
['ARMYB'] = "Fort Zancudo", 
['BANHAMC'] = "Banham Canyon Dr", 
['BANNING'] = "Banning", 
['BEACH'] = "Vespucci Beach", 
['BHAMCA'] = "Banham Canyon", 
['BRADP'] = "Braddock Pass", 
['BRADT'] = "Braddock Tunnel", 
['BURTON'] = "Burton", 
['CALAFB'] = "Calafia Bridge", 
['CANNY'] = "Raton Canyon", 
['CCREAK'] = "Cassidy Creek", 
['CHAMH'] = "Chamberlain Hills", 
['CHIL'] = "Vinewood Hills", 
['CHU'] = "Chumash", 
['CMSW'] = "Chiliad Mountain State Wilderness", 
['CYPRE'] = "Cypress Flats", 
['DAVIS'] = "Davis", 
['DELBE'] = "Del Perro Beach", 
['DELPE'] = "Del Perro", 
['DELSOL'] = "La Puerta", 
['DESRT'] = "Grand Senora Desert", 
['DOWNT'] = "Downtown", 
['DTVINE'] = "Downtown Vinewood", 
['EAST_V'] = "East Vinewood", 
['EBURO'] = "El Burro Heights", 
['ELGORL'] = "El Gordo Lighthouse", 
['ELYSIAN'] = "Elysian Island", 
['GALFISH'] = "Galilee", 
['GOLF'] = "GWC and Golfing Society", 
['GRAPES'] = "Grapeseed", 
['GREATC'] = "Great Chaparral", 
['HARMO'] = "Harmony", 
['HAWICK'] = "Hawick", 
['HORS'] = "Vinewood Racetrack", 
['HUMLAB'] = "Humane Labs and Research", 
['JAIL'] = "Bolingbroke Penitentiary", 
['KOREAT'] = "Little Seoul", 
['LACT'] = "Land Act Reservoir", 
['LAGO'] = "Lago Zancudo", 
['LDAM'] = "Land Act Dam", 
['LEGSQU'] = "Legion Square", 
['LMESA'] = "La Mesa", 
['LOSPUER'] = "La Puerta", 
['MIRR'] = "Mirror Park", 
['MORN'] = "Morningwood", 
['MOVIE'] = "Richards Majestic", 
['MTCHIL'] = "Mount Chiliad", 
['MTGORDO'] = "Mount Gordo", 
['MTJOSE'] = "Mount Josiah", 
['MURRI'] = "Murrieta Heights", 
['NCHU'] = "North Chumash", 
['NOOSE'] = "N.O.O.S.E", 
['OCEANA'] = "Pacific Ocean", 
['PALCOV'] = "Paleto Cove", 
['PALETO'] = "Paleto Bay", 
['PALFOR'] = "Paleto Forest", 
['PALHIGH'] = "Palomino Highlands", 
['PALMPOW'] = "Palmer-Taylor Power Station", 
['PBLUFF'] = "Pacific Bluffs", 
['PBOX'] = "Pillbox Hill", 
['PROCOB'] = "Procopio Beach", 
['RANCHO'] = "Rancho", 
['RGLEN'] = "Richman Glen", 
['RICHM'] = "Richman", 
['ROCKF'] = "Rockford Hills", 
['RTRAK'] = "Redwood Lights Track", 
['SANAND'] = "San Andreas", 
['SANCHIA'] = "San Chianski Mountain Range", 
['SANDY'] = "Sandy Shores", 
['SKID'] = "Mission Row", 
['SLAB'] = "Stab City", 
['STAD'] = "Maze Bank Arena", 
['STRAW'] = "Strawberry", 
['TATAMO'] = "Tataviam Mountains", 
['TERMINA'] = "Terminal", 
['TEXTI'] = "Textile City", 
['TONGVAH'] = "Tongva Hills", 
['TONGVAV'] = "Tongva Valley", 
['VCANA'] = "Vespucci Canals", 
['VESP'] = "Vespucci", 
['VINE'] = "Vinewood",
['WINDF'] = "Ron Alternates Wind Farm", 
['WVINE'] = "West Vinewood",
['ZANCUDO'] = "Zancudo River",
['ZP_ORT'] = "Port of South Los Santos", 
['ZQ_UAR'] = "Davis Quartz" 
}

local function aProperty()
	RMenu.Add("Property", "create", RageUI.CreateMenu("Création Propriété"," "))
	RMenu:Get('Property', 'create').Closed = function()
		Property = false
	end  
    if not Property then 
        Property = true
		RageUI.Visible(RMenu:Get('Property', 'create'), true)

		Citizen.CreateThread(function()
			while Property do
				RageUI.IsVisible(RMenu:Get("Property",'create'),true,true,true,function()
                    local pos = GetEntityCoords(PlayerPedId())
                    local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
                    local current_zone = zones[GetNameOfZone(pos.x, pos.y, pos.z)]
                        RageUI.Separator("↓ ~b~ Options requises ~s~↓")

                        RageUI.ButtonWithStyle("Placer l'entrée de la propriété", nil, {RightLabel = ""},true, function(Hovered, Active, Selected)
                            if (Selected) then
                                local PlayerCoord = {x = ESX.Math.Round(pos.x, 4), y = ESX.Math.Round(pos.y, 4), z = ESX.Math.Round(pos.z-1, 4)}                          
                                local Out = {x = ESX.Math.Round(pos.x, 4), y = ESX.Math.Round(pos.y, 4), z = ESX.Math.Round(pos.z+2, 4)}
                                
                                entering = json.encode(PlayerCoord)
                                outside  = json.encode(Out)
                
                                PedPosition = pos
                                DrawMarker(22, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.6, 0.6, 0.6, 0, 50, 255, 255, 0, false, true, 2, false, false, false, false)
                                ESX.ShowNotification('position de la porte : ~b~'..PlayerCoord.x..' , '..PlayerCoord.y..' , '..PlayerCoord.z.. '~w~, Adresse : ~b~'..current_zone.. '')
                                ESX.ShowNotification('position de la sortie : ~b~'..PlayerCoord.x..' , '..PlayerCoord.y..' , '..PlayerCoord.z..'')
                            end
                        end)
           
                        RageUI.List('Choix d\'intérieurs :', Menu.action, Menu.list, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)
                            if Active then
                                if Index == 1 then             
                                    RenderSprite("RageUI", "Motel", 0, 486, 432, 250, 80)                                         
                                elseif Index == 2 then
                                    RenderSprite("RageUI", "Low", 0, 486, 432, 250, 80)                         
                                elseif Index == 3 then
                                    RenderSprite("RageUI", "Middle", 0, 486, 432, 250, 80)                                   
                                elseif Index == 4 then
                                    RenderSprite("RageUI", "Modern",0, 486, 432, 250, 80)               
                                elseif Index == 5 then
                                    RenderSprite("RageUI", "High", 0, 486, 432, 250, 80)  
                                elseif Index == 6 then
                                    RenderSprite("RageUI", "Luxe", 0, 486, 432, 250, 80)         
                                elseif Index == 7 then
                                    RenderSprite("RageUI", "Entrepot_grand", 0, 486, 432, 250, 80)             
                                elseif Index == 8 then
                                    RenderSprite("RageUI", "Entrepot_moyen", 0, 486, 432, 250, 80)  
                                elseif Index == 9 then
                                    RenderSprite("RageUI", "Entrepot_petit", 0, 486, 432, 250, 80)                                         
                                end
                            end                       
                            if (Selected) then
                                if Index == 1 then
                                    ipl = '["hei_hw1_blimp_interior_v_motel_mp_milo_"]'
                                    inside = '{"x":151.45,"y":-1007.57,"z":-98.9999}'
                                    exit = '{"x":151.3258,"y":-1007.7642,"z":-100.0000}'
                                    isSingle = 1
                                    isRoom = 1
                                    isGateway = 0
                                    SetEntityCoords(GetPlayerPed(-1), 151.0994, -1007.8073, -98.9999)	

	
                                elseif Index == 2 then
                                    ipl = '[]'
                                    inside = '{"x":265.307,"y":-1002.802,"z":-101.008}'
                                    exit = '{"x":266.0773,"y":-1007.3900,"z":-101.008}'
                                    isSingle = 1
                                    isRoom = 1
                                    isGateway = 0
                                    SetEntityCoords(GetPlayerPed(-1), 265.6031, -1002.9244, -99.0086)	

		                          
                                elseif Index == 3 then
                                    ipl = '[]'
                                    inside = '{"x":-612.16,"y":59.06,"z":97.2}'
                                    exit = '{"x":-603.4308,"y":58.9184,"z":97.2001}'
                                    isSingle = 1
                                    isRoom = 1
                                    isGateway = 0
                                    SetEntityCoords(GetPlayerPed(-1), -616.8566, 59.3575, 98.2000)


                                elseif Index == 4 then
                                    ipl = '["apa_v_mp_h_01_a"]'
                                    inside = '{"x":-785.13,"y":315.79,"z":187.91}'
                                    exit = '{"x":-786.87,"y":315.7497,"z":186.91}'
                                    isSingle = 1
                                    isRoom = 1
                                    isGateway = 0
                                    SetEntityCoords(GetPlayerPed(-1), -788.3881, 320.2430, 187.3132)

                               
                                elseif Index == 5 then
                                    ipl = '[]'
                                    inside = '{"x":-1459.17,"y":-520.58,"z":54.929}'
                                    exit = '{"x":-1451.6394,"y":-523.5562,"z":55.9290}'
                                    isSingle = 1
                                    isRoom = 1
                                    isGateway = 0
                                    SetEntityCoords(GetPlayerPed(-1), -1459.1700, -520.5855, 56.9247) 

                                elseif Index == 6 then
                                    ipl = '[]'
                                    inside = '{"x":-680.6088,"y":590.5321,"z":145.39}'
                                    exit = '{"x":-681.6273,"y":591.9663,"z":144.3930}'				
                                    isSingle = 1
                                    isRoom = 1
                                    isGateway = 0
                                    SetEntityCoords(GetPlayerPed(-1), -674.4503, 595.6156, 145.3796)
                                elseif Index == 7 then
                                    ipl = '[]'
                                    inside = '{"x":1026.5056,"y":-3099.8320,"z":-38.9998}'
                                    exit   = '{"x":998.1795"y":-3091.9169,"z":-39.9999}'
                                    isSingle = 1
                                    isRoom = 1
                                    isGateway = 0
                                    SetEntityCoords(GetPlayerPed(-1), 1026.8707, -3099.8710, -38.9998)	
                                elseif Index == 8 then
                                    ipl = '[]'
                                    inside = '{"x":1048.5067,"y":-3097.0817,"z":-38.9999}'
                                    exit   = '{"x":1072.5505,"y":-3102.5522,"z":-39.9999}'
                                    isSingle = 1
                                    isRoom = 1
                                    isGateway = 0
                                    SetEntityCoords(GetPlayerPed(-1), 1072.8447, -3100.0390, -38.9999)	
                                elseif Index == 9 then
                                    ipl = '[]'
                                    inside = '{"x":1088.1834,"y":-3099.3547,"z":-38.9999}'
                                    exit   = '{"x":1104.6102,"y":-3099.4333,"z":-39.9999}'
                                    isSingle = 1
                                    isRoom = 1
                                    isGateway = 0
                                    SetEntityCoords(GetPlayerPed(-1), 1104.7231, -3100.0690, -38.9999)	

                                end
                            end
                            Menu.list = Index;
                        end)

                        RageUI.ButtonWithStyle("Placer l'endroit du coffre", nil, {RightLabel = ""},true, function(Hovered, Active, Selected)
                            if (Selected) then
     
                                local CoffreCoord = {x = ESX.Math.Round(pos.x, 4), y = ESX.Math.Round(pos.y, 4), z = ESX.Math.Round(pos.z-1, 4)} 
                                roommenu = json.encode(CoffreCoord)
                                ESX.ShowNotification('position du coffre :~b~'..CoffreCoord.x..' , '..CoffreCoord.y..' , '..CoffreCoord.z.. '')
                                DrawMarker(22, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.6, 0.6, 0.6, 0, 50, 255, 255, 0, false, true, 2, false, false, false, false)
                            end
                        end)

                        RageUI.ButtonWithStyle("Nommé la propriété :~b~", nil, {RightLabel = name},true, function(Hovered, Active, Selected)
                            if (Selected) then
                                name  =  OpenKeyboard('name', 'Entrer un nom sans éspace !')
                            end
                        end)

                        RageUI.ButtonWithStyle("Label propriété :~b~", nil, {RightLabel = label},true, function(Hovered, Active, Selected)
                            if (Selected) then
                                label = OpenKeyboard('label', 'Entrer un label !')
                            end
                        end)

                        RageUI.ButtonWithStyle("Prix de vente :~b~", nil, {RightLabel = price},true, function(Hovered, Active, Selected)
                            if (Selected) then
                                price = OpenKeyboard('price', 'Entrer un prix')
                            end
                        end)
                        
                        RageUI.ButtonWithStyle('Annuler' , nil, {Color = { BackgroundColor = { 234, 0, 0, 25 } }}, true, function(Hovered, Active, Selected) 
                            if (Selected) then
                                if name == '' then 
                                    ESX.ShowNotification('~r~Vous n\'avez aucun nom assigné !')
                                else
		    	            SetEntityCoords(PlayerPedId(), PedPosition.x, PedPosition.y, PedPosition.z)		    	              
		    	            RageUI.CloseAll()
		    	            ESX.ShowNotification('~r~Annulation')
                            end
                        end
                        end)

                        RageUI.ButtonWithStyle('Validé et créer la propriété' , nil, {Color = { BackgroundColor = { 81, 255, 0, 25 } }}, true, function(Hovered, Active, Selected) 
                            if (Selected) then
                                if tonumber(price) == nil or tonumber(price) == 0 then
                                    ESX.ShowNotification('~r~Vous n\'avez aucun prix assigné !')
                                else 
                                    if name == '' then 
                                        ESX.ShowNotification('~r~Vous n\'avez aucun nom assigné !')
                                    else 	
                                       TriggerServerEvent('mrw_prop:Save', name, label, entering, exit, inside, outside, ipl, isSingle, isRoom, isGateway, roommenu, garage, price)
                                   
                                       Citizen.Wait(15)
                                       SetEntityCoords(PlayerPedId(), PedPosition.x, PedPosition.y, PedPosition.z)                            
                                    
                                    end
                                end  
                            end
                        end)

            end, function()    
            end, 1)
            Wait(1)
        end
    Wait(0)
    Property = false
    end)
end
end

local function noSpace(str)
    local normalisedString = string.gsub(str, "%s+", "")
    return normalisedString
 end

function OpenKeyboard(type, labelText)
    AddTextEntry('FMMC_KEY_TIP1', labelText)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 25)
	blockinput = true
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult() 
		Citizen.Wait(500) 
		blockinput = false 
		if type == "name" then 
			ESX.ShowNotification("Nom assigné : ~b~"..noSpace(result))
		    return noSpace(result) 
		elseif type == "label" then 
			ESX.ShowNotification("Label assigné : ~b~"..result)
			return result
		else 
		    if tonumber(result) == nil then 
		       ESX.ShowNotification("Vous devez entré un ~r~prix")
		       return
		    end	
		    ESX.ShowNotification("Prix assigné : ~b~"..tonumber(result).."~w~ $")
		    return tonumber(result)
		end
	else
		Citizen.Wait(500)
		blockinput = false 
		return nil
	end
end

--#############################################--
--############# OPEN / CLOSE MENU #############--
--#############################################--

Citizen.CreateThread(function()
	while true do
	 	Citizen.Wait(0)
			if IsControlJustPressed(1,167) then
				aProperty()						
            end
		end
	end)
