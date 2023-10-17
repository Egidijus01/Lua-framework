local Router = {}

function Router:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.routes = {}
    self.name = "john"
    return obj
end

function Router:route()
    -- for i,x in pairs(self.routes) do
    --     print(x.path)
    --     print(x.handler)
    --     end
    
    local request_path = self.env.REQUEST_URI
    print(request_path)
    local request_method = self.env.REQUEST_METHOD

    for _, route in pairs(self.routes) do
        
        if route.path == request_path and route.method == request_method then
          
            return route.handler()
        end
    end

    return "Route not found"
end

function Router:post(path, handler)
    table.insert(self.routes, { path = path, method = "POST", handler = handler })
end

function Router:get(path, handler)
    table.insert(self.routes, { path = path, method = "GET", handler = handler })
end

function Router:delete(path, handler)
    table.insert(self.routes, { path = path, method = "DELETE", handler = handler })
end

function Router:put(path, handler)
    table.insert(self.routes, { path = path, method = "PUT", handler = handler })
end


-- Other functions (e.g., trim_slash) can be defined here

return Router