local logic = require("gameplay.logic")
local control = require("gameplay.control")
local display = require("gameplay.display")

local M = {}

local GAME_STATE = {
    PLAYING = 1,
    WIN = 2,
    LOSE = 3,
    PASS = 4,
}

function M:init()
    M.time = 0
    M.playing = false
    M.cur_level_id = 0
    M.count_down = 0
    M.time_start = nil
    M.time_step = nil
    M.op_step = 0
    M.state = GAME_STATE.PLAYING
    logic:init()
    display:init()
    control:init()
end

function M:start(level_id)
    M.playing = true
    M.cur_level_id = level_id
    M.count_down = M.cur_level_id
    M.time_start = nil
    M.time_step = nil
    M.op_step = 0
    M.state = GAME_STATE.PLAYING
    logic:start_level(level_id)
    control:reset()
end

function M:restart()
    M:start(M.cur_level_id)
end

function M:quit()
    M.playing = false
    local navi = require("gameplay.navi")
    navi:enter_select(M.cur_level_id)
end

function M:update(dt)
    M.time  = M.time + dt
    if not M.playing then
        return
    end
    if M.state ~= GAME_STATE.PLAYING then
        return
    end
    -- 开始移动了
    if M.time_step and M.time >= M.time_step then
        local succ = logic:do_op(control:get_op())
        if not succ then
            M.state = GAME_STATE.LOSE
            return
        end
        M.op_step = M.op_step + 1
        M.time_step = M.time_step + 1
        if not logic:is_win() then
            if M.op_step >= M.count_down then
                M.state = GAME_STATE.LOSE
            end
        else
            M.state = GAME_STATE.WIN
            if M.cur_level_id < logic.max_level_num then
                local next_level = M.cur_level_id + 1
                local navi = require("gameplay.navi")
                navi:unlock_level(next_level)
            end
        end
    end
end

function M:draw()
    if not M.playing then
        return
    end
    display:draw(logic.cur_level.data)
    if M.state == GAME_STATE.WIN then
        love.graphics.setColor(1, 1, 0)
        love.graphics.print("win! press Enter to next level", 0, 0)
    end
    if M.state == GAME_STATE.LOSE then
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("lose! press R to restart", 0, 0)
    end
    if M.state == GAME_STATE.PASS then
        love.graphics.setColor(1, 1, 0)
        love.graphics.print("pass! thank you for playing", 0, 0)
    end
    -- 开始移动后进行倒计时
    if M.time_start then
        local left_time = M.count_down - (M.time - M.time_start)
        if left_time >= 0 then
            love.graphics.setColor(1, 0, 0)
            love.graphics.print(math.ceil(left_time), 0, 30)
        else
            love.graphics.setColor(1, 0, 0)
            love.graphics.print(0, 0, 30)
        end
    end
end

function M:keypressed(key)
    if not M.playing then
        return
    end
    if key == "escape" then
        M:quit()
        return
    end
    if key == "r" then
        M:restart()
        return
    end
    if M.state == GAME_STATE.WIN then
        if key == "return" then
            if M.cur_level_id < logic.max_level_num then
                local next_level = M.cur_level_id + 1
                M:start(next_level)
            else
                M.state = GAME_STATE.PASS
            end
        end
        return
    end
    if M.state == GAME_STATE.LOSE then
        return
    end
    if control:on_move(key) then
        if not M.time_start then
            M.time_start = M.time
            M.time_step = M.time_start + 0.3
        end
    end
end

return M