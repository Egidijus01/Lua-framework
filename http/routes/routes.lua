
local router = require("framew.router")

local rr = router:new()
rr:post("/api/create/", "posts.handlePostUser")
rr:get("/api/get", "posts.getSomg")
rr:delete("/api/delete", "posts.deleteTest")
rr:put("/api/put", "posts.putTest")
rr:post("/api/login", "posts.Login")



return rr