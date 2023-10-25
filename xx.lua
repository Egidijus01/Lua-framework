

local f,err = loadfile("/www/cgi-bin/http/controllers/posts.lua")
    if not f then
        print("Error loading file: " .. err)
    
       
    end
local tabl = f()
tabl["index"]()
-- for i,x in pairs(tabl) do

--     print(i,x)
-- end 
