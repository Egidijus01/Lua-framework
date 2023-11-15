local models = {}



local Config = require("orm.model")
local fields = require("orm.field_type")

DB = {
    DEBUG = true,
    new = true,
    backtrace = true,
    name = "database.db",
    type = "sqlite3",
}

models.User = Config({
    __tablename__ = "user",
    username = fields.CharField({max_length = 100, unique = true}),
    password = fields.CharField({max_length = 50, unique = true}),
    age = fields.IntegerField({max_length = 2, null = true}),
    job = fields.CharField({max_length = 50, null = true}),
    time_create = fields.DateTimeField({null = true})
})

-- models.User = Config({
--     __configname__ = "user",
--     username = fields.Option(),
--     password = fields.Option(),
--     age = fields.Option(),
--     job = fields.Option(),
-- })



return models
