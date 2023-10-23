local Router = {}
local errors = require("utils.responses.error_response")
-- local auth = require("middleware.auth")

function Router:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.routes = {}
    self.name = "john"
    return obj
end

function Router:route()
    local request_path = self.env.REQUEST_URI
    local request_method = self.env.REQUEST_METHOD



    for _, route in pairs(self.routes) do
        -- print(route.options)
        -- for i,x in pairs(route.options) do
        -- print(i,x)
        -- end
        local route_pattern = route.path:gsub("/:id", "/(%%d+)")
        print(route_pattern)
        local captures = {request_path:match(route_pattern)}
        local path_without_id = route.path:match("(.-)/:id$")
        local options = route.options
        if path_without_id then
        local path_without_last_part = request_path:gsub('/[^/]+$', '')

            if captures and path_without_id == path_without_last_part and route.method == request_method  then
                if options then
                    for _, option in pairs(options) do
                        local mod = require("middleware." .. option)
    
                        local res = mod.init(self.env)
                        print(res)
                        if res then
                            local id = captures[1]
                            return route:handler(id)                
                        end
                        
                    end
                else 
                    local id = captures[1]


                    return route:handler(id)
                end



                
            end
        elseif route.path == request_path and route.method == request_method then


            if options then
                for _, option in pairs(options) do
                    local mod = require("middleware." .. option)

                    local res = mod.init(self.env)
                    print(res)
                    if res then
                        return route.handler()                 
                    end
                    
                end
            else 
                return route.handler()
            end

        end
        
    end

    return errors.existError("ROUTE DOESNT EXIST")
end



function Router:post(path, handler, options)
    table.insert(self.routes, { path = path, method = "POST", handler = handler, options = options })
end

function Router:get(path, handler, options)
    table.insert(self.routes, { path = path, method = "GET", handler = handler, options = options })
end

function Router:delete(path, handler, options)
    table.insert(self.routes, { path = path, method = "DELETE", handler = handler, options = options })
end

function Router:put(path, handler, options)
    table.insert(self.routes, { path = path, method = "PUT", handler = handler, options = options })
end
-- Other functions (e.g., trim_slash) can be defined here

return Router