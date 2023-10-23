
-- local headers = require("validations.headers.required_headers")
local ubus = require "ubus"
local cl = require("middleware.claims")
local conn = ubus.connect()
if not conn then
    error("Failed to connect to ubusd")
end


Claims = cl:new()



local Ubus_auth = {}

local function getToken(username, password)
    local res = conn:call("session", "login", { username = username, password = password })

    if res then

        local token = res.ubus_rpc_session
        -- local list = conn:call("session", "list", {ubus_rpc_session=token})
        return token
    else
        return nil
    end
end


function Ubus_auth:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.routes = {}
    return obj
end

function Ubus_auth:Login (username, password)
    return getToken(username, password)
end



return Ubus_auth