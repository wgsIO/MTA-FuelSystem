local PostManager = class(function() end)
pManager = PostManager()

function PostManager:create(name, p_porcent, fuel, fuel_max)
    triggerServerEvent("PostManager_create", lp, name, p_porcent, fuel, fuel_max)
end

function PostManager:delete(name)
    triggerServerEvent("PostManager_delete", lp, name)
end

function PostManager:pay(id, player, fuel, fuel_type, vehicle)
    triggerServerEvent("PostManager_pay", lp, id, player, fuel, fuel_type, vehicle)
end

function PostManager:setPostFuel(id, fuel)
    triggerServerEvent("PostManager_setPostFuel", lp, id, fuel)
end

function PostManager:setPostMaxFuel(id, fuel_max)
    triggerServerEvent("PostManager_setPostMaxFuel", lp, id, fuel_max)
end

function PostManager:setPostFuelPrices(id, aprice, gprice)
    triggerServerEvent("PostManager_setPostFuelPrices", lp, id, aprice, gprice)
end

function PostManager:setPostFuelPrice(id, fuel_id, price)
    triggerServerEvent("PostManager_setPostFuelPrice", lp, id, fuel_id, price)
end

function PostManager:setPostPricePorcent(id, porcent)
    triggerServerEvent("PostManager_setPostPricePorcent", lp, id, porcent)
end

function PostManager:setPostPayBox(id, location)
    triggerServerEvent("PostManager_setPostPayBox", lp, id, location)
end

function PostManager:addAttendant(id, location)
    triggerServerEvent("PostManager_addAttendant", lp, id, location)
end

function PostManager:removeAttendant(name, a_id)
    triggerServerEvent("PostManager_removeAttendant", lp, name, a_id)
end

function PostManager:setAttendant(name, a_id, location)
    triggerServerEvent("PostManager_setAttendant", lp, name, a_id, location)
end
