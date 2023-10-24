local sample = {}
local err = require("utils.responses.error_response")

function sample.validateRequestMethod(requestMethod)
    local validMethods = { "GET", "POST", "PUT", "DELETE" }
    
    local success, error_message = pcall(function()
        assert(type(requestMethod) == "string")
    end)
    
    if success then
        for _, method in ipairs(validMethods) do
            if method == requestMethod then
                return true, nil
            end
        end
    end

    
    return false
end


return sample