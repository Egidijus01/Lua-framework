-- local Config = require("orm.model")
-- local fields = require("orm.field_type")

-- local User = Config({
--     __tablename__ = "user",
--     username = fields.CharField({max_length = 100, unique = true}),
--     password = fields.CharField({max_length = 50, unique = true}),
--     age = fields.IntegerField({max_length = 2, null = true}),
--     job = fields.CharField({max_length = 50, null = true}),
--     time_create = fields.DateTimeField({null = true})
-- })
-- local Kazkas = Config({
--     __tablename__ = "news",
--     title = fields.CharField({max_length = 100, unique = false, null = false}),
--     text = fields.TextField({null = true}),
-- })

-- local News = Config({
--     __tablename__ = "news",
--     title = fields.CharField({max_length = 100, unique = false, null = false}),
--     text = fields.TextField({null = true}),
--     create_user_id = fields.ForeignKey({to = User})
-- })

-- function mysplit (inputstr, sep)
--     if sep == nil then
--             sep = "%s"
--     end
--     local t={}
--     for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
--             table.insert(t, str)
--     end
--     return t
-- end
-- local str = "kazkas"; filename="Screenshot from 2023-11-16 15-43-33.png"

-- ss = mysplit(str, '"')
-- for i,x in pairs(ss) do
--     print(i,x)
-- end
local Multipart = require("multipart")