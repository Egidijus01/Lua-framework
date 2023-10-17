local M = {}

function M.parse_form_data(data)
    local parsed_data = {}
    if data:sub(-1) ~= "\r\n" then data = data .. "\r\n" end
    local counter = 0
    local keys, values = {}, {}
    for k in data:gmatch("(.-)\r\n") do
        counter = counter + 1
        if string.match(k, "name=") then
            table.insert(keys, string.match(k, 'name="(.+)"'))
        end
        if counter % 4 == 0 then table.insert(values, k) end
    end

    for k, v in ipairs(keys) do parsed_data[v] = values[k] end
    return parsed_data
end


function M.parse_json(data)
  
    local success, json_data = pcall(cjson.decode, data)
        if not success then
            return "Invalid JSON data"
        end
        return json_data

end


function M.parse_urlencoded(data)
    local response = {}
    for key, value in data:gmatch("([^&]+)=([^&]+)") do
        key = key:gsub("+", " ") -- Replace '+' with space
        key = key:gsub("%%(%x%x)", function(h)
            return string.char(tonumber(h, 16))
        end)
        value = value:gsub("+", " ") -- Replace '+' with space
        value = value:gsub("%%(%x%x)", function(h)
            return string.char(tonumber(h, 16))
        end)
        response[key] = value
    end
    return response
end

return M