local response = require("response")
local codes = require("http_codes")
local models = require("http.models.posts_models")
local User = models.User
local Base = require("base_class.base_route")




-- local Sample = setmetatable({}, Base)
local Sample = Base:new()



function Sample:handlePostUser()
  
    for i,x in pairs(Sample.data) do
    print(i,x)
    end
    -- print("ssssss", Sample.data)
    -- for i, x in pairs(Sample.data) do
    -- print(i,x)
    -- end 

end

function Sample:getSomg()
    print("printas is get")
end

function Sample:deleteHandler(id)
    print("print is delete")
    print(id)

    response.send_response(204, "Delted")

end


return Sample