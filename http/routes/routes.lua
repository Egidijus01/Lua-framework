
local M = {}

local posts = require("handlers.post")
local router = require("framew.router")
M.rout = router:new()

M.rout:post("/api/create", posts.handlePostUser)
M.rout:get("/api/get", posts.getSomg)

return M