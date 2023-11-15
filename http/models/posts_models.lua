local models = {}



local Config = require("orm.model")
local fields = require("orm.field_type")

models.User = Config({
    __configname__ = "user",
    username = fields.Option(),
    password = fields.Option(),
    age = fields.Option(),
    job = fields.Option(),
})



return models
