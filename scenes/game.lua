local game = state:new()

--[[ State ]]--

function game.load(params)
  
  love.graphics.setNewFont(92)
  
  --load
  
end

function game.update(dt)

  --update

end

function game.draw()
  
  local time = love.timer.getTime()
  love.graphics.printf("Welcome!", math.cos(time*5)*100, WHEIGHT*.5 + math.sin(time)*100, WWIDTH, "center")
  
  --draw

end

function game.unload()
  
  --unload
  
end

--[[ External ]]--

function love.keypressed(key, scancode, isrepeat)
  
  --keypressed
  
end

--[[ End ]]--

return game