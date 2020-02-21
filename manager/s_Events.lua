-------------------- POST MANAGER -------------------- 
addEvent("PostManager_create", true)
addEventHandler("PostManager_create", getRootElement(), 
    function(name, p_porcent, fuel, fuel_max)
        pManager:create(name, p_porcent, fuel, fuel_max)
    end
)

addEvent("PostManager_delete", true)
addEventHandler("PostManager_delete", getRootElement(), 
    function(name)
        pManager:delete(name)
    end
)

addEvent("PostManager_setPostFuel", true)
addEventHandler("PostManager_setPostFuel", getRootElement(), 
    function(id, fuel) pManager:setPostFuel(id, fuel) end
)

addEvent("PostManager_setPostMaxFuel", true)
addEventHandler("PostManager_setPostMaxFuel", getRootElement(), 
    function(id, fuel_max) pManager:setPostMaxFuel(id, fuel_max) end
)

addEvent("PostManager_setPostFuelPrices", true)
addEventHandler("PostManager_setPostFuelPrices", getRootElement(), 
    function(id, aprice, gprice) pManager:setPostFuelPrices(id, aprice, gprice) end
)

addEvent("PostManager_setPostFuelPrice", true)
addEventHandler("PostManager_setPostFuelPrice", getRootElement(), 
    function(id, fuel_id, price) pManager:setPostFuelPrice(id, fuel_id, price) end
)

addEvent("PostManager_setPostPricePorcent", true)
addEventHandler("PostManager_setPostPricePorcent", getRootElement(), 
    function(id, porcent) pManager:setPostPricePorcent(id, porcent) end
)

addEvent("PostManager_setPostPayBox", true)
addEventHandler("PostManager_setPostPayBox", getRootElement(), 
    function(id, location) pManager:setPostPayBox(id, location) end
)

addEvent("PostManager_addAttendant", true)
addEventHandler("PostManager_addAttendant", getRootElement(), 
    function(id, location) pManager:addAttendant(id, location) end
)

addEvent("PostManager_removeAttendant", true)
addEventHandler("PostManager_removeAttendant", getRootElement(), 
    function(id, a_id, location) pManager:removeAttendant(id, a_id, location) end
)

addEvent("PostManager_setAttendant", true)
addEventHandler("PostManager_setAttendant", getRootElement(), 
    function(id, a_id, location) pManager:setAttendant(id, a_id, location) end
)
-------------------- POST MANAGER -------------------- 

-------------------- POST PAYMENT -------------------- 
addEvent("PostManager_pay", true)
addEventHandler("PostManager_pay", getRootElement(), 
    function(id, player, fuel, fuel_type, vehicle)
        pManager:pay(id, player, fuel, fuel_type, vehicle)
    end
)
-------------------- POST PAYMENT -------------------- 

-------------------- POST FUNCTIONS -------------------- 
function onEnterInVehicle()
    createFuelInVehicle(source)
    verifyFuelType(source)
    local type = getElementData(source, "fuel_type")
    local fuel = getElementData(source, type)
    if (fuel <= 0) then
        setVehicleEngineState(source, false)
    end
end
addEventHandler("onVehicleEnter", getRootElement(), onEnterInVehicle)

addEventHandler("onPlayerJoin", getRootElement(), function() bindKeys(source) end )
addEventHandler("onPlayerLogin", getRootElement(), function() bindKeys(source) end )

addEvent("verifyVehicleFuelType", true)
addEventHandler("verifyVehicleFuelType", getRootElement(), verifyFuelType)

addEvent("getPostsClient", true)
function getPostsClient()
    triggerClientEvent(source, "sendPostsClient", source, storage.posts)
end
addEventHandler("getPostsClient", getRootElement(), getPostsClient)