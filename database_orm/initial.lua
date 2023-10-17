
ID = "id"
AGGREGATOR = "aggregator"
QUERY_LIST = "query_list"

-- databases types
SQLITE = "sqlite3"



if not DB then
    print("[SQL:Startup] Can't find global database settings variable 'DB'. Creating empty one.")
    DB = {}
end

DB = {
    -- ORM settings
    new = (DB.new == true),
    DEBUG = (DB.DEBUG == true),

    -- database settings
    type = DB.type or "sqlite3",
    -- if you use sqlite set database path value
    -- if not set a database name
    name = DB.name or "database.db",
    -- not sqlite db settings
    host = DB.host or nil,
    port = DB.port or nil,
    username = DB.username or nil,
    password = DB.password or nil
}

local sql, _connect

-- Get database by settings
if DB.type == SQLITE then
    local luasql = require("luasql.sqlite3")
    sql = luasql.sqlite3()
    _connect = sql:connect(DB.name)

end
local createTableSQL = "CREATE TABLE IF NOT EXISTS your_table_name (id INTEGER PRIMARY KEY, name TEXT);"
db = {
    -- Database connect instance
    connect = _connect,

    -- Execute SQL query
    execute = function (self, query)


        local result = self.connect:execute(createTableSQL)

        if result then
            return result
       
        end
    end,

    -- Return insert query id
    insert = function (self, query)
        local _cursor = self:execute(query)
        return 1
    end,

    -- get parced data
    rows = function (self, query, own_table)
        local _cursor = self:execute(query)
        local data = {}
        local current_row = {}
        local current_table
        local row

        if _cursor then
            row = _cursor:fetch({}, "a")

            while row do
                for colname, value in pairs(row) do
                    current_table, colname = string.divided_into(colname, "_")

                    if current_table == own_table.__tablename__ then
                        current_row[colname] = value
                    else
                        if not current_row[current_table] then
                            current_row[current_table] = {}
                        end

                        current_row[current_table][colname] = value
                    end
                end

                table.insert(data, current_row)

                current_row = {}
                row = _cursor:fetch({}, "a")
            end

        end

        return data
    end
}
