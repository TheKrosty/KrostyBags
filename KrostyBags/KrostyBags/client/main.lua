MyBags = {}
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) 
			ESX = obj 
		end)
		Citizen.Wait(0)
	end
end)


function OpenBagsMenu()
	TriggerServerEvent('Bags:GetBags')
	local elements = {
		{label = 'Mis mochilas', value = '1'},
		{label = 'Comprar mochilas', value = '2'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mainmenu', {
		title    = 'Mochilas',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == '1' then
			OpenOwnedBagsMenu()
		elseif data.current.value == '2' then 
			OpenBuyBagsMenu()

		end
	end)
end

function OpenOwnedBagsMenu()
	local elements = {}


	for i=1,#Config.Bags do
		if MyBags[i] then
			table.insert(elements, {label = Config.Bags[i].name, value = i})
		end
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mybags', {
		title    = 'Mis mochilas',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		SetPedComponentVariation(PlayerPedId(), 5, Config.Bags[data.current.value].id, Config.Bags[data.current.value].texture, 0)
	end)
end

function OpenBuyBagsMenu()
	local elements = {}

	for i=1,#Config.Bags do
		if not Config.Bags[i].exclusive and not MyBags[i] then 
			table.insert(elements, {label = Config.Bags[i].name.. ' <span style="color:green;">$'..Config.Bags[i].price..'</span>', value = i})
		end
	end

	if not elements[1] then 
		table.insert(elements, {label = '<span style="color:#67009e;">Ya tienes todas las mochilas!</span>', value = ''})
	end
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buybags', {
		title    = 'Comprar mochilas',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('Bags:BuyBag', data.current.value)
	end)
end

Citizen.CreateThread(function()
    for k,v in ipairs(Config.Commands) do
        RegisterCommand(v, function(source, args, rawCommand)
            OpenBagsMenu()
        end, false)
    end
end)

RegisterCommand('mochilas', function()
	OpenBagsMenu()
end)

Citizen.CreateThread(function()
	while true do
		Wait(5)
		if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'mainmenu') then 
			if IsControlJustPressed(0, 202) then 
				ESX.UI.Menu.CloseAll()
			end
		elseif ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'mybags') or ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'buybags') then 
			if IsControlJustPressed(0, 202) then 
				OpenBagsMenu()
			end
		end
	end
end)



RegisterNetEvent('Bags:AddBag')
AddEventHandler('Bags:AddBag', function(bag)
	print(bag)
	MyBags[bag] = true 
end)

