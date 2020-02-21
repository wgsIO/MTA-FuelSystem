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

function playerHasMoney(player, value) 
    return getPlayerMoney(player) >= value
end

function removePlayerMoney(player, value)
    setPlayerMoney(player, getPlayerMoney(player) - value)
end

function addPlayerMoney(player, value)
    setPlayerMoney(player, getPlayerMoney(player) + value)
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

function sendPlayerMessage(player, message, type)
    triggerClientEvent(player, "addNotification", player, message, type)
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