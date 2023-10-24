local err = require("utils.responses.error_response")
local ubus = require "ubus"
local conn = ubus.connect()
if not conn then
    error("Failed to connect to ubusd")
end
local M = {}

local function checkIfTokenIsValid(token)
    local res = conn:call("session", "list", {ubus_rpc_session=token})
    if res then
        if res.ubus_rpc_session==token then
            return true            
        end
    else
        return nil
    end

end


function M.init(request)
    local token = request.headers['authorization']

    if token == nil then
        return false
    end 

    if checkIfTokenIsValid(token) then
        return true
    else
        return false
    end
end


return M