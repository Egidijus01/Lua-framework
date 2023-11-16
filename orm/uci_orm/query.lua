
local err = require("utils.responses.error_response")
require("uci")
local x = uci.cursor()
local cjson = require("cjson")







function Query(own_config, data)
    local query = {

        own_config = own_config,


        _data = {},
        _get_opt = function (self, colname)
            
            if self._data[colname] and self._data[colname].new then
                return self._data[colname].new

            elseif self._readonly[colname] then
                return self._readonly[colname]
            end
        end,


        _set_opt = function (self, colname, colvalue)
            
            local coltype

            if self._data[colname] and self._data[colname].new then
                coltype = self.own_config:get_column(colname)

                if coltype and coltype.field.validator(colvalue) then
                    self._data[colname].old = self._data[colname].new
                    self._data[colname].new = colvalue
                else
                    err.requestError("Not valid column value for update")
                end
            end
        end,


        _add = function (self)
           
            local section = x:add(self.own_config.__configname__, 'interface')
          
            self._data["id"] = {new=section, old=section}
         
            for name, value in pairs(data) do
                if type(value) == "table" then
                    for _, val in pairs(value) do
                        x:set(self.own_config.__configname__, section, name, val)
                    
                    end
                end 
                x:set(self.own_config.__configname__, section, name, value)
            end
            x:save (self.own_config.__configname__)
            if x:commit(self.own_config.__configname__) then
                return true
            else
                return false
            end

        end,
 
        _update = function (self)

                x:foreach(self.own_config.__configname__, "interface", function(s)
                
                
                local id = self._data.id.new
               
                
                if s['.name'] == id then
                    
                    for key, value in pairs(self._data) do
                        x:set(self.own_config.__configname__, id, key, value.new)
                    end
                x:save (self.own_config.__configname__)
                if x:commit(self.own_config.__configname__) then
                    return true
                else
                    return false
                end

                end
                end)

        end,


        -- user methods

        save = function (self)
            
            if self._data.id then
                if self:_update() then
                    return true
                else
                    return false                    
                end
            else
                if self:_add() then
                    return true
                else
                    return false              
                end
            end
        end,

        with_name = function (self,name)
            x:set(self.own_config.__configname__,name, "interface")


           for option, value in pairs(self._data) do

                if type(value.new) == "table" then
                    
                    local ListJSON = cjson.encode(value.new)
                    x:set(self.own_config.__configname__, name, ListJSON)
                else
                    x:set(self.own_config.__configname__, name, option, value.new)
                end 
           end
       
           x:commit(self.own_config.__configname__)
        end,

        validate = function (self, field, validators)
           
            local resultTable = {}
            
            for item in validators:gmatch("([^|]+)") do
                table.insert(resultTable, item)
            end
        
            
            for _, valid in pairs(resultTable) do
                if valid == "required" then
                    if self._data[field] == nil then
                        return false, field.." Field is required"
                    end
                elseif string.find(valid, "length") then
                    local fieldValue = self._data[field].new
                    local length = valid:match("length:(%d+)")
                    if length and fieldValue and string.len(fieldValue) > tonumber(length) then
                        return false, field.." Field exceeds the required length"
                    end

                elseif valid == "email" then
                    local pattern = "^[%w%.]+@[%w%.]+%.[%a]+$"
                    local fieldValue = self._data[field].new
                    if not fieldValue:match(pattern) then
                        return false, field.." Isn't valid email address"
                    end

                elseif valid == "numbers" then
                    local fieldValue = self._data[field].new
                    
                    if type(fieldValue) == "string" then
                        if not fieldValue:match("[^%d]+") then
                            return false, field.." Field Contains letters"
                        end
                    elseif type(fieldValue) == "number" then
                        return true
                    end
                    
                elseif valid == "letters" then
                    local fieldValue = self._data[field].new
                    if not fieldValue:match("[^%a]+") then
                        return false, field.." Field Contains numbers"
                    end
                end
               

            end
            return true
        end,

        delete = function (self)

            x:delete(self.own_config.__configname__, self._data.id.new)
            x:commit(self.own_config.__configname__)
            
        end
    }

    if data then
        
        for optname, optvalue in pairs(data) do
            if query.own_config:has_column(optname) then
                -- optvalue = query.own_config:get_column(optname)                        
                
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