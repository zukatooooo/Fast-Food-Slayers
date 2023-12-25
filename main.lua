io.stdout:setvbuf('no')
Class = require 'class'
anim8 = require 'libraries/anim8'
push = require 'push'
Enemy = require 'Enemy'
Player = require 'Player'
Timer = require 'timer'

VIRTUAL_WIDTH = 1280
VIRTUAL_HEIGHT = 720

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

collisionTimer = 0
collisionDuration = 3


function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  smallFont = love.graphics.newFont('font.ttf', 6)
  bigFont = love.graphics.newFont('font.ttf', 32)

  love.graphics.setFont(smallFont)

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })

  enemies = {}

  local numEnemies = 7

  for i = 1, numEnemies do
    randomX = love.math.random(0, 1280)
    randomY = love.math.random(0, 344)

    enemy = Enemy(randomX, randomY, 20)

    table.insert(enemies, enemy)
  end

  player = Player(190, 80, 3, 'sprites/burger-Sheet.png', 62, 76, 0.19)

  randomX = love.math.random(0, 1280)
  randomY = love.math.random(0, 344)

  enemy = Enemy(randomX, randomY, 20)

  enemyCount = 0

  background = love.graphics.newImage('sprites/background.jpg')
end

function love.update(dt)
  player:update(dt)

  for _, enemy in ipairs(enemies) do
    enemy:update(dt)
  end
end

function love.draw()
  push:start()

  love.graphics.draw(background, 0, 0)
  player:draw()

  for _, enemy in ipairs(enemies) do
    enemy:draw()
  end

  push:finish()
end