local err = require("utils.responses.error_response")

local settings = require("http.config")
local orm_t = settings.orm



local models

if orm_t.orm == "uci" then
    models = require("orm.uci_orm.field_type")
elseif orm_t.orm == "sql" then
    models = require("orm.sql_orm.tools.fields")
else

    return err.sqlError("Unsupported ORM type: " .. orm_t.orm)
end

return models