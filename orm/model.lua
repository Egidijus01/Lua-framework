local err = require("utils.responses.error_response")

local settings = require("http.config")
local orm_t = settings.orm


local models

if orm_t.orm == "uci" then
    models = require("orm.uci_orm.model")
elseif orm_t.orm == "sql" then
    models = require("orm.sql_orm.model")
else
 
    return nil

end

return models