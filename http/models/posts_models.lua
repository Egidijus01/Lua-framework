local models = {}
local err = require("utils.responses.error_response")


local Config = require("orm.model")
local fields = require("orm.field_type")




models.User = Config({
    __tablename__ = "user",
    username = fields.CharField({max_length = 100, unique = true}),
    password = fields.CharField({max_length = 50, unique = true}),
    age = fields.IntegerField({max_length = 2, null = true}),
    job = fields.CharField({max_length = 50, null = true}),
    time_create = fields.DateTimeField({null = true})
})

models.Author = Config({
    __tablename__ = "author",
    name = fields.CharField({max_length = 100, unique = true}),
    last_name = fields.CharField({max_length = 50, unique = true}),
    gender = fields.IntegerField({max_length = 2, null = true}),
    time_create = fields.DateTimeField({null = true}),
    create_user_id = fields.ForeignKey({to = models.User})


})

-- models.JoinTable = Config({
--     __tablename__ = "join",
--     author_id = fields.ForeignKey({to=models.Author}),
--     book_id = fields.ForeignKey({to=models.Book}),
-- })

models.Book = Config({
    __tablename__ = "book",
    authors = fields.ForeignKey({to=models.JoinTable}),
    title = fields.CharField({max_length = 100, unique = true}),
    genre = fields.CharField({max_length = 50, unique = true}),
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
