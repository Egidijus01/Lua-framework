local uci = require("uci")
local Select = require('orm.uci_orm.get')
local Query = require('orm.uci_orm.query')


local fields = require('orm.uci_orm.field_type')






Config = {
   
    __configname__ = nil,
    tables = {}

}

local function create_config_file(name)
    local file_path = "/etc/config/" .. name

    -- Open the file in append mode (creates the file if it doesn't exist)
    local file = io.open(file_path, "a")

    if not file then

        return
    end

    -- Close the file when done
    file:close()
end

function Config:create_table(table_instance)

    -- table information
    local configname = table_instance.__configname__
    local columns = table_instance.__colnames
   



    create_config_file(configname)

end

-- Create new table instance
--------------------------------------

function Config.new(self, args)
    self.tables = {}
    local colnames = {}
    self.__configname__ = args.__configname__
    args.__configname__ = nil

    self.__opts__ = {};


    for optname, coltype in pairs(args) do

        -- append to self cols
        if (args[optname]) then
          table.insert(self.__opts__, optname);
        end
    end
    

    local Config_instance = {
        ------------------------------------------------
        --            Table info variables            --
        ------------------------------------------------

        -- SQL table name
        __configname__ = self.__configname__,

        -- list of column names
        __optnames = {},




        __index = function (self, key)
            
            if key == "get" then
                return Select(self)
            end

            local old_index = self.__index
           
            setmetatable(self, {__index = nil})

            key = self[key]

            setmetatable(self, {__index = old_index, __call = self.create})

            return key
        end,

        -- Create new row instance
        -----------------------------------------
        -- @data {table} parsed query answer data
        --
        -- @retrun {table} Query instance
        -----------------------------------------
        create = function (self, data)
            
            return Query(self, data)

        end,

        ------------------------------------------------
        --          Methods which using               --
        ------------------------------------------------

        -- parse column in correct types
        column = function (self, column)
            local configname = self.__configname__

            if Type.is.table(column) then
                column.colname = configname .. column.colname
                column = column .. ""
            end

            return "`" .. configname .. "`.`" .. column .. "`",
            configname .. "_" .. column
        end,

        -- Check column in table
        -----------------------------------------
        -- @colname {string} column name
        --
        -- @return {boolean} get true if column exist
        -----------------------------------------
        has_column = function (self, colname)
            for _, table_column in pairs(self.__optnames) do
                if table_column.name == colname then
                    return true
                end
            end


        end,
        
        get_tables = function ()
            return self.tables
        end,
        -- get column instance by name
        -----------------------------------------
        -- @colname {string} column name
        --
        -- @return {table} get column instance if column exist
        -----------------------------------------
        get_column = function (self, colname)

            for _, table_column in pairs(self.__optnames[2]) do
             
            end
            -- for _, table_column in pairs(self.__optnames) do
            --     if table_column.name == colname then
                    
            --         return table_column
            --     end
            -- end

            
        end
    }

    -- Add default column 'id'

    -- args.id = fields.PrimaryField({auto_increment = true})
 
    -- copy column arguments to new table instance
    for _, optname in ipairs(self.__opts__) do
        
        local coltype = args[optname];
        coltype.name = optname
        coltype.__table__ = Config_instance
 
        table.insert(Config_instance.__optnames, coltype)
    end


    table.insert(self.tables, Config_instance)
    setmetatable(Config_instance, {
        __call = Config_instance.create,
        __index = Config_instance.__index
    })

    self:create_table(Config_instance)

    return Config_instance
    
end

setmetatable(Config, {__call = Config.new})

return Config