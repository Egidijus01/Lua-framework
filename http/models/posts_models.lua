local models = {}



local Table = require("orm.model")
local fields = require("orm.field_type")

models.User = Table({
    __tablename__ = "user",
    username = fields.CharField({}),
    password = fields.CharField({}),
    age = fields.IntegerField({}),
    job = fields.CharField({}),

})



return models
