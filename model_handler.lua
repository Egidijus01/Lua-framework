local models = require("./models")
local model_handler = {}

model_handler.create = {}  -- Create a sub-table for object creation functions


local function validate_fields(data, model)
    for propertyName, propertyType in pairs(models[model]) do

        if propertyType == "string" then
            if not string.match(data[propertyName] or "", "^[^%d]*$") then
                return false, "Validation Error: Property '" .. propertyName .. "' contains numbers."
            end
        elseif propertyType == "number" then
            if not string.match(data[propertyName] or "", "^[0-9]*$") then
                return false, "Validation Error: Property '" .. propertyName .. "' contains letters."
            end
        elseif propertyType == "email" then
            if not string.match(data[propertyName] or "", ".+@.+%..+") then
                print("Validation Error: Property '" .. propertyName .. "' is not a valid email.")
            end
        else
            return false, "Error: Unknown property type."
        end
    end
    return true, "Validation successful"
end


for model, table in pairs(models) do
    model_handler.create[model] = function(data)
        local is_valid, validation_message = validate_fields(data, model)
        if is_valid then
            -- Your logic for creating an object here
            print("Created successfully for model:", model)
        else
            print(validation_message)
        end
    end
end



return model_handler