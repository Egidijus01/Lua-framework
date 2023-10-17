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
local rr = router:new()

rr:post("/api/create", posts.handlePostUser)
rr:get("/api/get", posts.getSomg)
rr:delete("/api/delete/:id", posts.deleteHandler)



-- local post_funcs = require("handlers.post")
function endpoint:handle_request()
    -- print(rr.routes)



    -- local path = self.env.REQUEST_URI:match("([^?]+)")
    -- local method = self.env.REQUEST_METHOD
    -- print(path)
    -- router.route()
    print(self.env.REQUEST_URI)

    local request_path = self.env.REQUEST_URI:match("(/[^:]+)"):gsub("/$", "")

    print(request_path)



    print("-----------------------------------")
    for i,x in pairs(self.env) do
    print(i,x)
    end
    rr:route()

    response.send_response(404, "Route not found")
end

--     if path == "/api/response1" and self.env.REQUEST_METHOD == "GET" then
--         print(models)
--         for modelName, model in pairs(models) do
--             print("Model Name:", modelName)
--             for propertyName, propertyType in pairs(model) do
--                 print("  Property:", propertyName, "Type:", propertyType)
--             end
--         end
--         self.send("OK")
	
--     elseif path == "/api/endpoint"and self.env.REQUEST_METHOD == "GET" then
--         local Sample = require("handlers.post")
     
--         Sample:handlePostUser()
--         -- print(self.request.name)
--         -- response.send_response(200,"OK")
    
    

--     elseif self.env.REQUEST_URI == "/api/post1" and self.env.REQUEST_METHOD == "POST" then


--         local queryString = self.env.QUERY_STRING or ""
--         local loadParameter = queryString:match("load=([^&]+)")
--         print(loadParameter)
--         if loadParameter then
--             local handler = require("./handlers/post")
--             handler.post_handler(loadParameter) -- Pass the "load" parameter to the post_handler function
--             self.send("OK")
--         end
--         self.send("200" ,"fffff")

    
--     elseif path == "/api/delete" and self.env.REQUEST_METHOD == "DELETE" then


        
--         local id = self.params.id
--         local useris = User.get:where({id=id}):first()

--         useris:delete()
    


      
--         response.send_response(200,"deleted")


--     elseif path == "/api/get" and self.env.REQUEST_METHOD == "GET" then
        
--         local users = User.get:all()
--         print("We get " .. users:count() .. " users")
--         -- We get 5 users
   

--         self.send_respose(200,"Success")



--     elseif path == "/api/put" and self.env.REQUEST_METHOD == "PUT" then
--         local id = self.params.id
--         local user = User.get:where({id=id}):first()
--         user.username = "Other name"
--         user:save()
        
--         self.send("Updated")


--     elseif path == "/api/create" and self.env.REQUEST_METHOD == "POST" then
--         local model_handler = require("model_handler")


--         local user = User({
--             username = self.request.username,
--             password = self.request.password,
--             time_create = os.time()
--         })
        
--         user:save()

        
--         -- for i, x in pairs(user._data) do
--         -- print(i,x)
--         -- end
--         response.send_response(codes.CREATED, "user")



    
--     elseif path == "/api/test" and self.env.REQUEST_METHOD == "GET" then
--         local function t2s(o)
--             if type(o) == 'table' then
--                     local s = '{ '
--                     for k,v in pairs(o) do
--                             if type(k) ~= 'number' then k = '"'..k..'"' end
--                             s = s .. '['..k..'] = ' .. t2s(v) .. ','
--                     end
    
--                     return s .. '} '
--             else
--                     return tostring(o)
--             end
--     end
    
--     -- 
--         local jwt = require("middleware.jwt_authorization")
        
--         local key = "example_key"
        
--         local claim = {
--             iss = "12345678",
--             nbf = os.time(),
--             exp = os.time() + 3600,
--         }
        
--         local alg = "HS256" -- default alg
--         local token, err = jwt.encode(claim, key, alg)
        
--         print("Token:", token)
--         local jwt = require("middleware.jwt_authorization")
        
--         local key = "example_key"
        
--         local claim = {
--             iss = "12345678",
--             nbf = os.time(),
--             exp = os.time() + 3600,
--         }
        
--         local alg = "HS256" -- default alg
--         local token, err = jwt.encode(claim, key, alg)
        
--         print("Token:", token)
--     else
      
--         response.send_response(404,"error")
--     end


-- end


return endpoint
