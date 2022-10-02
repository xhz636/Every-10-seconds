local logic = require("gameplay.logic")
local control = require("gameplay.control")
local display = require("gameplay.display")

local M = {}

M.GAME_STATE = {
    PLAYING = 1,
    WIN = 2,
    LOSE = 3,
    TIMEOUT = 4,
    PASS = 5,
}

function M:init()
    M.time = 0
    M.playing = false
    M.cur_level_id = 0
    M.count_down = 0
    M.time_start = nil
    M.time_step = nil
    M.op_step = 0
    M.state = M.GAME_STATE.PLAYING
    logic:init()
    display:init(M)
    control:init()
    M.state_win_image = love.graphics.newImage("resources/image/state_win.png")
    M.state_lose_image = love.graphics.newImage("resources/image/state_lose.png")
    M.state_timeout_image = love.graphics.newImage("resources/image/state_timeout.png")
    M.state_base_x = 1260
    M.state_base_y = 450
end

function M:start(level_id)
    M.playing = true
    M.cur_level_id = level_id
    M.count_down = M.cur_level_id
    M.time_start = nil
    M.time_step = nil
    M.op_step = 0
    M.state = M.GAME_STATE.PLAYING
    logic:start_level(level_id)
    display:start_level(logic.cur_level.data)
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

function M:show_end()
    logic:end_drop()
end

function M:update(dt)
    M.time  = M.time + dt
    if not M.playing then
        return
    end
    if M.state ~= M.GAME_STATE.PLAYING then
        if M.state == M.GAME_STATE.PASS and M.time > M.pass_time + 1.5 then
            M:restart()
            display:set_is_pass()
        end
        return
    end
    -- 开始移动了
    if M.time_step and M.time >= M.time_step then
        local succ = logic:do_op(control:get_op())
        if not succ then
            M.state = M.GAME_STATE.LOSE
            return
        end
        M.op_step = M.op_step + 1
        M.time_step = M.time_step + 1
        if not logic:is_win() then
            if M.op_step >= M.count_down then
                M.state = M.GAME_STATE.TIMEOUT
            end
        else
            M.state = M.GAME_STATE.WIN
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
    display:draw(M.time, M.time_start, M.count_down)
    local state_image = nil
    if M.state == M.GAME_STATE.WIN then
        state_image = M.state_win_image
    end
    if M.state == M.GAME_STATE.LOSE then
        state_image = M.state_lose_image
    end
    if M.state == M.GAME_STATE.TIMEOUT then
        state_image = M.state_timeout_image
    end
    if state_image and display:is_done() then
        love.graphics.setColor(1, 1, 1)
        local x = M.state_base_x - state_image:getWidth() / 2
        local y = M.state_base_y - state_image:getHeight() / 2
        love.graphics.draw(state_image, x, y)
    end
end

function M:keypressed(key)
    if not M.playing or display:is_loading() then
        return
    end
    if key == "escape" then
        M:quit()
        return
    end
    if key == "r" and M.state ~= M.GAME_STATE.WIN and M.state ~= M.GAME_STATE.PASS then
        M:restart()
        return
    end
    if M.state == M.GAME_STATE.WIN then
        if key == "return" then
            if M.cur_level_id < logic.max_level_num then
                local next_level = M.cur_level_id + 1
                M:start(next_level)
            else
                M.state = M.GAME_STATE.PASS
                M.pass_time = M.time
                M.cur_level_id = 1
                M:show_end()
            end
        end
        return
    end
    if M.state == M.GAME_STATE.LOSE then
        return
    end
    if M.state == M.GAME_STATE.PLAYING then
        if control:on_move(key) then
            if not M.time_start then
                M.time_start = M.time
                -- 0.3s缓存输入
                M.time_step = M.time_start + 0.3
            end
        end
    end
end

return M