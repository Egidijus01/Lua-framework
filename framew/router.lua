local Router = {}
local errors = require("utils.responses.error_response")
local ResponseClass = require("utils.responses.diff_response")
local RequestClass = require("request.request_class")
local _stack = {}


function Router:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.routes = {}
    self.name = "john"
    return obj
end

local function matchesRoutePath(routePath, requestPath, isRequired)
    local path_without_id = routePath:match("(.-)/{(%w+%??)}$")
    local path_without_last_part = requestPath:gsub('/[^/]+$', '')

    if isRequired then

        return path_without_id == path_without_last_part
    else
        return path_without_id == path_without_last_part or path_without_id==requestPath  or routePath == requestPath
    end
end

local function handleRoute(route, request, response, captures, env)

    if route.options then
        for _, option in pairs(route.options) do
            local mod = require("middleware." .. option)
            local res = mod.init(env)
            
            if not res then
                return errors.authError("Login required")
            end
            
        end
    end

    local id = captures and captures[1] or nil
    if type(route.handler) == "function" then
        route.handler(request, response, id)
    else
        errors.existError("Handler not found")
    end

    return true
end
function Router:route()
    local request_path = self.env.REQUEST_URI:match("([^?]+)")
    local request_method = self.env.REQUEST_METHOD
    local response = ResponseClass:new()
    
    local request = RequestClass:new(self.env.data, self.env.QUERY_STRING, self.env.headers)
 


    for _, route in pairs(self.routes) do
        route.path = string.gsub(route.path, "/$", "")
        local route_pattern = route.path:gsub("{(%w+%??)}", "([%%w_]+)")
        local captures = {request_path:match(route_pattern)}
        local is_required = not route.path:match("{(%w+%?)}")

        if (route.method == request_method) and ((route.path == request_path) or (captures and matchesRoutePath(route.path, request_path, is_required))) then
            
            return handleRoute(route, request, response, captures, self.env) 

        end

    end


    if #_stack > 0 then
        local tabl = _stack[1]
        return tabl[1](tabl[2])
    else
        return errors.existError("ROUTE DOESN'T EXIST")

    end

end








local function get_func(handler, default)
    if type(handler) == "function" then
        return handler
    else
        local pattern = "([^%.]+)%.?(.*)"
        local file_name, func_name = string.match(handler, pattern)

        local prefix = "/www/http/controllers/"
        local f, err = loadfile(prefix .. file_name .. ".lua")

        if func_name == nil or func_name == "" then
            func_name = default
        end

        if not f then
            return nil
        else

            local tabl = f()
            if func_name then

                if tabl[func_name] then
                    return tabl[func_name]
                else
                    return nil
                end
            else
                return nil
            end
        end
    end
end




function Router:post(path, handler, options)
    local func = get_func(handler, "create")
    if func then
        table.insert(self.routes, { path = path, method = "POST", handler = func, options = options })
    else
        table.insert(_stack, {errors.existError, " Method doesnt exist"})
        
    end
end

function Router:get(path, handler, options)
    local func = get_func(handler, "index")


    if func then
        table.insert(self.routes, { path = path, method = "GET", handler = func, options = options })
    else

        table.insert(_stack, {errors.existError, handler .. " Method doesnt exist"})

    end
    
end

function Router:delete(path, handler, options)
    local func = get_func(handler, "destroy")
    if func then
        table.insert(self.routes, { path = path, method = "DELETE", handler = func, options = options })
    else
        table.insert(_stack, {errors.existError, handler .. " Method doesnt exist"})

    end
    
end

function Router:put(path, handler, options)
    local func = get_func(handler, "repair")
    if func then
        table.insert(self.routes, { path = path, method = "PUT", handler = func, options = options })
    else
        table.insert(_stack, {errors.existError, handler .. " Method doesnt exist"})

    end
end


return Router


