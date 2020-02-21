ScreenW, ScreenH = guiGetScreenSize()
x, y  = ScreenW/1336, ScreenH /768
lp = getLocalPlayer()

msgdx = exports.msgdx
postsL = {}
mL = {}

addEvent("sendPostsClient", true)
function getPostsClient(data)
    postsL = data
    DGS:dgsGridListClear(dgs_itens.post.lists[1])
    for name, pdata in pairs(postsL) do
        local row = DGS:dgsGridListAddRow(dgs_itens.post.lists[1])
        DGS:dgsGridListSetItemText(dgs_itens.post.lists[1], row, dgs_columns.post[1], pdata.id)
        DGS:dgsGridListSetItemText(dgs_itens.post.lists[1], row, dgs_columns.post[2], name)
        DGS:dgsGridListSetItemText(dgs_itens.post.lists[1], row, dgs_columns.post[3], pdata.prices[1].."|"..pdata.prices[2])
        DGS:dgsGridListSetItemText(dgs_itens.post.lists[1], row, dgs_columns.post[4], pdata.post_fuel.." ["..((100/pdata.post_maxfuel)*pdata.post_fuel).."%]")
        if pdata.box_pay then
            updatePostClient(name, 0, pdata.box_pay, false, 0)
        end
        for i, d in pairs(pdata.fuel_locations) do
            updatePostClient(name, i, pdata.fuel_locations[i], false, 1)
        end
    end
end
addEventHandler("sendPostsClient", getRootElement(), getPostsClient)

addEvent("updatePostClient", true)
function updatePostClient(name, id, location, deleting, type)
    local post = postsL[name]
    if not mL[name] then mL[name] = {} end
    if not deleting then
        local marker = createMarker(location[1], location[2], location[3]-1, "cylinder", 2.5, 24, 90, 177, 0)
        if type == 1 then
            if not mL[name].attendants then mL[name].attendants = {} end
            local m = mL[name].attendants[id]
            if m then
                destroyElement(m)
            end
            mL[name].attendants[id] = marker
            setElementData(marker, "pType", 1)
        else
            local m = mL[name].box
            if m then
                destroyElement(m)
            end
            mL[name].box = marker
            setElementData(marker, "pType", 0)
        end
        setElementData(marker, "Post", name)
        setElementData(marker, "ID", id)
    else
        if type == 1 then
            local m = mL[name].attendants[id]
            if m then
                smarker = nil
                destroyElement(m)
                mL[name].attendants[id] = nil
            end
        end
    end
end
addEventHandler("updatePostClient", getRootElement(), updatePostClient)

function jM ( hitPlayer, matchingDimension )
    if hitPlayer == lp then
        smarker = source
        local vh = getPedOccupiedVehicle(hitPlayer)
        if vh then
            if smarker then
                local v = getElementData(smarker, "pType")
                if v and v == 1 then
                    svehicle = vh
                    msgdx:addNotification("Olá "..getPlayerName(lp).." desligue seu veículo para abastecer.", "info")
                end
            end
        end

    end
end
addEventHandler( "onClientMarkerHit", getRootElement(), jM)

function lM ( hitPlayer, matchingDimension )
    if hitPlayer == lp then
        smarker = nil
    end
    if getElementType(hitPlayer) == "vehicle" then
        if hitPlayer == svehicle then 
            svehicle = nil
        end
    end
end
addEventHandler( "onClientMarkerLeave", getRootElement(), lM)