local models = {}
local err = require("utils.responses.error_response")


local Config = require("orm.model")
local fields = require("orm.field_type")




-- models.User = Config({
--     __tablename__ = "user",
--     username = fields.CharField({max_length = 100, unique = true}),
--     password = fields.CharField({max_length = 50, unique = true}),
--     age = fields.IntegerField({max_length = 2, null = true}),
--     job = fields.CharField({max_length = 50, null = true}),
--     time_create = fields.DateTimeField({null = true})
-- })

-- models.News = Config({
--     __tablename__ = "news",
--     title = fields.CharField({max_length = 100, unique = false, null = false}),
--     text = fields.TextField({null = true}),
--     create_user_id = fields.ForeignKey({to = models.User})
-- })

models.Author = Config({
    __tablename__ = "author",
    name = fields.CharField({max_length = 100, unique = true}),
    last_name = fields.CharField({max_length = 50, unique = true}),
    gender = fields.IntegerField({max_length = 2, null = true}),
    time_create = fields.DateTimeField({null = true}),
    -- create_user_id = fields.ForeignKey({to = models.JoinTable})
})



models.Book = Config({
    __tablename__ = "book",
    title = fields.CharField({max_length = 100, unique = true}),
    genre = fields.CharField({max_length = 50, unique = true}),
    time_create = fields.DateTimeField({null = true})
})

models.JoinTable = Config({
    __tablename__ = "join",
    create_author_id = fields.ForeignKey({to = models.Author}),
    create_book_id = fields.ForeignKey({to = models.Book}),
})
-- models.User = Config({
--     __configname__ = "user",
--     username = fields.Option(),
--     password = fields.Option(),
--     age = fields.Option(),
--     job = fields.Option(),
-- })



return models
