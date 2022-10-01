local utils = require("utils")

local M = {}

M.max_level_num = 8
M.cur_level = nil
M.levels = {}

local MOVE_STATE = {
    PENDING = 1,
    DONE = 2,
    FAIL = 3,
}

function M:init()
    for i = 1, M.max_level_num do
        M.levels[i] = require("gameplay.level.level" .. i)
    end
end

function M:start_level(level_idx)
    local level = M.levels[level_idx]
    M.cur_level = utils:copy_table(level)
end

function M:get_cur_level()
    return M.cur_level
end

local function move_init(player)
    if not player then
        return
    end
    player.base_x = player.x
    player.base_y = player.y
    player.state = MOVE_STATE.PENDING
end

local function move_player(map, player, op, other)
    if not player then
        return MOVE_STATE.DONE
    end
    local speed = player.speed or 2
    local base_x = player.base_x
    local base_y = player.base_y
    if op == "w" then
        for y = player.y - 1, base_y - speed, -1 do
            if y <= 0 or y > map.height then
                return MOVE_STATE.FAIL
            end
            local object = map.info[(y - 1) * map.width + base_x]
            if object == "#" then
                return MOVE_STATE.DONE
            end
            if other then
                if other.x == player.x and other.y == y then
                    if other.state ~= MOVE_STATE.PENDING then
                        return MOVE_STATE.DONE
                    else
                        return MOVE_STATE.PENDING
                    end
                end
            end
            player.y = y
        end
    elseif op == "s" then
        for y = player.y + 1, base_y + speed, 1 do
            if y <= 0 or y > map.height then
                return MOVE_STATE.FAIL
            end
            local object = map.info[(y - 1) * map.width + base_x]
            if object == "#" then
                return MOVE_STATE.DONE
            end
            if other then
                if other.x == player.x and other.y == y then
                    if other.state ~= MOVE_STATE.PENDING then
                        return MOVE_STATE.DONE
                    else
                        return MOVE_STATE.PENDING
                    end
                end
            end
            player.y = y
        end
    elseif op == "a" then
        for x = player.x - 1, base_x - speed, -1 do
            if x <= 0 or x > map.width then
                return MOVE_STATE.FAIL
            end
            local object = map.info[(base_y - 1) * map.width + x]
            if object == "#" then
                return MOVE_STATE.DONE
            end
            if other then
                if other.x == x and other.y == player.y then
                    if other.state ~= MOVE_STATE.PENDING then
                        return MOVE_STATE.DONE
                    else
                        return MOVE_STATE.PENDING
                    end
                end
            end
            player.x = x
        end
    elseif op == "d" then
        for x = player.x + 1, base_x + speed, 1 do
            if x <= 0 or x > map.width then
                return MOVE_STATE.FAIL
            end
            local object = map.info[(base_y - 1) * map.width + x]
            if object == "#" then
                return MOVE_STATE.DONE
            end
            if other then
                if other.x == x and other.y == player.y then
                    if other.state ~= MOVE_STATE.PENDING then
                        return MOVE_STATE.DONE
                    else
                        return MOVE_STATE.PENDING
                    end
                end
            end
            player.x = x
        end
    end
    return MOVE_STATE.DONE
end

local function handle_item(items, player)
    if not items then
        return
    end
    for i, item in ipairs(items) do
        if item.x == player.x and item.y == player.y then
            if item.name == "*2" then
                player.speed = 4
            elseif item.name == "/2" then
                player.speed = 1
            elseif item.name == "=1" then
                player.speed = 2
            end
            table.remove(items, i)
            break
        end
    end
end

local function in_point(map, player)
    if not player then
        return true
    end
    local object = map.info[(player.y - 1) * map.width + player.x]
    return object == "@"
end

function M:do_op(op)
    local level = M.cur_level
    op = op or level.data.last_op
    level.data.last_op = op
    local map = level.data.map
    local p1 = level.data.p1
    local p2 = level.data.p2
    move_init(p1)
    move_init(p2)
    p1.state = move_player(map, p1, op, p2)
    print(p1.name, p1.x, p1.y)
    if p2 then
        p2.state = move_player(map, p2, op, p1)
        print(p2.name, p2.x, p2.y)
    end
    while p1.state ~= MOVE_STATE.DONE or (p2 and p2.state ~= MOVE_STATE.DONE) do
        if p1.state == MOVE_STATE.FAIL or p2.state == MOVE_STATE.FAIL then
            return false
        end
        if p1.state == MOVE_STATE.PENDING then
            p1.state = move_player(map, p1, op, p2)
            print(p1.name, p1.x, p1.y)
        end
        if p2.state == MOVE_STATE.PENDING then
            p2.state = move_player(map, p2, op, p1)
            print(p2.name, p2.x, p2.y)
        end
    end
    handle_item(level.data.items, p1)
    handle_item(level.data.items, p2)
    return true
end

function M:is_win()
    local level = M.cur_level
    local succ1 = in_point(level.data.map, level.data.p1)
    local succ2 = in_point(level.data.map, level.data.p2)
    if not succ1 or not succ2 then
        return false
    end
    return true
end

return M