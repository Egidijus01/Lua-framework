local response = require("utils.responses.response")
local codes = require("utils.http_codes")
local models = require("http.models.posts_models")
local User = models.User
local Base = require("base_class.base_route")
local validators = require("utils.validations.validate_fields")
local UbusAuth = require("middleware.ubus_authorization")
local base64 = require'base64'


local auth = UbusAuth:new()

-- local Sample = setmetatable({}, Base)
local Sample = Base:new()



function Sample:handlePostUser(request, id)
    -- print(request.headers['content-type'])
    print("printas is post")
    

    print(id)

    response.send_response(codes.CREATED, "Created succesfully")

end

function Sample:getSomg(request)
    print("printas is get")
    -- print(request:option("username"))
    for i,x in pairs(request) do
    print(i,x)
    end
    response.send_response(codes.OK, "OK")
end

function Sample:deleteTest(request, id)
    print("ID from handler:", id) 
    print("printas is delete")
    response.send_response(codes.OK, "Deleted succesfully")
end

function Sample:putTest(request)
    local email = "antanas@mail"

    print(validators.validate_email(email))
    print("printas is put")
  
    response.send_response(codes.OK, "Updated succesfully")
end

function Sample:Login(request)
    local data = Sample.data
    local res = auth:Login(data.username, data.password)    
    if res then
        response.send_response(codes.OK, res)
    else
        response.send_response(codes.NOT_FOUND, "Wrong credentials")
    end

end
return Sample