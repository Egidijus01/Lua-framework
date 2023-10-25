local resp = require("utils.responses.diff_response")

Base = {}

function Base:new()
    local obj = {}
    setmetatable(obj, self)
    self.env = {name= "Tester"}
    self.response = resp:new()
    
    self.__index = self

    return obj
end

function Base:DoStuff() print("Shit it doesn't work") end

return Base