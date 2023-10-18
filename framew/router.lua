local Router = {}
local errors = require("utils.responses.error_response")


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


    for _, route in pairs(self.routes) do
 
        local route_pattern = route.path:gsub("/:id", "/(%%d+)") 
        local captures = {request_path:match(route_pattern)}
        local path_without_id = route.path:match("(.-)/:id$")

        if path_without_id then
        local path_without_last_part = request_path:gsub('/[^/]+$', '')

            if captures and path_without_id == path_without_last_part then
                local id = captures[1]
                print("ID from router:", id)
                print("Handler:", route.handler)
                return route:handler(id)
            end
        elseif route.path == request_path then
            return route.handler()
        end
        
    end

    return errors.existError("ROUTE DOESNT EXIST")
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