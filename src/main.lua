local logic = require("gameplay.logic")
local control = require("gameplay.control")
local display = require("gameplay.display")

local time_info = 0
local cur_level_id = 1
local count_down = 0

local time_start = nil
local time_step = nil
local op_step = 0
local win = false
local lose = false
local pass = false

local function game_pause()
    return win or lose or pass
end

local function restart()
    time_start = nil
    time_step = nil
    op_step = 0
    win = false
    lose = false
    pass = false
    control:reset()
    logic:start_level(cur_level_id)
    count_down = math.min(cur_level_id, 10)
end

function love.load()
    logic:init()
    restart()
end

function love.update(dt)
    time_info = time_info + dt
    if game_pause() then
        return
    end
    if time_step and time_info >= time_step then
        local succ = logic:do_op(control:get_op())
        if not succ then
            lose = true
            return
        end
        op_step = op_step + 1
        time_step = time_step + 1
        if not logic:is_win() then
            if op_step >= count_down then
                lose = true
            end
        else
            win = true
        end
    end
end

function love.draw()
    display:draw(logic.cur_level.data)
    if win then
        love.graphics.setColor(1, 1, 0)
        love.graphics.print("win! press Enter to next level", 0, 0)
    end
    if lose then
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("lose! press R to restart", 0, 0)
    end
    if pass then
        love.graphics.setColor(1, 1, 0)
        love.graphics.print("pass! thank you for playing", 0, 0)
    end
    if time_start then
        local left_time = count_down - (time_info - time_start)
        if left_time >= 0 then
            love.graphics.setColor(1, 0, 0)
            love.graphics.print(math.ceil(left_time), 0, 30)
        else
            love.graphics.setColor(1, 0, 0)
            love.graphics.print(0, 0, 30)
        end
    end
end

function love.keypressed(key)
    if key == "r" then
        restart()
    end
    if win then
        if key == "return" then
            cur_level_id = cur_level_id + 1
            if cur_level_id <= logic.max_level_num then
                restart()
            else
                win = false
                lose = false
                pass = true
            end
        end
        return
    end
    if lose then
        return
    end
    if control:on_move(key) then
        if not time_start then
            time_start = time_info
            time_step = time_start + 0.3
        end
    end
end