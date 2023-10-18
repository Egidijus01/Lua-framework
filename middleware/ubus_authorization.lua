
local headers = require("validations.headers.required_headers")
local ubus = require "ubus"
-- Establish connection
local conn = ubus.connect()
if not conn then
    error("Failed to connect to ubusd")
end

print(#conn:objects())

local status = conn:call("session", "login", { username = "admin", password = "admin01" })






for i,x in pairs(status.data) do
print(i,x)
end

print(status)



table.insert(headers.required_headers, "Authorization")

local Ubus_auth = {}


function Ubus_auth:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.routes = {}
    return obj
end

function Ubus ()
    
end



return Ubus_auth