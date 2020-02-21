warnCars = {}
function countFuel()
    vehicles = getElementsByType("vehicle")
    for id, vehicle in ipairs(vehicles) do
        if not (getVehicleType(vehicle) == "BMX") and getVehicleEngineState(vehicle) then
            if createFuelInVehicle(vehicle) == false then
                local type = getElementData(vehicle, "fuel_type")
                local total, fuel = getElementData(vehicle, type), getElementData(vehicle, "fuel")
                local inteligent = getElementData(vehicle, "inteligent")
                if total and fuel and (total > 0 and fuel > 0) then
                    local count = fuel_types[fuel_id[type]].count
                    local rvhfuel = fuel - count
                    local tvhfuel = total - count
                    if rvhfuel < 0 then rvhfuel = 0 end
                    if tvhfuel < 0 then tvhfuel = 0 end
                    setElementData(vehicle, "fuel", rvhfuel)
                    setElementData(vehicle, type, tvhfuel)
                    if fuel < 35 then
                        player = getVehicleOccupant(vehicle, 0)
                        if player and not warnCars[vehicle] then
                            warnCars[vehicle] = true
                            sendPlayerMessage(player, "Seu combustível está baixo, vá até um posto abastecer rapidamente", "info")
                        end
                    end
                    if inteligent then
                        local fa = getElementData(vehicle, "alcohol") or 0
                        if type == "gasoline" and fa > 0 then 
                            setElementData(vehicle, "fuel_type", "alcohol")
                            verifyFuelType(vehicle)
                        end
                    end
                else
                    if inteligent then
                        local fuel, alcohol, gasoline = getElementData(vehicle, "fuel"), getElementData(vehicle, "alcohol"), getElementData(vehicle, "gasoline")
                        if alcohol > 0 then 
                            setElementData(vehicle, "fuel_type", "alcohol")
                            verifyFuelType(vehicle)
                        elseif gasoline > 0 then 
                            setElementData(vehicle, "fuel_type", "gasoline")
                            verifyFuelType(vehicle)
                        else
                            setVehicleEngineState(vehicle, false)
                        end
                    else setVehicleEngineState(vehicle, false) end
                end
            end
        end
    end
end
setTimer(countFuel, 1000, 0)

function createFuelInVehicle(vehicle)
    local fuel, alcohol, gasoline = getElementData(vehicle, "fuel"), getElementData(vehicle, "alcohol"), getElementData(vehicle, "gasoline")
    if not (fuel and (alcohol or gasoline)) and not (getVehicleType(vehicle) == "BMX") then
        local type = fuel_types[math.random( 1, 2)].type
        local value = math.random(0, 100)
        setElementData(vehicle, type, value)
        setElementData(vehicle, "fuel_type", type) 
        setElementData(vehicle, "fuel", value)
        return true
    end
    return false
end

function verifyFuelType(vehicle)
    local sm = getElementData(vehicle, "speeds")
    if not sm then 
        sm = getVehicleHandlingProperty(vehicle, "engineAcceleration")
        setElementData(vehicle, "speeds", sm)
    end
    local fuel_type = getElementData(vehicle, "fuel_type")
    if fuel_type == "alcohol" then sm = sm/2 elseif fuel_type == "gasoline" then  sm = sm end
    setVehicleHandling(vehicle, "engineAcceleration", sm)
end

-------------------------------- POST LOAD/SAVE -------------------------------- 
function savePost(name, mode)
    local post = storage.posts[name]
    if mode and post then
        local data = false
        if mode == "data" then
            data = serializeTable(
                {
                    id = post.id,
                    post_fuel = post.post_fuel,
                    post_maxfuel = post.post_maxfuel,
                    porcent = post.porcent,
                }
            )
        elseif mode == "prices" then
            data = serializeTable(post.prices)
        elseif mode == "paybox" then
            data = serializeTable(post.box_pay)
        elseif mode == "attendants" then
            local locations  = ""
            for i, d in pairs(post.fuel_locations) do
                locations = locations..serializeTable(d).."|"
            end
            data = ""..locations:sub(1, #locations -1)
        end
        Sql:query("UPDATE Posts SET "..mode.." = '"..data.."' WHERE name = '"..name.."'")
    end
end

function loadPosts()
    local table = Sql:query("SELECT * FROM Posts")
    if table then
        for id, row in ipairs (table) do
            local name = row["name"]
            if name then
                local data = unserializeTable(row["data"])
                local prices = unserializeTable(row["prices"])
                local paybox = row["paybox"]
                if paybox ~= "false" then paybox = unserializeTable(row["paybox"]) else paybox = false end
                local attendants = row["attendants"]
                if attendants ~= "false" then
                    local s = attendants
                    attendants = {}
                    if not string.match(s, "|") then
                        attendants = {unserializeTable(s)}
                    else
                        local values = split(s, "|")
                        for id, result in pairs(values) do
                            attendants[id] = unserializeTable(result)
                        end
                    end
                else
                    attendants = {}
                end
                data.prices = prices
                data.box_pay = paybox
                data.fuel_locations = attendants
                storage.posts[name] = data
            end
        end
    end
end
-------------------------------- POST LOAD/SAVE -------------------------------- 