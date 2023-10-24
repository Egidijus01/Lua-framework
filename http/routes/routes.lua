local postss = require("http.controllers.posts")
local router = require("framew.router")


local posts = postss:new()
print(type(posts.index))
local rr = router:new()
rr:post("/api/create/{id?}", posts.handlePostUser)
rr:get("/api/get/", posts.getSomg)
rr:post("/api/get", posts.getSomg)
rr:delete("/api/delete/{id?}", posts.deleteTest, {"auth"})
rr:put("/api/put", posts.putTest, {"auth"})
rr:post("/api/login", posts.Login)

-- rr:get('/api/cars', 'cars')

return rr