sample = {}

local cjson = require("cjson")



local validation_rules = {
    required_headers = {"content-type"}, -- List of required headers
    allowed_content_types = {"application/json"}, -- List of allowed content types
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
function sample.validate_request(env, json_data)
    -- Check required headers
    for _, header in ipairs(validation_rules.required_headers) do
        if not env["headers"] then
            return false, "Missing required header: " .. header
        end
    end

    -- Check content type
    local content_type = env.headers["content-type"]
    if not content_type or not is_allowed_content_type(content_type) then
        return false, "Invalid or unsupported Content-Type header"
    end

    -- Add more validation checks as needed

    return true, "Request is valid"
end
return sample