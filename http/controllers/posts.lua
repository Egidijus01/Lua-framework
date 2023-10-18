local response = require("utils.responses.response")
local codes = require("utils.http_codes")
local models = require("http.models.posts_models")
local User = models.User
local Base = require("base_class.base_route")
local validators = require("utils.validations.validate_fields")



-- local Sample = setmetatable({}, Base)
local Sample = Base:new()



function Sample:handlePostUser(id)
    print("ID from handler", id)
    for i,x in pairs(Sample.data) do
    print(i,x)
    end
    -- print("ssssss", Sample.data)
    -- for i, x in pairs(Sample.data) do
    -- print(i,x)
    -- end 
    response.send_response(codes.CREATED, "Created succesfully")

end

function Sample:getSomg()
    print("printas is get")
    print("name", Sample.name)
    response.send_response(codes.OK, "OK")
end

function Sample:deleteTest(id)
    print("ID from handler:", id) 
    print("printas is delete")
    response.send_response(codes.OK, "Deleted succesfully")
end

function Sample:putTest()
    local email = "antanas@mail"
    print(validators.validate_email(email))
    print("printas is put")
    response.send_response(codes.OK, "Updated succesfully")
end


return Sample