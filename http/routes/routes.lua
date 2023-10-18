


local posts = require("http.controllers.posts")
local router = require("framew.router")

local rr = router:new()
rr:post("/api/create/:id", posts.handlePostUser)
rr:put("/api/put", posts.getSomg)
rr:delete("/api/delete/:id", posts.deleteTest)
rr:put("/api/put", posts.putTest)

return rr