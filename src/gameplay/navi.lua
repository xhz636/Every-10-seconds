local M = {}

function M:init()
    M.time = 0;
    M.welcome = {
        in_welcome = true,
        image = love.graphics.newImage("resources/image/title.png"),
        hint = love.graphics.newImage("resources/image/anykey.png"),
        hint_curve = function (t)
            return math.sin(t * 5) * 10
        end,
        hint_x = 347,
        hint_y = 405,
    }
    M.level = {
        in_select = false,
        image = love.graphics.newImage("resources/image/level.png"),
        cursor = love.graphics.newImage("resources/image/avatar.png"),
        lock = love.graphics.newImage("resources/image/lock.png"),
        cursor_idx_x = 1,
        cursor_idx_y = 1,
    }
    M.unlock = {
        [1] = true,
    }
end

function M:leave_welcome()
    M.welcome.in_welcome = false
end

function M:enter_select(idx)
    M.level.in_select = true
    M.level.cursor_idx_x = (idx - 1) % 5 + 1
    M.level.cursor_idx_y = math.floor((idx - 1) / 5) + 1
end

function M:leave_select()
    M.level.in_select = false
end

function M:unlock_level(idx)
    M.unlock[idx] = true
end

local level_enter_map = {
    [1] = {230, 450},
    [2] = {476, 450},
    [3] = {722, 450},
    [4] = {968, 450},
    [5] = {1214, 450},
    [6] = {230, 695},
    [7] = {476, 695},
    [8] = {722, 695},
    [9] = {968, 695},
    [10] = {1214, 695},
}

local function get_level_center(idx)
    local pos = level_enter_map[idx]
    return pos[1], pos[2]
end

function M:update(dt)
    M.time  = M.time + dt
end

function M:draw()
    if M.welcome.in_welcome then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(M.welcome.image, 0, 0)
        love.graphics.draw(M.welcome.hint, M.welcome.hint_x, M.welcome.hint_y + M.welcome.hint_curve(M.time))
    end
    if M.level.in_select then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(M.level.image, 0, 0)
        local idx = M.level.cursor_idx_x + (M.level.cursor_idx_y - 1) * 5
        local cursor_x, cursor_y = get_level_center(idx)
        love.graphics.draw(M.level.cursor, cursor_x - 30, cursor_y - 75 - 60)
        for i = 1, 10 do
            if not M.unlock[i] then
                local x, y = get_level_center(i)
                love.graphics.draw(M.level.lock, x - 45, y - 47)
            end
        end
    end
end

function M:keypressed(key)
    if M.welcome.in_welcome then
        M:leave_welcome()
        M:enter_select(1)
        return
    end
    if M.level.in_select then
        if key == "w" then
            M.level.cursor_idx_y = math.max(M.level.cursor_idx_y - 1, 1)
        elseif key == "s" then
            M.level.cursor_idx_y = math.min(M.level.cursor_idx_y + 1, 2)
        elseif key == "a" then
            M.level.cursor_idx_x = math.max(M.level.cursor_idx_x - 1, 1)
        elseif key == "d" then
            M.level.cursor_idx_x = math.min(M.level.cursor_idx_x + 1, 5)
        elseif key == "return" then
            local idx = M.level.cursor_idx_x + (M.level.cursor_idx_y - 1) * 5
            if M.unlock[idx] then
                M:leave_select()
                local game = require("gameplay.game")
                game:start(idx)
            else
                -- todo 一些未解锁的表现
            end
        end
    end
end

return M