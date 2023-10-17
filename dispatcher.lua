package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
local cjson = require("cjson")
local validate = require("validations.validate_requests")
local B = require("base_class.base_route")

local function parse_request(env, json_data)
    local t = {}
    local data = cjson.decode(json_data)
    for key, value in pairs(data) do
        env[key] = value
    end
    return env
end

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
    endpoint.env = env
    router.env = env
    endpoint.request_body = request_body

    local content = parse_request(env, request_body)
    endpoint.request = cjson.decode(request_body)
    B.data = cjson.decode(request_body)
    endpoint.params = params(env)
    B.params = params(env)

    local is_valid, validation_message = validate.validate_request(content, request_body)
    
    if is_valid then
        endpoint:handle_request()
    else

        endpoint.send("Error hereee: " .. validation_message)
    end
end


local type = {
    string = "string",
    number = "number",
    email = "email"
}

