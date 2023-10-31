
local router = require("framew.router")

local rr = router:new()
rr:post("/api/create/{id}", "posts.handlePostUser")
rr:get("/api/get", "posts.getSomg")

rr:delete("/api/delete/{id}", "posts.deleteTest")
rr:put("/api/put", "posts.putTest", {"auth"})
rr:post("/api/login", "posts.Login")

-- rr:get('/api/cars', 'cars')

return rr