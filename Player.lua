local Bullet = require 'Bullet'

local Player = Class {}

function Player:init(x, y, speed, spriteSheetPath, gridWidth, gridHeight, frameDuration)
    self.x = x
    self.y = y
    self.speed = speed
    self.spriteSheet = love.graphics.newImage(spriteSheetPath)
    self.grid = anim8.newGrid(gridWidth, gridHeight, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.animations = {
        down = anim8.newAnimation(self.grid('1-4', 1), frameDuration),
        left = anim8.newAnimation(self.grid('1-4', 1), frameDuration),
        right = anim8.newAnimation(self.grid('1-4', 1), frameDuration),
        up = anim8.newAnimation(self.grid('1-4', 1), frameDuration),
    }
    self.anim = self.animations.left

    self.bullets = {}
    self.shootTimer = 0
    self.shootDelay = 0.3
end

function Player:update(dt)
    local isMoving = false

    if love.keyboard.isDown("d") then
        self.x = self.x + self.speed
        self.anim = self.animations.right
        isMoving = true
    end

    if love.keyboard.isDown("a") then
        self.x = self.x - self.speed
        self.anim = self.animations.left
        isMoving = true
    end

    if love.keyboard.isDown("s") then
        self.y = self.y + self.speed
        self.anim = self.animations.down
        isMoving = true
    end

    if love.keyboard.isDown("w") then
        self.y = self.y - self.speed
        self.anim = self.animations.up
        isMoving = true
    end

    if not isMoving then
        self.anim:gotoFrame(1)
    end

    self.anim:update(dt)

    self.shootTimer = self.shootTimer + dt

    if love.keyboard.isDown("space") and self.shootTimer >= self.shootDelay then
        self:shoot('up', 500)
        self.shootTimer = 0
    end

    for _, bullet in ipairs(self.bullets) do
        bullet:update(dt)

        if bullet.y < 0 then
            table.remove(self.bullets, _)
        end
    end
end

function Player:draw()
    self.anim:draw(self.spriteSheet, self.x, self.y, nil, 1)

    for _, bullet in ipairs(self.bullets) do
        bullet:draw()
    end
end

function Player:shoot(direction, speed)
    local bullet = Bullet(self.x + 25, self.y + 30, speed, direction)
    table.insert(self.bullets, bullet)
end

return Player
