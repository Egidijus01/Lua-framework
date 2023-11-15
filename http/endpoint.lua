package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
local endpoint = {}


local models = require("http.models.posts_models")



local rr = require("http.routes.routes")



-- rr:post("/api/create/{?id}", posts.handlePostUser)
-- rr:get("/api/get/:id", posts.getSomg)
-- rr:delete("/api/delete/:id", posts.deleteTest)
-- rr:put("/api/put", posts.putTest)

-- local rr = require("http.routes.routes")



function endpoint:handle_request()
    rr:route()

end


return endpoint
