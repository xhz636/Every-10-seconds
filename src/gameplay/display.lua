local M = {}

M.grid_size = 32
M.grid_draw_size = 30

function M:draw(data)
    M:draw_background()
    M:draw_map(data.map)
    M:draw_item(data.items)
    M:draw_player(data.p1)
    M:draw_player(data.p2)
end

function M:draw_background()
end

function M:draw_map(map)
    for j = 1, map.height do
        for i = 1, map.width do
            local object = map.info[(j - 1) * map.width + i]
            if object == " " or object == "@" then
                love.graphics.setColor(0.5, 0.5, 0.5)
                love.graphics.rectangle("fill", i * M.grid_size, j * M.grid_size, M.grid_draw_size, M.grid_draw_size, 5, 5)
            elseif object == "#" then
                love.graphics.setColor(0.8, 0.5, 0.2)
                love.graphics.rectangle("fill", i * M.grid_size, j * M.grid_size, M.grid_draw_size, M.grid_draw_size, 5, 5)
            end
            if object == "@" then
                love.graphics.setColor(0.8, 0.8, 0.2)
                love.graphics.rectangle("fill", i * M.grid_size, j * M.grid_size, M.grid_draw_size, M.grid_draw_size, 5, 5)
            end
        end
    end
end

function M:draw_item(items)
    if not items then
        return
    end
    for i, item in ipairs(items) do
        if item.name == "*2" then
            love.graphics.setColor(0.9, 0.2, 0.2)
            love.graphics.print("*2", item.x * M.grid_size, item.y * M.grid_size)
        end
        if item.name == "/2" then
            love.graphics.setColor(0.9, 0.2, 0.2)
            love.graphics.print("/2", item.x * M.grid_size, item.y * M.grid_size)
        end
        if item.name == "=1" then
            love.graphics.setColor(0.9, 0.2, 0.2)
            love.graphics.print("=1", item.x * M.grid_size, item.y * M.grid_size)
        end
    end
end

function M:draw_player(player)
    if not player then
        return
    end
    love.graphics.setColor(0.7, 0.7, 0.5)
    love.graphics.circle("fill", player.x * M.grid_size + M.grid_size / 2, player.y * M.grid_size + M.grid_size / 2, M.grid_draw_size / 2)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(player.name, player.x * M.grid_size + M.grid_size / 4, player.y * M.grid_size + M.grid_size / 4)
end

return M