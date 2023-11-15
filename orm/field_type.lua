local uci = require("uci")

local x = uci:cursor()

local type = x:get("framework", "orm", "type")

local models

if type == "uci" then
    models = require("orm.uci_orm.field_type")
elseif type == "sql" then
    models = require("orm.sql_orm.tools.fields")
else
    -- Handle unsupported ORM type or other cases
    error("Unsupported ORM type: " .. type)
end

return models