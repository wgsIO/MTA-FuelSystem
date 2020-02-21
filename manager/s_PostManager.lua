local PostManager = class(function() end)
pManager = PostManager()

function PostManager:create(name, p_porcent, fuel, fuel_max)
    local post = {
        id = self:getLastIndex(),
        post_fuel = fuel,
        post_maxfuel = fuel_max,
        prices = {fuel_types[2].cust, fuel_types[1].cust},
                --A  G > A = Alcohol, G > Gasoline
        porcent = p_porcent,
        box_pay = false, -- {0, 0, 0, 0, 0}
                     --     X  Y  Z RX RY
        fuel_locations =  {
            --[1] = {1, 0, 0, 0, 0, 0}
            --     ID X  Y  Z RX RY
        },
    }
    local p_name, t = name, 1
    while storage.posts[p_name] do
        p_name = name.."("..t..")"
        t = t + 1
    end
    local pds = {
        id = post.id,
        post_fuel = post.post_fuel,
        post_maxfuel = post.post_maxfuel,
        porcent = post.porcent,
    }
    Sql:query("INSERT INTO Posts VALUES ('"..p_name.."', '"..serializeTable(pds).."', '"..serializeTable(post.prices).."', 'false', 'false')")
    storage.posts[p_name] = post
    getPostsClient()
end

function PostManager:delete(name)
    storage.posts[name] = nil
    Sql:query("DELETE FROM Posts WHERE name = '"..name.."'")
    getPostsClient()
end

function PostManager:getLastIndex()
    local index = 1
    for id, data in pairs(storage.posts) do
        while (data.id >= index) do
            index = index + 1
        end
    end
    return index
end

function PostManager:getPostById(id)
    local post, name = false, false
    if id and type(id) == "number" then
        for n, d in pairs(storage.posts) do
            if d.id == id then
                post, name = d, n
                break
            end
        end 
    end
    return post, name
end

function PostManager:getPostName(id)
    local post, name = self:getPostById(id)
    return name
end

function PostManager:getPost(name)
    if name and type(name) == "string" then
        return storage.posts[name]
    end
end

function PostManager:setPostFuel(id, fuel)
    local pname = self:getPostName(id)
    storage.posts[pname].post_fuel = fuel
    savePost(pname, "data")
    getPostsClient()
end

function PostManager:setPostMaxFuel(id, fuel_max)
    local pname = self:getPostName(id)
    storage.posts[pname].post_maxfuel = fuel_max
    savePost(pname, "data")
    getPostsClient()
end

function PostManager:setPostFuelPrices(id, aprice, gprice)
    local pname = self:getPostName(id)
    storage.posts[pname].prices = {aprice, gprice}
    savePost(pname, "prices")
    getPostsClient()
end

function PostManager:setPostFuelPrice(id, fuel_id, price)
    local pname = self:getPostName(id)
    storage.posts[pname].prices[fuel_id] = price
    savePost(pname, "data")
    getPostsClient()
end

function PostManager:setPostPricePorcent(id, porcent)
    local pname = self:getPostName(id)
    storage.posts[pname].porcent = porcent
    savePost(pname, "data")
    getPostsClient()
end

function PostManager:setPostPayBox(id, location)
    local pname = self:getPostName(id)
    storage.posts[pname].box_pay = location
    savePost(pname, "paybox")
    getPostsClient()
    triggerClientEvent(source, "updatePostClient", source, pname, 0, location, false, 0)
end

function PostManager:addAttendant(id, location)
    local lid = self:getAttendantLastIndex(id)
    local pname = self:getPostName(id)
    storage.posts[pname].fuel_locations[lid] = location
    savePost(pname, "attendants")
    getPostsClient()
    triggerClientEvent(source, "updatePostClient", source, pname, lid, location, false, 1)
end

function PostManager:removeAttendant(name, a_id)
    storage.posts[name].fuel_locations[a_id] = nil

    savePost(name, "attendants")
    getPostsClient()
    triggerClientEvent(source, "updatePostClient", source, name, a_id, false, true, 1)
end

function PostManager:setAttendant(name, a_id, location)
    storage.posts[name].fuel_locations[self:getAttendantLastIndex(a_id)] = location
    savePost(name, "attendants")
    getPostsClient()
end

function PostManager:getAttendantLastIndex(id)
    local index = 1
    if id then
        for id, data in pairs(storage.posts[self:getPostName(id)].fuel_locations) do
            while (id >= index) do
                index = index + 1
            end
        end
    end
    return index
end

-- PAYMENT --

function PostManager:pay(id, player, fuel, fuel_type, vehicle)
    if player and fuel >= 1 and vehicle and id and type(id) == "number" and (fuel_type == fuel_types[1].type or fuel_type == fuel_types[2].type) then
        local vf = getElementData(vehicle, "fuel") or 0
        local post, name = self:getPostById(id)
        local pf = post.post_fuel
        if vf <= 99 then 
            if ((vf + fuel) <= 100) then
                if fuel > pf then fuel = pf end
                local sp = 2
                if fuel_type == "alcohol" then sp = 1 end
                local price = post.prices[sp]*fuel--(((post.prices[fuel_type]*post.porcent)/100)*fuel)
                if playerHasMoney(player, price) then
                    if cust_post_fuel then
                        storage.posts[name].post_fuel = pf - fuel
                    end
                    removePlayerMoney(player, price)
                    setElementData(vehicle, fuel_type, (getElementData(vehicle, fuel_type) or 0) + fuel)
                    setElementData(vehicle, "fuel", (vf + fuel))
                    local rs = "gasolina"
                    if fuel_type == "alcohol" then rs = "álcool" end
                    warnCars[vehicle] = false
                    sendPlayerMessage(player, "Você comprou "..fuel.."mL de "..rs..", dando ao total "..price.."$", "success")
                    getPostsClient()
                    return 4 -- Sucess
                else
                    sendPlayerMessage(player, "Você não tem dinheiro suficiente, necessita:  "..price.."$.", "error")
                    return 3 -- Dont have money
                end
            else
                sendPlayerMessage(player, "Não há espaço para esta quantia de combustível.", "error")
                return 2 -- Not space at fuel
            end
        else
            sendPlayerMessage(player, "Seu veículo está com combustível totalmente cheio.", "error")
            return 1 -- Fuel full
        end
    else
        sendPlayerMessage(player, "Ocorreu um erro ao executar esta ação.", "error")
    end
    return 0 -- Not have data
end