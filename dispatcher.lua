package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
local cjson = require("cjson")
local validate = require("validations.validate_data")
local valid_method = require("validations.validate_method")
local B = require("base_class.base_route")
local err = require("utils.responses.error_response")

local function params (env)
    local queryString = env.QUERY_STRING or ""
    local parameters = {}
    for key, value in queryString:gmatch("/:([^/]+)", "(/[^/]+)") do
        parameters[key] = value
    end
    return parameters
end


local router = require("framew.router")

-- Main body required by uhhtpd-lua plugin
function handle_request(env)

    -- Injected uhttpd method
    local endpoint_module = require("http.endpoint")

    -- Check if the endpoint_module loaded correctly
    if not endpoint_module then
        -- Handle the error or log it
        return "Error loading endpoint module"
    end

    local endpoint = require("http.endpoint")

    local request_body = io.stdin:read("*all")

    


    endpoint.params = params(env)
    B.params = params(env)
    


    local is_valid, validation_message, content = validate.validate_request(env, request_body)

    local d = valid_method.validateRequestMethod(env.REQUEST_METHOD)

    if is_valid and d then
        B.data = content

        endpoint.env = env
        router.env = env
        endpoint.request_body = request_body
        endpoint:handle_request()
        
    else

        err(validation_message)
    end


end



