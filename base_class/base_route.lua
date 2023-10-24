local resp = require("utils.responses.diff_response")

local Base = {}

function Base:new()
    local obj = {}
    setmetatable(obj, self)
    self.env = {name= "Tester"}
    self.response = resp:new()
    self.__index = self

    return obj
end

return Base