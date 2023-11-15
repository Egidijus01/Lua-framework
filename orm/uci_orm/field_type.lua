------------------------------------------------------------------------------
--                                  Libs                                   --
------------------------------------------------------------------------------


Field = require('orm.uci_orm.fields')





local field = {}

setmetatable(field, {__index = Field});




field.Option = Field:register()

field.List = Field:register()



return field