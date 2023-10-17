local Base = {}

function Base:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.name = "David"
    return obj
end

return Base