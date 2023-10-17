package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
local cjson = require("cjson")
local validate = require("validations.validate_requests")
local B = require("base_class.base_route")



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

   
    -- endpoint.request = cjson.decode(request_body)

    endpoint.params = params(env)
    B.params = params(env)
    


    -- for i,x in pairs(env.headers) do
    -- print(i,x)
    -- end
-- local a = (env.headers["content-type"])
-- print(a)
-- print("w", )
        -- if string.find(a, "multipart/form-data") then
        --     print("ok")
        -- else
        --     print("neok")
        -- end




    local is_valid, validation_message, content = validate.validate_request(env, request_body)
    B.data = content
 
        

    if is_valid then
        endpoint:handle_request()
        
    else

        endpoint.send("Error hereee: " .. validation_message)
    end


end



