


local posts = require("handlers.post")
local router = require("framew.router")

local rr = router:new()

rr:post("/api/create", posts.handlePostUser)
rr:get("/api/get", posts.getSomg)

return rr