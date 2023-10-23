local Router = {}
local errors = require("utils.responses.error_response")
-- local auth = require("middleware.auth")
local RequestClass = require("request.request_class")

function Router:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.routes = {}
    self.name = "john"
    return obj
end

function Router:route()
    local request = RequestClass:new(self.env.data, self.env.QUERY_STRING, self.env.headers)


    
    local request_path = self.env.REQUEST_URI:match("([^?]+)")
    local request_method = self.env.REQUEST_METHOD
    

    for _, route in pairs(self.routes) do

        local route_pattern = route.path:gsub("/{(%w+[%??])}", "/(%%d*)")
   
        local captures = {request_path:match(route_pattern)}

        local path_without_id = route.path:match("(.-)/{(%w+[%??])}$")
        local is_required = not route.path:match("{(%w+%?)")
        local options = route.options

        if path_without_id then

            if is_required then
                local path_without_last_part = request_path:gsub('/[^/]+$', '')
                
                if captures and path_without_id == path_without_last_part and route.method == request_method then
                    if options then
                        for _, option in pairs(options) do
                            local mod = require("middleware." .. option)
                            local res = mod.init(self.env)

                            if res then
                                local id = captures[1]
                                return route:handler(self.env,id)
                            end
                        end
                    else
                        local id = captures[1]
                        return route:handler(self.env, id)
                    end
                end
            elseif is_required == false then
                if path_without_id == request_path and route.method == request_method then
                    if options then
                        for _, option in pairs(options) do
                            local mod = require("middleware." .. option)
                            local res = mod.init(request)

                            if res then
                                local id = nil
                                return route:handler(request, id)
                            end
                        end
                    else
                        local id = captures[1]
                        return route:handler(request, id)
                    end
                end
            end
        
        elseif route.path == request_path and route.method == request_method then


            if options then
                for _, option in pairs(options) do
                    local mod = require("middleware." .. option)

                    local res = mod.init(self.env)
                    print(res)
                    if res then
                        return route:handler(request)                 
                    end
                    
                end
            else 
                return route:handler(request)
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