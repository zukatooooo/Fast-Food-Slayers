Bullet = Class{}

function Bullet:init(x, y, speed, direction)
    self.x = x
    self.y = y
    self.speed = speed
    self.direction = direction

    self.spriteSheet = love.graphics.newImage('sprites/bullet.png')
    self.grid = anim8.newGrid(16, 16, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.animation = anim8.newAnimation(self.grid('1-4', 1), 0.1)

    self.anim = self.animation
end

function Bullet:update(dt)
    if self.direction == 'up' then
        self.y = self.y - self.speed * dt
    elseif self.direction == 'down' then
        self.y = self.y + self.speed * dt
    end
end

function Bullet:draw()
    Timer.after(500, love.graphics.circle('fill', self.x, self.y, 5))
end

return Bullet
