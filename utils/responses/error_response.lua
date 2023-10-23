local M = {}
local response = require("utils.responses.response")
local codes = require("utils.http_codes")

function M.requestError(error)
    return response.send_response(codes.BAD_REQUEST, error)
end

function M.existError(error)
    return response.send_response(codes.NOT_FOUND, error)
end

function M.authError(error)
    return response.send_response(codes.UNAUTHORIZED, error)
end
function M.headerError(error)
    return response.send_response(codes.NOT_FOUND, error)
end
return M