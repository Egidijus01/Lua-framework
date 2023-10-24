
-- local codes = require("utils.http_codes")
-- local models = require("http.models.posts_models")
-- local User = models.User
-- local validators = require("utils.validations.validate_fields")
local UbusAuth = require("middleware.ubus_authorization")

local auth = UbusAuth:new()

local Base = require("base_class.base_route")
local res = require("utils.responses.response")

local b = Base:new()
local Sample = {}
function Sample:new()
    local obj = Base:new()
    setmetatable(obj, self)
    setmetatable(Sample, {__index = Base})
    self.__index = self
    return obj
end 


function Sample.index(request)
    print("print is index")
    
    return b.response()
end
function Sample:getSomg(request)
    print("Printas is get")
    return b.response:with_status(205):response()


end

function Sample:handlePostUser(request, id)
    -- print(request.headers['content-type'])

    -- return self.response.with_status(201)
    return b.response:with_status(205):response()
end

function Sample:create()
    return b.response:with_status(205):response()

end


function Sample:deleteTest(request, id)
    print("ID from handler:", id) 
    print("printas is delete")
    return b.response:with_status(205):response()

end

function Sample:putTest(request)
    local email = "antanas@mail"

    -- print(validators.validate_email(email))
    print("printas is put")
  
    return b.response:with_status(205):response()

end

function Sample:Login(request)
    local data = b.data

    local res = auth:Login(data.username, data.password)    
    if res then
        return b.response:with_message(res)
    else
        return b.response:with_status(404):with_message("Not found"):response()
    end
    -- return b.response:response()
end
return Sample