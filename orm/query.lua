------------------------------------------------------------------------------
--                          query.lua                                       --
------------------------------------------------------------------------------
local err = require("utils.responses.error_response")
require("uci")
local x = uci.cursor()
local cjson = require("cjson")







function Query(own_table, data)
    local query = {
        ------------------------------------------------
        --          Table info varibles               --
        ------------------------------------------------

        -- Table instance
        own_table = own_table,


        _data = {},
        _get_opt = function (self, colname)
            
            if self._data[colname] and self._data[colname].new then
                return self._data[colname].new

            elseif self._readonly[colname] then
                return self._readonly[colname]
            end
        end,

        -- Set column new value
        -----------------------------------------
        -- @colname {string} column name in table
        -- @colvalue {string|number|boolean} new column value
        -----------------------------------------
        _set_opt = function (self, colname, colvalue)
            
            local coltype

            if self._data[colname] and self._data[colname].new and colname ~= ID then
                coltype = self.own_table:get_column(colname)

                if coltype and coltype.field.validator(colvalue) then
                    self._data[colname].old = self._data[colname].new
                    self._data[colname].new = colvalue
                else
                    err.requestError("Not valid column value for update")
                end
            end
        end,


        _addNew = function (self)
           
            local section = x:add(self.own_table.__configname__, 'interface')
          
            self._data["id"] = {new=section, old=section}
         
            for name, value in pairs(data) do
                if type(value) == "table" then
                    for _, val in pairs(value) do
                        x:set(self.own_table.__configname__, section, name, val)
                    
                    end
                end 
                x:set(self.own_table.__configname__, section, name, value)
            end
            x:save (self.own_table.__configname__)
            x:commit(self.own_table.__configname__)

        end,

        
        _update = function (self)

                x:foreach(self.own_table.__configname__, "interface", function(s)
                
                
                local id = self._data.id.new
               
                
                if s['.name'] == id then
                    
                    for key, value in pairs(self._data) do
                        x:set(self.own_table.__configname__, id, key, value.new)
                    end
                x:save (self.own_table.__configname__)
                x:commit(self.own_table.__configname__)
                end
                end)

        end,

        ------------------------------------------------
        --             User methods                   --
        ------------------------------------------------

        -- save row
        save = function (self)
            
            if self._data.id then
                
                self:_update()
            else
                self:_addNew()
            end
        end,
        with_name = function (self,name)
            x:set(self.own_table.__configname__,name, "interface")


           for option, value in pairs(self._data) do
                if type(value.new) == "table" then
                    
                    local ListJSON = cjson.encode(value.new)
                    x:set(self.own_table.__configname__, name, ListJSON)
                else
                    x:set(self.own_table.__configname__, name, option, value.new)
                end 
           end
       
           x:commit(self.own_table.__configname__)
        end,

        validate = function (self, field, validators)
           
            local resultTable = {}
            
            for item in validators:gmatch("([^|]+)") do
                table.insert(resultTable, item)
            end
        
            local fieldValue = self._data[field].new -- Get the value of the field
            
            for _, valid in pairs(resultTable) do
                if valid == "required" then
                    if fieldValue == nil then
                        return false, "Field is empty"
                    end
                else
                    local length = valid:match("length:(%d+)")
                    if length and fieldValue and string.len(fieldValue) > tonumber(length) then
                        return false, "Field exceeds the required length"
                    end
                end
               
            end
            return true
        end,

        delete = function (self)

            x:delete(self.own_table.__configname__, self._data.id.new)
            x:commit(self.own_table.__configname__)
            
        end
    }

    if data then
        
        for optname, optvalue in pairs(data) do
            if query.own_table:has_column(optname) then
                optvalue = query.own_table:get_column(optname)
                                          .field.to_type(optvalue)
                query._data[optname] = {
                    new = optvalue,
                    old = optvalue
                }
            
            end
        end
    
    end

    setmetatable(query, {__index = query._get_opt,
                         __newindex = query._set_opt})

    return query
end

return Query