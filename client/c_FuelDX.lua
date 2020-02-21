local petrol_icon = dxCreateTexture("icons/petrol.png")
local payment_icon = dxCreateTexture("icons/payment.png")
local petrol_marker = dxCreateTexture("icons/wait.png")

local vehicle, fuel_type, inteligent, ft, fa, fg, color, occupied
local v, s, show, pshow = 0, false, false, false
local posx, text, progress = 0, "Gasolina", 0

local guis = {
    manager_fuel = {1050, 620},
    manager_post = {170, 60}
}

function draw()
    ------------------------------------- Petrol Post -------------------------------------
    ----------------------------------------------------------------------------------------
    ------------------------------------ Car Fuel Panel ------------------------------------
    occupied = getPedOccupiedVehicleSeat(lp)
    if getPedOccupiedVehicleSeat(lp) == 0 then
        pshow = false
        --------------------------------------- Variables ---------------------------------------
        vehicle = getPedOccupiedVehicle(lp)
        fuel_type, inteligent = getElementData(vehicle, "fuel_type"), getElementData(vehicle, "inteligent") or false
        ft, fa, fg = getElementData(vehicle, "fuel") or 0, getElementData(vehicle, "alcohol") or 0, getElementData(vehicle, "gasoline") or 0
        -----------------------------------------------------------------------------------------
        if getVehicleEngineState(vehicle) == false then
            if smarker and svehicle and not psg then showPaymentGUI(true) end
        else if psg then showPaymentGUI(false) end end
        color = tocolor(80, 80, 80, 150)
        if cursorPosition(x*1250, y*600, x*80, y*80) then color = tocolor(255, 255, 255, 150) end
        dxDrawImage(x*1250, y*600, x*80, y*80, "icons/fueltype.png", 0, 0, 0, color)
        if show then
            dxDrawRectangle(x * guis.manager_fuel[1], y * guis.manager_fuel[2], x * 190, y * 115, tocolor(255, 255, 255, 255), false)
            dxDrawRectangle(x * guis.manager_fuel[1], y * (guis.manager_fuel[2] - 30), x * 190, y * 30, tocolor(28, 29, 226, 255), false)
            --------------------------------------- Change mode ---------------------------------------
            dxDrawRectangle(x * (guis.manager_fuel[1] + 8), y * (guis.manager_fuel[2] + 22), x * 173, y * 30, tocolor(20, 20, 20, 255), false)
            color = {tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 255), tocolor(28, 29, 226, 200)}
            if fuel_type == "gasoline" then
                posx = 0
                color[2] = tocolor(80, 80, 80, 100)
            elseif fuel_type == "alcohol" then
                posx = 86.5
                color[1] = tocolor(80, 80, 80, 100)
            end
            if cursorPosition(x * (guis.manager_fuel[1] + 8 + posx), y * (guis.manager_fuel[2] + 22), x * 86.5, y * 30) and not inteligent then
                color[3] = tocolor(30, 31, 228, 255)
            end
            if inteligent then color[1], color[2], color[3] = tocolor(80, 80, 80, 100), tocolor(80, 80, 80, 100), tocolor(40, 40, 40, 255) end
            dxDrawRectangle(x * (guis.manager_fuel[1] + 8 + posx), y * (guis.manager_fuel[2] + 22), x * 86.5, y * 30, color[3], false)
            dxDrawText("Gasolina", x * (guis.manager_fuel[1] + 16), y * (guis.manager_fuel[2] + 28), x * 0.9385, y * 0.8594, color[1], x*1.5, "default", "left", "top", false, false, false, false, false)
            dxDrawText("Álcool", x * (guis.manager_fuel[1] + 115), y * (guis.manager_fuel[2] + 28), x * 0.9385, y * 0.8594, color[2], x*1.5, "default", "left", "top", false, false, false, false, false)
            -----------------------------------------------------------------------------------------------
            --------------------------------------- Inteligent mode ---------------------------------------
            dxDrawRectangle(x * (guis.manager_fuel[1] + 110), y * (guis.manager_fuel[2] + 57.5), x * 71, y * 14.5, tocolor(20, 20, 20, 255), false)
            color = {tocolor(204, 0, 0, 100), tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 255)}
            if inteligent then posx, color[1], color[3] = 0, tocolor(51, 153, 255, 100), tocolor(80, 80, 80, 100)  else posx, color[2] = 35.5, tocolor(80, 80, 80, 100) end
            if cursorPosition(x * (guis.manager_fuel[1] + 110 + posx), y * (guis.manager_fuel[2] + 57.5), x * 35.5, y * 14.5) then
                if inteligent then
                    color[1] = tocolor(51, 153, 255, 255)
                else color[1] = tocolor(204, 0, 0, 255) end
            end
            dxDrawRectangle(x * (guis.manager_fuel[1] + 110 + posx), y * (guis.manager_fuel[2] + 57.5), x * 35.5, y * 14.5, color[1], false)
            dxDrawText("On", x * (guis.manager_fuel[1] + 120), y * (guis.manager_fuel[2] + 57.5), x * 0.9385, y * 0.8594, color[2], x*1, "default", "left", "top", false, false, false, false, false)
            dxDrawText("Off", x * (guis.manager_fuel[1] + 155.5), y * (guis.manager_fuel[2] + 57.5), x * 0.9385, y * 0.8594, color[3], x*1, "default", "left", "top", false, false, false, false, false)
            -----------------------------------------------------------------------------------------------
            -------------------------------------------- Texts --------------------------------------------
            dxDrawText("Gerenciar combustível", x * (guis.manager_fuel[1] + 5), y * (guis.manager_fuel[2] - 28), 1246, 638, tocolor(255, 255, 255, 255), x*1.50, "default", "left", "top", false, false, false, false, false)
            dxDrawText("Seleção de combustível:", x * (guis.manager_fuel[1] + 10), y * (guis.manager_fuel[2] + 3), x * 0.9385, y * 0.8594, tocolor(0, 0, 0, 255), x*1.1, "default", "left", "top", false, false, false, false, false)
            dxDrawText("Modo inteligente:", x * (guis.manager_fuel[1] + 10), y * (guis.manager_fuel[2] + 56), x * 0.9385, y * 0.8594, tocolor(0, 0, 0, 255), x*1.00, "default", "left", "top", false, false, false, false, false)
            -- Fuel Status --
            dxDrawText("Gasolina:", x * (guis.manager_fuel[1] + 10), y * (guis.manager_fuel[2] + 70), x * 0.9385, y * 0.8594, tocolor(0, 0, 0, 255), x*1.00, "default", "left", "top", false, false, false, false, false)
            progress = ((123/100)*fg)
            color = {((255/130)*fg), (130/255)*fg}
            dxDrawRectangle(x * (guis.manager_fuel[1] + 58), y * (guis.manager_fuel[2] + 73), x * 123, y * 10, tocolor(34, 34, 35, 255), false)
            dxDrawRectangle(x * (guis.manager_fuel[1] + 58), y * (guis.manager_fuel[2] + 73), x * progress, y * 10, tocolor(color[2], color[1], 0, 255), false)

            dxDrawText("Álcool:", x * (guis.manager_fuel[1] + 10), y * (guis.manager_fuel[2] + 84), x * 0.9385, y * 0.8594, tocolor(0, 0, 0, 255), x*1.00, "default", "left", "top", false, false, false, false, false)
            dxDrawRectangle(x * (guis.manager_fuel[1] + 48), y * (guis.manager_fuel[2] + 87), x * 133, y * 10, tocolor(34, 34, 35, 255), false)
            progress = ((133/100)*fa)
            color = {((255/130)*fa), (130/255)*fa}
            dxDrawRectangle(x * (guis.manager_fuel[1] + 48), y * (guis.manager_fuel[2] + 87), x * progress, y * 10, tocolor(color[2], color[1], 0, 255), false)
            
            dxDrawText("Combustível Total:", x * (guis.manager_fuel[1] + 10), y * (guis.manager_fuel[2] + 98), x * 0.9385, y * 0.8594, tocolor(0, 0, 0, 255), x*1.00, "default", "left", "top", false, false, false, false, false)
            dxDrawRectangle(x * (guis.manager_fuel[1] + 113), y * (guis.manager_fuel[2] + 101), x * 68, y * 10, tocolor(34, 34, 35, 255), false)
            progress = ((68/100)*ft)
            color = {((255/130)*ft), (130/255)*ft}
            dxDrawRectangle(x * (guis.manager_fuel[1] + 113), y * (guis.manager_fuel[2] + 101), x * progress, y * 10, tocolor(color[2], color[1], 0, 255), false)
            ----------------
            -----------------------------------------------------------------------------------------------
        end
    end
    -----------------------------------------------------------------------------------------------
end
addEventHandler("onClientPreRender", getRootElement(), draw)

function onClick(botao, state)
    if botao == "left" and state == "down" then
        if vehicle and occupied == 0 then
            if fuel_type == "gasoline" then posx = 86.5 elseif fuel_type == "alcohol" then posx = 0 end
            if cursorPosition(x*1250, y*600, x*80, y*80) then
                show = not show
            elseif cursorPosition(x * (guis.manager_fuel[1] + 8 + posx), y * (guis.manager_fuel[2] + 22), x * 86.5, y * 30) and not inteligent then
                if fuel_type == "gasoline" and fa > 0 then
                    fuel_type = "alcohol"
                elseif fuel_type == "alcohol" and fg > 0 then
                    fuel_type = "gasoline"
                end
                setElementData(vehicle, "fuel_type", fuel_type)
                triggerServerEvent("verifyVehicleFuelType", vehicle, vehicle)
            else
                if inteligent then posx = 35.5 else posx = 0 end
                if cursorPosition(x * (guis.manager_fuel[1] + 110 + posx), y * (guis.manager_fuel[2] + 57.5), x * 35.5, y * 14.5) then
                    setElementData(vehicle, "inteligent", not inteligent)
                    if not inteligent then
                        if fa > 0 then fuel_type = "alcohol" elseif fg > 0 then fuel_type = "gasoline" end
                        setElementData(vehicle, "fuel_type", fuel_type)
                    end
                    triggerServerEvent("verifyVehicleFuelType", vehicle, vehicle)
                end
            end
        end
    end
end
addEventHandler("onClientClick", getRootElement(), onClick)

function drawMarkers()
    v, s = reposition(v, 0, 0.3, 0.018, s)
    for name, data in pairs(mL) do
        local md = mL[name]
        if md then
            local paybox = md.box
            if paybox then
                drawCircle(paybox, 200, 0, petrol_marker)
                drawCircle(paybox, 200, -0.5, petrol_marker)
                dxDrawImageOnElement(paybox, payment_icon, 200, 1, 1, 255, 255, 255, 150, 0, 0 , (v/2))
                dxDrawTextOnElement(paybox, "Pague Aqui", 1.1 + (v/2), 30, 255, 255, 255, 255, x*1.5)
            end
            local attendants = md.attendants
            if attendants then
                for id, marker in ipairs(attendants) do
                    drawCircle(marker, 200, 0, petrol_marker)
                    drawCircle(marker, 200, -0.5, petrol_marker)
                    dxDrawImageOnElement(marker, petrol_icon, 20, 1.2, 1, 255, 255, 255, 150, 0, 0 , v)
                    if DGS:dgsGetVisible(dgs_guis.post) then
                        dxDrawTextOnElement(marker, getElementData(marker, "Post"), 2.4 + v, 1000, 255, 255, 255, 255, x*2)
                    end
                end
            end
        end
    end
end
addEventHandler ( "onClientRender", getRootElement(), drawMarkers )