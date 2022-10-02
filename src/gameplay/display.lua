local utils = require("utils")

local M = {}

M.grid_size = 60
M.loading_duration = 1

function M:init(game)
    M.game = game
    M.background_image = love.graphics.newImage("resources/image/background.png")
    M.end_background_image = love.graphics.newImage("resources/image/end_background.png")
    M.avatar_image = love.graphics.newImage("resources/image/avatar.png")
    M.up_image = love.graphics.newImage("resources/image/up.png")
    M.down_image = love.graphics.newImage("resources/image/down.png")
    M.recover_image = love.graphics.newImage("resources/image/recover.png")
    M.flag_image = love.graphics.newImage("resources/image/flag.png")
    -- road
    M.road_dark_image = love.graphics.newImage("resources/image/roaddark.png")
    M.road_dirt_image = love.graphics.newImage("resources/image/roaddirt.png")
    M.road_red_image = love.graphics.newImage("resources/image/roadred.png")
    -- wall
    M.wall_green_image = love.graphics.newImage("resources/image/wallgreen.png")
    -- second
    M.second_images = {}
    for i = 0, 10 do
        M.second_images[i] = love.graphics.newImage("resources/image/second_" .. i .. ".png")
    end
    -- audio
    M.jump_audio = love.audio.newSource("resources/audio/jump.wav", "static")
    M.pick_audio = love.audio.newSource("resources/audio/pick.wav", "static")
    M.fall_audio = love.audio.newSource("resources/audio/fall.wav", "static")
    M.win_audio = love.audio.newSource("resources/audio/win.wav", "static")
    M.timeout_audio = love.audio.newSource("resources/audio/timeout.wav", "static")
end

function M:start_level(data)
    M.map = data.map
    M.p1 = data.p1
    M.p2 = data.p2
    local width = M.map.width * M.grid_size
    local height = M.map.height * M.grid_size
    M.base_x = math.floor((M.background_image:getWidth() - width) / 2)
    M.base_y = math.floor((M.background_image:getHeight() - height) / 2)
    M.title_image = love.graphics.newImage("resources/image/title_" .. data.name .. ".png")
    M.done = true
    M.is_pass = false
    M.loading_time = nil
    M.loaded = false
    M.count_done = false
    M.jump_audio:stop()
    M.pick_audio:stop()
    M.fall_audio:stop()
    M.win_audio:stop()
    M.timeout_audio:stop()
end

function M:draw(time, start_time, count_down)
    love.graphics.setColor(1, 1, 1)
    if M.is_pass and not M.loading_time and not M.loaded then
        M.loading_time = time
    end
    M:draw_background()
    M:draw_title()
    if M.loaded then
        M:draw_falling_player(M.p1, time)
        M:draw_falling_player(M.p2, time)
    end
    M:draw_map(M.map)
    M:draw_item(M.map)
    if M.loaded then
        M:draw_player(M.p1, time)
        M:draw_player(M.p2, time)
    end
    M:draw_second(time, start_time, count_down)
    if not M.loaded then
        M:draw_load_player(M.p1, time)
    end
    if not M.loading_time then
        M.loaded = true
    end
end

function M:draw_background()
    if M.is_pass then
        love.graphics.draw(M.end_background_image, 0, 0)
    else
        love.graphics.draw(M.background_image, 0, 0)
    end
end

function M:draw_title()
    if not M.is_pass then
        love.graphics.draw(M.title_image, (M.background_image:getWidth() - M.title_image:getWidth()) / 2, 10)
    end
end

function M:get_grid_pos(x, y)
    local pos_x = M.base_x + (x - 1) * M.grid_size
    local pos_y = M.base_y + (y - 1) * M.grid_size
    return pos_x, pos_y
end

function M:draw_map(map)
    for y = 1, map.height do
        for x = 1, map.width do
            local object = map.info[(y - 1) * map.width + x]
            local pos_x, pos_y = M:get_grid_pos(x, y)
            if object == " " or object == "@" then
                love.graphics.draw(M.road_dirt_image, pos_x, pos_y)
            elseif object == "#" then
                love.graphics.draw(M.wall_green_image, pos_x, pos_y)
            end
            if object == "@" then
                love.graphics.draw(M.flag_image, pos_x, pos_y)
            end
        end
    end
end

function M:draw_item(map)
    for y = 1, map.height do
        for x = 1, map.width do
            local object = map.item[(y - 1) * map.width + x]
            local pos_x, pos_y = M:get_grid_pos(x, y)
            if object == "2" then
                love.graphics.draw(M.up_image, pos_x, pos_y)
            end
            if object == "0" then
                love.graphics.draw(M.down_image, pos_x, pos_y)
            end
            if object == "1" then
                love.graphics.draw(M.recover_image, pos_x, pos_y)
            end
        end
    end
end

local function get_y_delta(time_scale, height)
    return (time_scale * time_scale - time_scale) / 0.25 * height
end

function M:draw_player(player, time)
    if not player then
        return
    end
    if player.fall_start_time then
        return
    end
    if player.moving_start then
        player.moving_start = nil
        player.moving_time = time
        local old_x, old_y = M:get_grid_pos(player.base_x, player.base_y)
        local new_x, new_y = M:get_grid_pos(player.x, player.y)
        player.old_x = old_x
        player.old_y = old_y
        player.new_x = new_x
        player.new_y = new_y
        M.jump_audio:play()
    end
    -- 0.6s为移动表现时间
    if player.moving_time then
        local delta_time = time - player.moving_time
        if delta_time <= 0.6 then
            M.done = false
            local time_scale = delta_time / 0.6
            -- 移动升高为半个格子
            local y_delta = get_y_delta(time_scale, M.grid_size / 2)
            local x = utils:lerp(player.old_x, player.new_x, time_scale)
            local y = utils:lerp(player.old_y, player.new_y, time_scale) + y_delta
            love.graphics.draw(M.avatar_image, x, y)
            return
        end
    end
    local pos_x, pos_y = M:get_grid_pos(player.x, player.y)
    love.graphics.draw(M.avatar_image, pos_x, pos_y)
    -- 到达目标点了
    local logic = require("gameplay.logic")
    local pick = logic:clear_pending_delete_item()
    if pick then
        M.pick_audio:play()
    end
    if not M.done then
        if M.game.state == M.game.GAME_STATE.WIN then
            M.win_audio:play()
        end
    end
    M.done = true
    if player.falling then
        player.fall_start_time = time
        M.done = false
        M.fall_audio:play()
    end
end

function M:draw_falling_player(player, time)
    if not player or not player.fall_start_time then
        return
    end
    local a = 100
    local t = (time - player.fall_start_time) * 5
    local delta_y = 1 / 2 * a * t * t
    if delta_y > M.background_image:getHeight() then
        M.done = true
        return
    end
    local x, y = M:get_grid_pos(player.x, player.y)
    love.graphics.draw(M.avatar_image, x, y + delta_y)
end

function M:draw_load_player(player, time)
    if not M.loading_time then
        return
    end
    local delta_time = math.min(time - M.loading_time, M.loading_duration)
    local a = 100
    local t = delta_time * 5
    local max_t = M.loading_duration * 5
    local max_y = 1 / 2 * a * max_t * max_t
    local delta_y = 1 / 2 * a * t * t
    local x, y = M:get_grid_pos(player.x, player.y)
    love.graphics.draw(M.avatar_image, x, y - max_y + delta_y)
    if delta_time >= M.loading_duration then
        M.jump_audio:play()
        M.loading_time = nil
    end
end

function M:draw_second(time, start_time, count_down)
    -- 开始移动后进行倒计时
    local base_x = 200
    local base_y = M.background_image:getHeight() / 2
    local scale = 1
    local num = count_down
    if start_time then
        local left_time = count_down - (time - start_time)
        if left_time < 0 then
            left_time = 0
        end
        num = math.ceil(left_time)
        local left_scale = num - left_time
        scale = utils:lerp(1, 0.5, left_scale)
    end
    local image = M.second_images[num]
    local x = base_x - image:getWidth() * scale / 2
    local y = base_y - image:getHeight() * scale / 2
    love.graphics.draw(M.second_images[num], x, y, 0, scale, scale)
    if not M.count_done and M.game.state == M.game.GAME_STATE.TIMEOUT and num == 0 then
        M.count_done = true
        M.timeout_audio:play()
    end
end

function M:is_done()
    return M.done
end

function M:set_is_pass()
    M.is_pass = true
end

function M:is_loading()
    return not M.loaded
end

return M