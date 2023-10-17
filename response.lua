local cjson = require("cjson")

M = {}

function M.send_response(status, response)
    uhttpd.send("Status: " .. status .. " \r\n")
    uhttpd.send("Content-Type: application/json\r\n\r\n")
    uhttpd.send(cjson.encode({status_code = status, response = response}))
end

function M.send_response_json(status ,response)
    uhttpd.send("Status: ", status ," \r\n")
    uhttpd.send("Content-Type: application/json\r\n\r\n")

    setmetatable(response, cjson.array_mt)

    uhttpd.send(cjson.encode(response))
end


return M