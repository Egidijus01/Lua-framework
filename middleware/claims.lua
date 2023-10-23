local Users = {}

-- Constructor to create a new instance
function Users:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.users = {
        bla = "token"
    }
    return obj
end

-- Method to add a user and their token
function Users:addUser(username, token)
    self.users[username] = token
end

-- Method to get the token for a specific user
function Users:getToken(username)
    return self.users[username]
end

-- Return the class
return Users








