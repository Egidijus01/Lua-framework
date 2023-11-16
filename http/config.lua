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
return settings