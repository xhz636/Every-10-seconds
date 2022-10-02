local M = {}

local vaild_key = {
    w = true,
    s = true,
    a = true,
    d = true,
}

function M:init()
    M.op = nil
end

function M:on_move(key)
    if not vaild_key[key] then
        return false
    end
    M.op = key
    return true
end

function M:get_op()
    local op = M.op
    M.op = nil
    return op
end

function M:reset()
    M.op = nil
end

return M