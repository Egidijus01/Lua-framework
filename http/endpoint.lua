local endpoint = {}

local rr = require("http.routes.routes")

function endpoint:handle_request()
    rr:route()

end


return endpoint
