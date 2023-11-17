local settings = {}


settings.orm = {
    orm="sql"
}
settings.DB = {
    DEBUG = true,
    new = true,
    backtrace = true,
    name = "database.db",
    type = "sqlite3",
}
settings.assets_dir = "/www/httpd/assets/"

return settings