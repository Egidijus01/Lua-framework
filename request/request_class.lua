local M = {}


function M:new(data, query, headers)
    local instance = {}
    setmetatable(instance, self)
    self.__index = self

    self.data = data or {}
    self.query = query or {}
    self.headers = headers

    return instance
end

function M:hea()
    return self.headers
end

function M:query_table()
    local result = {}
    for key, value in self.query:gmatch("([^&]+)=([^&]+)") do
        result[key] = value
    end
    return result
    
end

function M:option(name)
    return self.data[name] or nil
end

function M:query(string)
    local pattern = string .. "=([^&]+)"
    local value = self.query:match(pattern)
    return value
end

return M