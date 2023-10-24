sample = {}
local lualog = require("lualog")
local cjson = require("cjson")
local parse = require("validations.parse")
local headers = require("validations.headers.required_headers")

local validation_rules = {
    required_headers = headers.required_headers, -- List of required headers
    allowed_content_types = headers.allowed_content_types, -- List of allowed content types
}



-- Function to validate the request
function sample.validate_request(env, data)
    
    local response = {}
    -- Check required headers
    for _, header in ipairs(validation_rules.required_headers) do
        if not env["headers"] then
            return false, "Missing required header: " .. header
        end
    end

    -- Check content type
    local content_type = env.headers["content-type"]
    -- if not content_type or not is_allowed_content_type(content_type) then
    --     return false, "Invalid or unsupported Content-Type header"
    -- end


    if content_type == "application/json" then
        -- response = parse.parse_json(data)
        local status, content = pcall(cjson.decode, data)
      
        response = content
        if status then
            response = content
        else
            return false
        end

    elseif string.match(content_type, "multipart/form%-data") then
        -- response = parse.parse_form_data(data)
        local status, content = pcall(parse.parse_form_data, data)
        if status then
            response = content
        else
            return false
        end

    elseif content_type == "application/x-www-form-urlencoded" then
        -- response = parse.parse_urlencoded(data)
        local status, content = pcall(parse.parse_urlencoded, data)
        if status then
            response = content
        else
            return false
        end
    
    else
        return false
    end


    return true, "Request is valid", response
end
return sample