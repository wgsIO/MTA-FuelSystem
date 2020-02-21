function dxDrawImageOnElement(TheElement,Image,distance,height,width,R,G,B,alpha, ax, ay, az)
	local x, y, z = getElementPosition(TheElement)
    local x2, y2, z2 = getElementPosition(localPlayer)
    local ax2, ay2, az2 = ax or 0, ay or 0, az or 0
	local distance = distance or 20
	local height = height or 1
	local width = width or 1
	local checkBuildings = checkBuildings or true
	local checkVehicles = checkVehicles or false
	local checkPeds = checkPeds or false
	local checkObjects = checkObjects or true
	local checkDummies = checkDummies or true
	local seeThroughStuff = seeThroughStuff or false
	local ignoreSomeObjectsForCamera = ignoreSomeObjectsForCamera or false
	local ignoredElement = ignoredElement or nil
	if (isLineOfSightClear(x, y, z, x2, y2, z2, checkBuildings, checkVehicles, checkPeds , checkObjects,checkDummies,seeThroughStuff,ignoreSomeObjectsForCamera,ignoredElement)) then
		local sx, sy = getScreenFromWorldPosition(x, y, z+height)
		if(sx) and (sy) then
			local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			if(distanceBetweenPoints < distance) then
				dxDrawMaterialLine3D(x+ax2, y+ay2, z+az2+1+height-(distanceBetweenPoints/distance), x+ax2, y+ay2, z+az2+height, Image, width-(distanceBetweenPoints/distance), tocolor(R or 255, G or 255, B or 255, alpha or 255))
			end
		end
	end
end

local tick = getTickCount()
function drawCircle(element, distance, resize, texture)
    local iB1, iB2, iB3 = interpolateBetween(1.21, 1.2, 2.5, 1.22, 1.3, 2.6, ((getTickCount() - tick) / 1500), "SineCurve")
    local cx, cy, cz = getCameraMatrix()
    local x, y, z = getElementPosition(element)
    local x2, y2, z2 = getElementPosition(lp)
    local dist = distance or 20
    local dbp = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
    local h = resize or 0
    if(dbp < dist) then
        if isLineOfSightClear(cx, cy, cz, x, y, z, false, false, true, true, false, false, false, lp) then
            dxDrawMaterialLine3D (x + (h / 2),  y - iB1 - (h / 2),  z + 0.03, x - (h / 2), y + iB2 + (h / 2), z +0.03, texture, iB3 + h, tocolor(255,255,255,255), 0, 0, -1730900)	
        end
    end
end

function dxDrawTextOnElement(TheElement,text,height,distance,R,G,B,alpha,size,font,...)
	local x, y, z = getElementPosition(TheElement)
	local x2, y2, z2 = getCameraMatrix()
	local distance = distance or 20
	local height = height or 1

	if (isLineOfSightClear(x, y, z+2, x2, y2, z2, ...)) then
		local sx, sy = getScreenFromWorldPosition(x, y, z+height)
		if(sx) and (sy) then
			local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			if(distanceBetweenPoints < distance) then
				dxDrawText(text, sx+2, sy+2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), (size or 1)-(distanceBetweenPoints / distance), font or "arial", "center", "center")
			end
		end
	end
end

function math.round(number)
    return number - number % 1
end

function string.split(str)
	if not str or type(str) ~= "string" then return false end
	local splitStr = {}
   	for i=1,string.len(str) do
    	local char = str:sub( i, i )
      	table.insert( splitStr , char )
   	end
  	return splitStr 
end

function table.size(tab)
    local length = 0
    for _ in pairs(tab) do length = length + 1 end
    return length
end

function dxDrawEmptyRec(absX, absY, sizeX, sizeY, color, ancho)
	dxDrawRectangle(absX, absY, sizeX, ancho, color)
	dxDrawRectangle(absX, absY + ancho, ancho, sizeY - ancho, color)
	dxDrawRectangle(absX + ancho, absY + sizeY - ancho, sizeX - ancho, ancho, color)
	dxDrawRectangle(absX + sizeX-ancho, absY + ancho, ancho, sizeY - ancho*2, color)
end

function cursorPosition(x, y, width, height)
	if (not isCursorShowing()) then
		return false
	end
	local sx, sy = guiGetScreenSize()
	local cx, cy = getCursorPosition()
	local cx, cy = (cx*sx), (cy*sy)
	if (cx >= x and cx <= x + width) and (cy >= y and cy <= y + height) then
		return true
	else
		return false
	end
end

function getVehicleHandlingProperty ( element, property )
    if isElement ( element ) and getElementType ( element ) == "vehicle" and type ( property ) == "string" then
        local handlingTable = getVehicleHandling ( element )
        local value = handlingTable[property]
        if value then
            return value
        end
    end
    return false
end

function reposition(value, start, vend, const, status)
    local s = status or false
    local v = value or 0
    if s and v > start then v = v - const 
    elseif not s and v < vend then v = v + const end
    if s and v <= start then s = false end
    if not s and v >= vend then s = true end
    return v, s
end

function serializeTable(table)
	local serial = ""
	for id, value in pairs(table) do
		serial = serial..id.."="..value.."+&"
	end
	serial = "Serial/={"..serial:sub(1, #serial -2).."}=/"
	return serial
end

function unserializeTable(serial)
	local value = serial:gsub("Serial/={", "")
	value = value:gsub("}=/", "")
	local stables = split(value, "+&")
	local tables = {}
	for id, result in pairs(stables) do
		local values = split(result, "=")
		local index = tonumber(values[1])
		if not index then
			index = values[1]
		end
		local v = values[2]
		if v == "true" then v = true elseif v == "false" then v = false else
			v = tonumber(values[2])
			if not v then
				v = values[2]
			end
		end
		tables[index] = v
	end
	return tables
end

function class(base, init)
    local c = {}    -- a new class instance
    if not init and type(base) == 'function' then
       init = base
       base = nil
    elseif type(base) == 'table' then
     -- our new class is a shallow copy of the base class!
       for i,v in pairs(base) do
          c[i] = v
       end
       c._base = base
    end
    -- the class will be the metatable for all its objects,
    -- and they will look up their methods in it.
    c.__index = c
 
    -- expose a constructor which can be called by <classname>(<args>)
    local mt = {}
    mt.__call = function(class_tbl, ...)
    local obj = {}
    setmetatable(obj,c)
    if init then
       init(obj,...)
    else 
       -- make sure that any stuff from the base class is initialized!
       if base and base.init then
       base.init(obj, ...)
       end
    end
    return obj
    end
    c.init = init
    c.is_a = function(self, klass)
       local m = getmetatable(self)
       while m do 
          if m == klass then return true end
          m = m._base
       end
       return false
    end
    setmetatable(c, mt)
    return c
 end