anim8 = require 'libraries/anim8'
Bullet = require 'Bullet'
Timer = require 'timer'

enemy = Class {}

function enemy:init(x, y, speed)
    self.x = x
    self.y = y
    self.speed = speed

    self.spriteSheet = love.graphics.newImage('sprites/burger-Sheet.png')

    self.grid = anim8.newGrid(62, 76, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.animationMoving = anim8.newAnimation(self.grid('1-4', 1), 0.19)
    self.animationMoving:gotoFrame(1)

    self.animationStopped = anim8.newAnimation(self.grid('1-1', 1), 0.19)
    self.animationStopped:gotoFrame(1)

    self.grid2 = anim8.newGrid(62, 76, self.spriteSheet:getWidth(), self.spriteSheet:getHeight(), 0, 76)
    self.secondAnimation = anim8.newAnimation(self.grid2('1-3', 1), 0.19)
    self.secondAnimation:gotoFrame(1)

    self.moveTimer = 0
    self.moveDuration = love.math.random(2.0, 5.0)
    self.stoppedTimer = 0
    self.stoppedDuration = 0.56

    self.velocity = { x = 0, y = 0 }
    self.secondAnimationPlayed = false

    self.bullets = {}

    self:startMoving()
end

function enemy:startMoving()
    local angle = love.math.random() * 2 * math.pi
    self.velocity.x = math.cos(angle) * (self.speed + 150)
    self.velocity.y = math.sin(angle) * (self.speed + 150)
end

function enemy:startMovingAfterDelay(delay)
    self.moveDelay = delay
end

function enemy:update(dt)
    self.x = self.x + self.velocity.x * dt
    self.y = self.y + self.velocity.y * dt

    self.isMoving = math.abs(self.velocity.x) > 0 or math.abs(self.velocity.y) > 0

    if self.isMoving then
        self.animationMoving:update(dt)
        self.stoppedTimer = 0
        self.moveTimer = self.moveTimer + dt

        if self.moveTimer >= self.moveDuration then
            self.velocity.x = 0
            self.velocity.y = 0
        end

        self.secondAnimationPlayed = false
    else
        self.animationStopped:update(dt)
        self.stoppedTimer = self.stoppedTimer + dt

        if self.stoppedTimer >= self.stoppedDuration then
            self.stoppedTimer = 0

            if not self.secondAnimationPlayed then
                self.secondAnimation:gotoFrame(1)
                self.secondAnimationPlayed = true

                self:shoot('down', 500)

                self:startMovingAfterDelay(0.50)
            end
        end

        if self.secondAnimationPlayed then
            self.secondAnimation:update(dt)

            if self.secondAnimation.position == self.secondAnimation.frames then
                self:startMoving()
                self.moveTimer = 0
            end
        end
    end

    if self.moveDelay then
        self.moveDelay = self.moveDelay - dt

        if self.moveDelay <= 0 then
            self.moveDelay = nil

            self:startMoving()
            self.moveTimer = 0
        end
    end

    if self.x > 1280 - 62 then
        self.x = 1280 - 62
        self.velocity.x = -self.velocity.x
        self.velocity.y = 0
    elseif self.x < 0 then
        self.x = 0
        self.velocity.x = -self.velocity.x
        self.velocity.y = 0
    end

    if self.y > 720 - 376 then
        self.y = 720 - 376
        self.velocity.y = -self.velocity.y
        self.velocity.x = 0
    elseif self.y < 0 then
        self.y = 0
        self.velocity.y = -self.velocity.y
        self.velocity.x = 0
    end

    for _, bullet in ipairs(self.bullets) do
        bullet:update(dt)
    end
end

function enemy:draw()
    if self.isMoving then
        self.animationMoving:draw(self.spriteSheet, self.x, self.y)
    else
        if not self.secondAnimationPlayed then
            self.animationStopped:draw(self.spriteSheet, self.x, self.y)
        else
            self.secondAnimation:draw(self.spriteSheet, self.x, self.y)
        end
    end

    for _, bullet in ipairs(self.bullets) do
        bullet:draw()
    end
end

function enemy:shoot(direction, speed)
    local bullet = Bullet(self.x + 25, self.y + 30, speed, direction)
    table.insert(self.bullets, bullet)
end

return enemy