local UbusAuth = require("middleware.ubus_authorization")
local auth = UbusAuth:new()
local Base = require("base_class.base_route")
local models = require("http.models.posts_models")
local User = models.User
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


function Sample.index(request, response)

    print("print is index")
    
    return response:with_status(205):response()
end
function Sample.getSomg(request, response)
   
    local users = User.get:all()
print("We get " .. users:count() .. " users")
    -- local users = User.get:all()

    -- local data = {}
    -- for i,x in pairs(users) do
    --     table.insert(data, {x.username, x.password, x.age, x.job})
    -- end 
    print(request:query_table())

    return response:with_message("Ok"):response()


end

function Sample.handlePostUser(request, response)
    
    -- print(User)
    -- local data = request.data
    -- print(data.username)
    -- local user1 = User({
    --     username = data.username,
    --     password = data.password,
    --     age = data.age,
    --     job = data.job,
 
    -- })
    
    -- user1:save()
    local user = User({
        username = "Bob Smith",
        password = "SuperSecretPassword",
        time_create = os.time()
    })
    user:save()

    -- local cond, msg = user1:validate('age', "required|length:5")
    -- if cond then
    --     user1:save()
    --     return response:with_status(201):with_message("User created"):response()     
    -- else
    --     return response:with_status(400):with_message(msg):response()
    -- end
    return response:with_message("Ok"):response()
end


function Sample.deleteTest(request, response, id)
    print("ID from handler:", id)

    -- local user = User.get:where({username = "Antanas"}):first()
    -- user:delete()
    -- for i,x in pairs(user) do print(i,x) end


    print("printas is delete")
    return response:with_status(205):response()

end

function Sample.putTest(request, response)
    local email = "antanas@mail"

    -- local user = User.get:where({username = "Antanas"}):first()

    -- user.username = "Antanukas"
    -- user:save()

    print("printas is put")
  
    return response:with_status(205):response()

end

function Sample.Login(request, response)
    local data = request.data

    local res = auth:Login(data.username, data.password)
    
    if res then
        return response:with_status(200):with_message(res):response()
    else
        return response:with_status(404):with_message("Not found"):response()
    end

end
return Sample