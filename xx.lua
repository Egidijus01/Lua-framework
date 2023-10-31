


DB = {
    DEBUG = true,
    new = true,
    backtrace = true,
    name = "database.db",
    type = "sqlite3"
}

local Table = require("orm.model")
local fields = require("orm.tools.fields")

local User = Table({
    __tablename__ = "user",
    username = fields.CharField({max_length = 100, unique = true}),
    password = fields.CharField({max_length = 50, unique = true}),
    age = fields.IntegerField({max_length = 2, null = true}),
    job = fields.CharField({max_length = 50, null = true}),
    time_create = fields.DateTimeField({null = true})
})

local News = Table({
    __tablename__ = "news",
    title = fields.CharField({max_length = 100, unique = false, null = false}),
    text = fields.TextField({null = true}),
    create_user_id = fields.ForeignKey({to = User})
})



local user = User({
    username = "Bob Smith",
    password = "SuperSecretPassword",
    time_create = os.time()
})

user.username = "John Smith"
user:save()



local first_user = User.get:first()
print(first_user.username)
print("--------------------------------")
for i,x in pairs(first_user) do

    print(i,x)
end
print("--------------------------------")
