local SQLLite = class(function(clazz, db) 
    clazz.dbname = db..".db"
end)
Sql = SQLLite("database")

function SQLLite:connect()
    self.connection = dbConnect( "sqlite" , self.dbname)
end

function SQLLite:createTable(name, params)
    dbExec(self.connection, "CREATE TABLE IF NOT EXISTS "..name.."("..params..")")
end

function SQLLite:query(...)
    local queryHandle = dbQuery(self.connection, ...)
    if (not queryHandle) then
        return nil
    end
    local rows = dbPoll(queryHandle, -1)
    return rows
end

function SQLLite:execute(...)
    local queryHandle = dbQuery(self.connection, ...)
    local result, numRows = dbPoll(queryHandle, -1)
    return numRows
end

function SQLLite:getConnection()
    return self.connection
end