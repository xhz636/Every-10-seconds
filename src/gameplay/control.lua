local M = {}

local key_map = {
    up = "w",
    down = "s",
    left = "a",
    right = "d",
    w = "w",
    s = "s",
    a = "a",
    d = "d",
}

M.op = nil

function M:on_move(key)
    local k = key_map[key]
    if not k then
        return false
    end
    M.op = k
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