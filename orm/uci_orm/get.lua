local uci = require("uci")
local Query = require("orm.uci_orm.query")
local x = uci.cursor()
local function return_match(data, rules)
    for _, table in ipairs(data) do
        local match = true
        for key, value in pairs(rules) do
            if table[key] ~= value then
                match = false
                break  -- Break the inner loop when a non-match is found
            end
        end
        if match then
            return table  -- Return the table after checking all key-value pairs
        end
    end
end
local function exclude_properties_with_dot(data)
    local result = {}
    for key, value in pairs(data) do
        -- Check if the property name starts with a dot
        if string.sub(key, 1, 1) ~= "." then
            result[key] = value
        end
    end
    return result
end
local Select = function(own_config)
    return {

        own_config = own_config,

        -- Create select rules
        _rules = {
            -- Where equation rules
            where = {},
   
            
        },

        where = function (self, args)

            
            for col, value in pairs(args) do
                self._rules.where[col] = value
            end

            return self
        end,

---------------------------------------------------------------------

        -- GET METHODS
        with_id = function (self, id)
            local data = self:all()

            -- for key, value in pairs(rules) do
        
                if data[id] then
                    return data[id]
                    
                end
            -- end
        end,

        first = function (self)
            
            local data = self:all()

            local table = return_match(data, self._rules.where)
            
            if table then
                return table
            end

        end,

        -- Return list of values
        all = function (self)
            local res = {}
            local data = x:get_all(self.own_config.__configname__)

            
            
            local i =1
            for id, table in pairs(data) do
               
                local info = exclude_properties_with_dot(table)
                local object = Query(self.own_config, info)
                object._data["id"] = {new=id, old=id}

                res[i] = object
                i = i + 1
            end
 

            return res
        end,

    }
end

return Select