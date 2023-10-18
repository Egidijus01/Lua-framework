package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"

local endpoint = {}

local response = require("utils.responses.response")
local codes = require("utils.http_codes")
local router = require("framew.router")
local models = require("http.models.posts_models")
local posts = require("http.controllers.posts")
-- local routes = require("http.routes.routes")
-- local status = require("status_codes")
DB = {
    DEBUG = true,
    new = true,
    backtrace = true,
    -- name = "/usr/local/lib/lua/5.1/database.db",
    type = "sqlite3",
}

local User = models.User
local rr = require("http.routes.routes")

-- rr:post("/api/create/:id", posts.handlePostUser)
-- rr:get("/api/get/:id", posts.getSomg)
-- rr:delete("/api/delete/:id", posts.deleteTest)
-- rr:put("/api/put", posts.putTest)

-- local rr = require("http.routes.routes")

function endpoint:handle_request()


    rr:route()

end
return endpoint
