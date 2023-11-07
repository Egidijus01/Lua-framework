------------------------------------------------------------------------------
--                                  Libs                                   --
------------------------------------------------------------------------------

Type = require('orm.type')
Field = require('orm.fields')



------------------------------------------------------------------------------
--                                Field Types                               --
------------------------------------------------------------------------------
local function save_as_str(str)
    return "'" .. str .. "'"
end

local field = {}

-- The "Field" class will be used to search a table index that the "field" class doesn't have.
-- This way field:register() will call the same function like Field:register() and the register
-- function has access to the default values for the field configuration.
setmetatable(field, {__index = Field});


field.PrimaryField = Field:register({
    __type__ = "integer",
    validator = Type.is.int,
    settings = {
        null = true,
        primary_key = true,
        auto_increment = true
    },
    to_type = Type.to.number
})



field.Option = Field:register()

field.List = Field:register()



return field