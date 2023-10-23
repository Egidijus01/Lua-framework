local check = require("middleware.check authorization")
local posts = require("http.controllers.posts")
local router = require("framew.router")
local CH = check:new()




local rr = router:new()
rr:post("/api/create/:id", posts.handlePostUser)
rr:get("/api/get", posts.getSomg, {"auth"})
rr:delete("/api/delete/:id", posts.deleteTest, {"auth"})
rr:put("/api/put", posts.putTest)
rr:post("/api/login", posts.Login)

return rr