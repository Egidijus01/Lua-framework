local UbusAuth = require("middleware.ubus_authorization")
local auth = UbusAuth:new()
local Base = require("base_class.base_route")
local models = require("http.models.posts_models")
local User = models.User

local b = Base:new()
local Sample = {}
function Sample:new()
    local obj = Base:new()
    setmetatable(obj, self)
    setmetatable(Sample, {__index = Base})
    self.__index = self
    return obj
end 


function Sample.index(request, response)

    print("print is index")
    
    return response()
end
function Sample:getSomg(request, response)
    local user1 = User({
        username = "Antanas",
        password = "Antanas123",
        age = "64",
        job = "Vairavimo instruktorius",
    
    })
    user1:save()
    print("User created")

    -- config:getTypedSections():where('address', NOT_EQUAL, '192.168.1.1')
    -- config:getNamedSection()
    -- config:getSections()
    

    return response:with_status(205):response()


end

function Sample:handlePostUser(request, response, id)
    -- print(request.headers['content-type'])

    -- return self.response.with_status(201)
    return response:with_status(205):response()
end

function Sample:create(request, response)
    return response:with_status(205):response()

end


function Sample:deleteTest(request, response, id)
    print("ID from handler:", id) 
    print("printas is delete")
    return response:with_status(205):response()

end

function Sample:putTest(request, response)
    local email = "antanas@mail"

    -- print(validators.validate_email(email))
    print("printas is put")
  
    return response:with_status(205):response()

end

function Sample:Login(request, response)
    local data = b.data

    local res = auth:Login(data.username, data.password)

    if res then
        return response:with_message(res):response()
    else
        return response:with_status(404):with_message("Not found"):response()
    end
end
return Sample