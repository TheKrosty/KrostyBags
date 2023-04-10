ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 

RegisterServerEvent('Bags:GetBags')
AddEventHandler('Bags:GetBags', function(bag)
  local xPlayer = ESX.GetPlayerFromId(source)
  local _source = source
  MySQL.Async.fetchAll("SELECT * FROM mochilas WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier}, function(result)
    for i=1,#result do
      TriggerClientEvent('Bags:AddBag', _source, result[i].bag)
    end
  end)
end)

RegisterServerEvent('Bags:BuyBag')
AddEventHandler('Bags:BuyBag', function(bag)
  local xPlayer = ESX.GetPlayerFromId(source)
  local mymoney = xPlayer.getAccount(Config.Account).money
  local price = Config.Bags[bag].price
  if mymoney >= price then
    TriggerClientEvent('esx:showNotification', source, 'Has comprado la mochila: '..Config.Bags[bag].name)
    xPlayer.removeAccountMoney(Config.Account, price)
      MySQL.Async.execute("INSERT INTO mochilas (identifier, bag) VALUES (@identifier, @bag)" , {
        ['@identifier'] = xPlayer.identifier,
        ['@bag'] = bag,
      })
  else
    TriggerClientEvent('esx:showNotification', source, 'No tienes suficientes ~y~Nombre de la coin~w~!')
  end
end)

Citizen.CreateThread(function()
  if GetCurrentResourceName() ~= KrostyBags_ then 
        print("[" .. GetCurrentResourceName() .. "] " .. "Thanks for your purchase!")
        print("[" .. GetCurrentResourceName() .. "] " .. "For Support take mi md   By TheKrosty#4329")
    end
end)

Citizen.CreateThread(function()
  if GetCurrentResourceName() ~= KrostyBags_ then 
        print("[" .. GetCurrentResourceName() .. "] " .. "K Shop Top")
    end
end)


-- ESX.RegisterCommand('givebag', 'admin', function(source, args)
--   local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
--   TriggerClientEvent('esx:showNotification', source.source, 'Mochila entrgada correctamente, ID: '..args[1])
--   MySQL.Async.execute("INSERT INTO mochilas (identifier, bag) VALUES (@identifier, @bag)" , {
--     ['@identifier'] = xPlayer.identifier,
--     ['@bag'] = tonumber(args[2]),
--   })
-- end)
