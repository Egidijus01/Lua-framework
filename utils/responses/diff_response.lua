local cjson = require("cjson")

M = {}

function M:new()
    local obj = {}
    setmetatable(obj, self)
    self.message = "OK"
    self.status = 200
    self.__index = self
    return obj
end



function M:with_status(status)
    self.status = status
    return self
end
function M:with_message(message)
    self.message = message
    return self
end
function M:response()
    uhttpd.send("Status: " .. self.status .. " \r\n")
    uhttpd.send("Content-Type: application/json\r\n\r\n")
    uhttpd.send(cjson.encode({status_code = self.status, response = self.message}))
    -- return self
end



-- function M.with_json(response)
--     local res = response or {}
--     uhttpd.send("Status: ", self.status ," \r\n")
--     uhttpd.send("Content-Type: application/json\r\n\r\n")

--     setmetatable(res, cjson.array_mt)

--     uhttpd.send(cjson.encode(res))
-- end


return M