package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"

local endpoint = {}

local response = require("response")
local codes = require("http_codes")
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


-- rr:post("/api/create", posts.handlePostUser)
-- rr:get("/api/get", posts.getSomg)
-- rr:delete("/api/delete/:id", posts.deleteHandler)
local rr = require("http.routes.routes")

function endpoint:handle_request()


    rr:route()

    response.send_response(404, "Route not found")
end
return endpoint
