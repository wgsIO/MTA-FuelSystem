DGS = exports.dgs

dgs_guis = {
    post = DGS:dgsCreateWindow ( 0.15, 0.1, 0.25, 0.8, "Gerenciamento De Postos", true),
    postbox = DGS:dgsCreateWindow ( 0.3, 0.1, 0.25, 0.2, "Comprar Combustível", true)
}
dgs_itens = {}
dgs_columns = {}

local sbox = "N/A" 
local sboxid = 0

smarker = nil
svehicle = nil

local fselected = "N/A"

function notClose()
    cancelEvent()
    if (source == dgs_guis.postbox) then
        showPaymentGUI(false)
        svehicle = nil
    end
end
    
function loadGUI()
    addEventHandler("onDgsWindowClose", dgs_guis.post, notClose)
    addEventHandler("onDgsWindowClose", dgs_guis.postbox, notClose)
    --Loading elemnts at GUI
    --ft, fa, fg = getElementData(vehicle, "fuel") or 0, getElementData(vehicle, "alcohol") or 0, getElementData(vehicle, "gasoline") or 0
    dgs_itens.postbox = {
        texts = {
            DGS:dgsCreateLabel(0.004, 0.018 ,0.94, 0.2, "Escolha um tipo de combustível", true, dgs_guis.postbox, tocolor(255, 255, 255, 230), 1.2, 1.2),
            DGS:dgsCreateLabel(0.6, 0.3 ,0.94, 0.2, "Combustível: 100%", true, dgs_guis.postbox, tocolor(255, 255, 255, 230), 1.2, 1.2),
            DGS:dgsCreateLabel(0.6, 0.4 ,0.94, 0.2, "* Álcool: 50%", true, dgs_guis.postbox, tocolor(255, 255, 255, 230), 1.2, 1.2),
            DGS:dgsCreateLabel(0.6, 0.5 ,0.94, 0.2, "* Gasolina: 50%", true, dgs_guis.postbox, tocolor(255, 255, 255, 230), 1.2, 1.2),
            DGS:dgsCreateLabel(0.004, 0.33 ,0.94, 0.2, "Quantidade: ", true, dgs_guis.postbox, tocolor(255, 255, 255, 230), 1.2, 1.2),
        },
        buttons = {
            ["alcohol"] = DGS:dgsCreateButton( 0.005, 0.15, 0.335, 0.2, "Álcool", true, dgs_guis.postbox),
            ["gasoline"] = DGS:dgsCreateButton(0.345, 0.15, 0.335, 0.2, "Gasolina", true, dgs_guis.postbox),
            ["confirm"] = DGS:dgsCreateButton( 0.005, 0.5, 0.585, 0.3, "Comprar combustível", true, dgs_guis.postbox),
        },
        editboxs = {
            DGS:dgsCreateEdit( 0.25, 0.33, 0.34, 0.15, "Quantidade", true, dgs_guis.postbox),
        }
    }
    dgs_itens.post = {
        texts = {
            DGS:dgsCreateLabel(0.002, 0.018 ,0.94, 0.2,"Gerenciar Postos", true, dgs_guis.post, tocolor(255, 255, 255, 230), 1.3, 1.3),
            DGS:dgsCreateLabel(0.015, 0.45 ,0.94, 0.2,"Trabalhadores", true, dgs_guis.post, tocolor(255, 255, 255, 230), 1.3, 1.3),
            DGS:dgsCreateLabel(0.002, 0.765 ,0.94, 0.2,"Waiting...", true, dgs_guis.post, tocolor(255, 255, 255, 230), 1.3, 1.3)
        },
        buttons = {
            ["create"] = DGS:dgsCreateButton( 0.005, 0.05, 0.335, 0.08, "Criar Posto", true, dgs_guis.post),
            ["delete"] = DGS:dgsCreateButton( 0.005, 0.13, 0.335, 0.08, "Deletar Posto", true, dgs_guis.post),
            ["reset"] = DGS:dgsCreateButton( 0.005, 0.21, 0.335, 0.08, "Resetar Posto", true, dgs_guis.post),
            ["prices"] = DGS:dgsCreateButton( 0.005, 0.29, 0.335, 0.08, "Definir Preços", true, dgs_guis.post),
            ["fuel"] = DGS:dgsCreateButton( 0.005, 0.37, 0.335, 0.08, "Definir Combustível", true, dgs_guis.post),
            ["addmarker"] = DGS:dgsCreateButton( 0.005, 0.485, 0.335, 0.08, "Adicionar Frentista", true, dgs_guis.post),
            ["addboxmarker2"] = DGS:dgsCreateButton( 0.005, 0.565, 0.335, 0.08, "SC [Desativado]", true, dgs_guis.post),
            --addboxmarker^                                                      Setar Caixa ^
            ["removemarker"] = DGS:dgsCreateButton( 0.005, 0.645, 0.335, 0.08, "Remover", true, dgs_guis.post),
            ["confirm"] = DGS:dgsCreateButton( 0.005, 0.86, 0.985, 0.08, "Confirmar", true, dgs_guis.post),
        },
        lists = {
            [1] = DGS:dgsCreateGridList(0.34, 0.08, 0.65, 0.6, true, dgs_guis.post, 20, 
            tocolor(10, 10, 10, 200), tocolor(255, 255, 255, 200), 
            tocolor(60, 60, 60, 200), tocolor(100, 100, 100, 200),
            tocolor(150, 150, 150, 200), tocolor(53, 127, 233, 200))
        },
        editboxs = {
            DGS:dgsCreateEdit( 0.005, 0.8, 0.5, 0.06, "Waiting...", true, dgs_guis.post),
            DGS:dgsCreateEdit( 0.51, 0.8, 0.48, 0.06, "Waiting...", true, dgs_guis.post)
        }
    }
    --Create list columns
    dgs_columns.post = {
        DGS:dgsGridListAddColumn(dgs_itens.post.lists[1], "ID", 0.085 ),
        DGS:dgsGridListAddColumn(dgs_itens.post.lists[1], "Nome", 0.25 ),
        DGS:dgsGridListAddColumn(dgs_itens.post.lists[1], "A/G p", 0.25 ),
        DGS:dgsGridListAddColumn(dgs_itens.post.lists[1], "Combustivel", 0.3 )
    }
    --Loading Events
    addEventHandler( "onDgsMouseClick", dgs_itens.post.buttons["create"], dgsClick)
    addEventHandler( "onDgsMouseClick", dgs_itens.post.buttons["delete"], dgsClick)
    addEventHandler( "onDgsMouseClick", dgs_itens.post.buttons["reset"], dgsClick)
    addEventHandler( "onDgsMouseClick", dgs_itens.post.buttons["prices"], dgsClick)
    addEventHandler( "onDgsMouseClick", dgs_itens.post.buttons["fuel"], dgsClick)
    addEventHandler( "onDgsMouseClick", dgs_itens.post.buttons["addmarker"], dgsClick)
    --addEventHandler( "onDgsMouseClick", dgs_itens.post.buttons["addboxmarker"], dgsClick)
    addEventHandler( "onDgsMouseClick", dgs_itens.post.buttons["removemarker"], dgsClick)
    addEventHandler( "onDgsMouseClick", dgs_itens.post.buttons["confirm"], dgsClick)

    addEventHandler( "onDgsMouseClick", dgs_itens.postbox.buttons["alcohol"], dgsClick)
    addEventHandler( "onDgsMouseClick", dgs_itens.postbox.buttons["gasoline"], dgsClick)
    addEventHandler( "onDgsMouseClick", dgs_itens.postbox.buttons["confirm"], dgsClick)
end



addEvent("showGUI", true)
function showGUI(show)
    DGS:dgsSetVisible(dgs_guis.post, show)
    showCursor(show)
    if show then
        sbox = "N/A"
        sboxid = 0
        DGS:dgsSetVisible(dgs_itens.post.buttons["confirm"], false)
        DGS:dgsSetVisible(dgs_itens.post.editboxs[1], false)
        DGS:dgsSetVisible(dgs_itens.post.editboxs[2], false)
        DGS:dgsSetVisible(dgs_itens.post.texts[3], false)
        triggerServerEvent("getPostsClient", lp)
    end
end
addEventHandler("showGUI", getRootElement(), showGUI)

local psg = false
function showPaymentGUI(show)
    psg = show
    DGS:dgsSetVisible(dgs_guis.postbox, show)
    showCursor(show)
end



function dgsClick(button, state)
    if button == "left" and state == "down" then
        if source == dgs_itens.post.buttons["create"] then
            pManager:create("Posto", 100, 1000, 2000)
            msgdx:addNotification("Posto criado com sucesso.", "success")
        elseif source == dgs_itens.post.buttons["delete"] then
            local row = DGS:dgsGridListGetSelectedItem(dgs_itens.post.lists[1])
            if row ~= -1 then
                local name = DGS:dgsGridListGetItemText(dgs_itens.post.lists[1], row, dgs_columns.post[2])
                local id = DGS:dgsGridListGetItemText(dgs_itens.post.lists[1], row, dgs_columns.post[1])
                if mL[name] then
                    if mL[name].attendants then
                        for id, marker in pairs(mL[name].attendants) do
                            destroyElement(marker)
                        end
                    end
                    local marker = mL[name].box
                    if marker then
                        destroyElement(marker)
                    end
                    mL[name].attendants = nil
                    mL[name].box = nil
                end
                pManager:delete(name)
                msgdx:addNotification("Posto '"..name.."' foi deletado com sucesso.", "success")
            else
                msgdx:addNotification("Selecione um posto à deletar.", "error")
            end
        elseif source == dgs_itens.post.buttons["prices"] then
            local row = DGS:dgsGridListGetSelectedItem(dgs_itens.post.lists[1])
            if row ~= -1 then
                local name = DGS:dgsGridListGetItemText(dgs_itens.post.lists[1], row, dgs_columns.post[2])
                sboxid = tonumber(DGS:dgsGridListGetItemText(dgs_itens.post.lists[1], row, dgs_columns.post[1])) or 0
                if sboxid > 0 then
                    sbox = "prices"
                    DGS:dgsSetText(dgs_itens.post.texts[3], "Preços:  Àlcool            | Gasolina")
                    DGS:dgsSetText(dgs_itens.post.editboxs[1], ""..postsL[name].prices[1])
                    DGS:dgsSetText(dgs_itens.post.editboxs[2], ""..postsL[name].prices[2])
                    DGS:dgsSetVisible(dgs_itens.post.buttons["confirm"], true)
                    DGS:dgsSetVisible(dgs_itens.post.editboxs[1], true)
                    DGS:dgsSetVisible(dgs_itens.post.editboxs[2], true)
                    DGS:dgsSetVisible(dgs_itens.post.texts[3], true)
                end
            else
                msgdx:addNotification("Selecione um posto à alterar os preços.", "error")
            end
        elseif source == dgs_itens.post.buttons["fuel"] then
            local row = DGS:dgsGridListGetSelectedItem(dgs_itens.post.lists[1])
            if row ~= -1 then
                local name = DGS:dgsGridListGetItemText(dgs_itens.post.lists[1], row, dgs_columns.post[2])
                sboxid = tonumber(DGS:dgsGridListGetItemText(dgs_itens.post.lists[1], row, dgs_columns.post[1])) or 0
                if sboxid > 0 then
                    sbox = "fuel"
                    DGS:dgsSetText(dgs_itens.post.texts[3], "Combustível:  Atual      | Maximo")
                    DGS:dgsSetText(dgs_itens.post.editboxs[1], ""..postsL[name].post_fuel)
                    DGS:dgsSetText(dgs_itens.post.editboxs[2], ""..postsL[name].post_maxfuel)
                    DGS:dgsSetVisible(dgs_itens.post.buttons["confirm"], true)
                    DGS:dgsSetVisible(dgs_itens.post.editboxs[1], true)
                    DGS:dgsSetVisible(dgs_itens.post.editboxs[2], true)
                    DGS:dgsSetVisible(dgs_itens.post.texts[3], true)
                end
            else
                msgdx:addNotification("Selecione um posto à alterar o total de combustível.", "error")
            end
        elseif source == dgs_itens.post.buttons["confirm"] then
            local v1 = tonumber(DGS:dgsGetText(dgs_itens.post.editboxs[1])) or 0
            local v2 = tonumber(DGS:dgsGetText(dgs_itens.post.editboxs[2])) or 0
            if v1 and v2 and v1 > 0 and v2 > 0 then
                local sxdb = ""
                if ((sboxid- 1) > 0) then sxdb = "("..(sboxid- 1)..")" end
                if sbox == "prices" then
                    pManager:setPostFuelPrices(sboxid, v1, v2)
                    msgdx:addNotification("Preços do posto 'Posto"..sxdb.."' foi alterado com sucesso.", "success")
                elseif sbox == "fuel" then
                    pManager:setPostFuel(sboxid, v1)
                    pManager:setPostMaxFuel(sboxid, v2)
                    msgdx:addNotification("Combustíveis do posto 'Posto"..sxdb.."' foi alterado com sucesso.", "success")
                end
                sbox = "N/A"
                sboxid = 0
                DGS:dgsSetVisible(dgs_itens.post.buttons["confirm"], false)
                DGS:dgsSetVisible(dgs_itens.post.editboxs[1], false)
                DGS:dgsSetVisible(dgs_itens.post.editboxs[2], false)
                DGS:dgsSetVisible(dgs_itens.post.texts[3], false)
            else
                msgdx:addNotification("Valor inserido é invalido.", "error")
            end

        elseif source == dgs_itens.post.buttons["addmarker"] then
            local row = DGS:dgsGridListGetSelectedItem(dgs_itens.post.lists[1])
            if row ~= -1 then
                sboxid = tonumber(DGS:dgsGridListGetItemText(dgs_itens.post.lists[1], row, dgs_columns.post[1])) or 0
                if sboxid > 0 then
                    local x,y,z = getElementPosition(lp)
                    local rx, ry, rz = getElementRotation(lp)
                    pManager:addAttendant(sboxid, {x, y, z, rx, ry, rz})
                    msgdx:addNotification("Frentista adicionado.", "success")
                end
            else
                msgdx:addNotification("Selecione o posto à adicionar frentista.", "error")
            end
        elseif source == dgs_itens.post.buttons["addboxmarker"] then
            local row = DGS:dgsGridListGetSelectedItem(dgs_itens.post.lists[1])
            if row ~= -1 then
                sboxid = tonumber(DGS:dgsGridListGetItemText(dgs_itens.post.lists[1], row, dgs_columns.post[1])) or 0
                if sboxid > 0 then
                    local x,y,z = getElementPosition(lp)
                    local rx, ry, rz = getElementRotation(lp)
                    pManager:setPostPayBox(sboxid, {x, y, z, rx, ry, rz})
                    msgdx:addNotification("Caixa definido.", "success")
                end
            else
                msgdx:addNotification("Selecione o posto à definir o caixa.", "error")
            end
        elseif source == dgs_itens.post.buttons["removemarker"] then
            local marker = smarker
            if marker then
                local type = getElementData(marker, "pType") 
                if (type and type == 1) then
                    local post = getElementData(marker, "Post")
                    pManager:removeAttendant(post, getElementData(marker, "ID"))
                    msgdx:addNotification("Frentista removido com sucesso do posto '"..post.."'.", "success")
                end
            end
        elseif source == dgs_itens.postbox.buttons["alcohol"] then
            fselected = "alcohol"
            msgdx:addNotification("Selecionado 'Álcool'.", "info")
        elseif source == dgs_itens.postbox.buttons["gasoline"] then
            fselected = "gasoline"
            msgdx:addNotification("Selecionado 'Gasolina'.", "info")
        elseif source == dgs_itens.postbox.buttons["confirm"] then
            local value = tonumber(DGS:dgsGetText(dgs_itens.postbox.editboxs[1])) or 0
            if value > 0 then
                --if smarker and svehicle then
                    local name = getElementData(smarker, "Post")
                    if name then
                        local post = postsL[name]
                        if post then
                            pManager:pay(post.id, lp, value, fselected, svehicle)
                        else
                            sgdx:addNotification("Este frentista não é de nenhum posto.", "error")
                        end
                    else
                        sgdx:addNotification("Isto não é um frentista.", "error")
                    end
                --end
            else
                msgdx:addNotification("Valor inserido é invalido.", "error")
            end
        end
    end
end

loadGUI()
showGUI(false)
showPaymentGUI(false)



