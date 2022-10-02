local navi = require("gameplay.navi")
local game = require("gameplay.game")

local fps = 0

function love.load()
    navi:init()
    game:init()
end

function love.update(dt)
    -- fps = 1 / dt
    navi:update(dt)
    game:update(dt)
end

function love.draw()
    navi:draw()
    game:draw()
    -- love.graphics.setColor(0, 0, 0)
    -- love.graphics.print(math.ceil(fps), 0, 0)
end

function love.keypressed(key)
    print(key)
    navi:keypressed(key)
    game:keypressed(key)
end