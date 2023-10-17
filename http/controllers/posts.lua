local response = require("response")
local codes = require("http_codes")
local models = require("http.models.posts_models")
local User = models.User
local Base = require("base_class.base_route")




local Sample = Base:new()

function Sample:handlePostUser()
    print(self.name)
    -- for i,x in pairs(self.data) do
    --     print(i,x)
    -- end
    

    print("printas is post")
    -- You can use self.name here
    -- local user = User({
    --     username = data.username,
    --     password = data.password,
    --     time_create = os.time()
    -- })
    -- user:save()
    response.send_response(200, "success")
end

function Sample:getSomg()
    print("printas is get")
end

function Sample:deleteHandler(id)
    print("print is delete")
    print(id)
    -- print(self.params)

--         local useris = User.get:where({id=id}):first()

--         useris:delete()
    response.send_response(204, "Delted")

end


return Sample