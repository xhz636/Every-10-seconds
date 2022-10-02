local M = {}

function M:copy_table(table)
    local copy = {}
    for k, v in pairs(table) do
        if type(v) == "table" then
            copy[k] = M:copy_table(v)
        else
            copy[k] = v
        end
    end
    return copy
end

function M:lerp(a, b, delta)
    return a * (1 - delta) + b * delta
end

return M