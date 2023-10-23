local Check = {}
local response = require("utils.responses.error_response")
local UbusAuth = require("middleware.ubus_authorization")


local function get_token_from_header(headers)

    for type, header in pairs(headers) do
        if type == "authorization" then
            return header
        end
    end
    return nil
end


local function authorize( token )
    if token == UbusAuth.Claims.username then
        return true
    end
    return nil
end


function Check:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Check:with_ubus()
    local token = get_token_from_header(self.headers)
    if token then
        if authorize(token) then
            print("token: ",token)

            return true
        else
            return response.authError("Expired or invalid Authorization token")
        end
    else
        return response.headerError("No Authorization header")
    end
end


return Check