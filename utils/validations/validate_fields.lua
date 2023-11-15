local sample = {}

function sample.containsOnlyLetters(data)
    return not data:match("[^%a]+")
end
function sample.containsOnlyNumbers(data)
    return not data:match("[^%d]+")
end
function sample.validate_email(data)
    local pattern = "^[%w%.]+@[%w%.]+%.[%a]+$"
    
    -- Use the match function to check if the email matches the pattern
    return data:match(pattern) ~= nil
end

return sample
