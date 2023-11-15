
local router = require("framew.router")

local rr = router:new()
rr:post("/api/create/", "posts.handlePostUser")
rr:get("/api/get", "posts")
rr:get("/api/get1", function (request, response)
    
    return response:with_status(205):response()
end)

rr:delete("/api/delete", "posts.deleteTest", {"auth"})
rr:put("/api/put", "posts.putTest", {"auth"})
rr:post("/api/login", "posts.Login")



return rr