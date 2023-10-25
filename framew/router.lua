local Router = {}
local errors = require("utils.responses.error_response")
local ResponseClass = require("utils.responses.diff_response")
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


local function checkOptions(options)
    
end



function Router:route()
    local request = RequestClass:new(self.env.data, self.env.QUERY_STRING, self.env.headers)
    local request_path = self.env.REQUEST_URI:match("([^?]+)")
    local request_method = self.env.REQUEST_METHOD
    local response = ResponseClass:new()


    for _, route in pairs(self.routes) do

        local route_pattern = route.path:gsub("{(%w+)}", "([%%d]*)"):gsub("{(%w+%?)}", "([%%d]*)")
        local captures = {request_path:match(route_pattern)}
        local path_without_id = route.path:match("(.-)/{(%w+%??)}$")
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
                                return route:handler(request, response, id)
                            end
                        end
                    else
                        local id = captures[1]
                        return route:handler(request, response, id)
                    end
                end
            elseif is_required == false then

                local path_without_last_part = request_path:gsub("/%d+", "")

                if path_without_id == path_without_last_part and route.method == request_method then

                    if options then
                        for _, option in pairs(options) do
                            local mod = require("middleware." .. option)
                            local res = mod.init(request)

                            if res then
                                local id = nil
                                if type(route.handler) == "function" then                                    
                                    return route:handler(request, response, id)
                                else
                                    return errors.existError("Handler not found")
                                end
                            else 
                                return errors.authError("Invalid Authorization header")   
                            end
                        end
                    else
                        local id = captures[1]
                        if type(route.handler) == "function" then                                    
                            return route:handler(request, response, id)
                        else
                            return errors.existError("Handler not found")
                        end
                    end
                end
            end
        
        elseif route.path == request_path and route.method == request_method then

            
            if options then
                for _, option in pairs(options) do
                    local mod = require("middleware." .. option)

                    local res = mod.init(self.env)
                    if res then
                        if type(route.handler) == "function" then                                    
                            return route:handler(request, response)
                        else
                            return errors.existError("Handler not found")
                        end
                    else 
                        return errors.authError("Invalid Authorization header")               
                    end
                   
                end
            else 
                if type(route.handler) == "function" then
                    return route:handler(request, response)
                    -- return route:handler(request)
                else
                    return errors.existError("Handler not found")
                end
            end
        
        
        end
    
    end
    return errors.existError("ROUTE DOESNT EXIST")


end



local function get_func(handler)
    local pattern = "(.-)%.(.*)"
    local file_name, func_name = string.match(handler, pattern)
    local prefix = "/www/cgi-bin/http/controllers/"
    local f, err = loadfile (prefix .. file_name ..".lua")
   
    if not f then
        return nil
    else
        local tabl = f()

        return tabl[func_name]
    end
    

end


function Router:post(path, handler, options)
    local func = get_func(handler)
    table.insert(self.routes, { path = path, method = "POST", handler = func, options = options })
    
end

function Router:get(path, handler, options)

    local func = get_func(handler)
    table.insert(self.routes, { path = path, method = "GET", handler = func, options = options })
    
end

function Router:delete(path, handler, options)
    local func = get_func(handler)
    table.insert(self.routes, { path = path, method = "DELETE", handler = func, options = options })
    
end

function Router:put(path, handler, options)
    local func = get_func(handler)
    table.insert(self.routes, { path = path, method = "PUT", handler = func, options = options })
    
end
-- Other functions (e.g., trim_slash) can be defined here

return Router


