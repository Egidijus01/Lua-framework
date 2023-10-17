sample = {}
local lualog = require("lualog")
local cjson = require("cjson")
local parse = require("validations.parse")

local validation_rules = {
    required_headers = {"content-type"}, -- List of required headers
    allowed_content_types = {"application/json", "multipart/form-data", "application/x-www-form-urlencoded"}, -- List of allowed content types
}


-- Function to check if the content type is allowed
local function is_allowed_content_type(content_type)
    for _, allowed_type in ipairs(validation_rules.allowed_content_types) do
        if content_type == allowed_type then
            return true
        end
    end
    return false
end

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
        response = parse.parse_json(data)
    elseif string.match(content_type, "multipart/form%-data") then
        print("Multipart is here")
        response = parse.parse_form_data(data)


    elseif content_type == "application/x-www-form-urlencoded" then
        response = parse.parse_urlencoded(data)
        
    end
    -- Add more validation checks as needed

    return true, "Request is valid", response
end
return sample