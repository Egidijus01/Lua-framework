local sample = {}

local cjson = require("cjson")
local parse = require("validations.parse")
local headers = require("validations.headers.required_headers")
local settings = require("http.config")
local Multipart = require("multipart")
local path = settings.assets_dir


local validation_rules = {
    required_headers = headers.required_headers, -- List of required headers
    allowed_content_types = headers.allowed_content_types, -- List of allowed content types
}



-- Function to validate the request
function sample.validate_request(env, data)
    if not data then
        data = {}
    end
    
    local response = {}
    -- Check required headers
    for _, header in ipairs(validation_rules.required_headers) do
        if not env["headers"] then
            return false, "Missing required header: " .. header
        end
    end

    -- Check content type
    local content_type = env.headers["content-type"]
    if not content_type then
        return false, "No Content-type header"
    end


    if content_type == "application/json" then
        -- response = parse.parse_json(data)
        local status, content = pcall(cjson.decode, data)
      
        response = content
        if status then
            response = content
        else
            return false, "Invalid json data"
        end

    elseif string.match(content_type, "multipart/form%-data") then
        -- response = parse.parse_form_data(data)
        local status, content = pcall(parse.parse_form_data, data)

        local Multipart = require("multipart")
        local multipart_data = Multipart(data, content_type)
        -- local parameter = multipart_data:get("kazkas")
        local files = multipart_data:get_as_array("files")
        print(files)
        for i,x in pairs(files) do
            print(i,x)
        end
        if status then
            response = content
            
        else
            return false, "Invalid multipart/form data"
        end

    elseif content_type == "application/x-www-form-urlencoded" then
        -- response = parse.parse_urlencoded(data)
        local status, content = pcall(parse.parse_urlencoded, data)
        if status then
            response = content
        else
            return false, "Invalid x-www-form-urlencoded data"
        end
    
    else
        return false, "Content type is not supported"
    end

    return true, "", response
end
return sample