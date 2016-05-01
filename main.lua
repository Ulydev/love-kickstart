--//////////////////////////////////--
--//-\\-//-[[- SETTINGS -]]-\\-//-\\--
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\--

io.stdout:setvbuf('no') --fixes print issues

local os = love.system.getOS()
phoneMode = (os == "iOS" or os == "Android") and true or false
fullscreenMode = phoneMode and true or false

push = require "/lib/push"

local windowWidth, windowHeight = love.window.getDesktopDimensions()

WWIDTH, WHEIGHT = 768, 432

if fullscreenMode then
  RWIDTH, RHEIGHT = windowWidth, windowHeight
else
  RWIDTH = windowWidth*.7 RHEIGHT = windowHeight*.7
end

push:setupScreen(WWIDTH, WHEIGHT, RWIDTH, RHEIGHT, {fullscreen = fullscreenMode, resizable = not phoneMode})

--//////////////////////////////////--
--//-\\-//-[[- INCLUDES -]]-\\-//-\\--
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\--

--Libraries
flux = require "/lib/flux" --Awesome tweening library
screen = require "/lib/shack" --Screen effects (shake, rotate, shear, scale)
lem = require "/lib/lem" --Event manager
lue = require "/lib/lue" --Hue
state = require "/lib/stager" --Manages scenes and transitions
slam = require "/lib/slam" --Manages audio playback



--Includes - Custom libraries



--Classes



--///////////////////////////////////--
--//-\\-//-[[- FUNCTIONS -]]-\\-//-\\--
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\--

function love.load()
  
  state:switch("scenes/game", {})
  
end

function love.update(dt)
  
  flux.update(dt)
  screen:update(dt)
  lue:update(dt)
  
  state:update(dt)
  
end

function love.draw()
  
  push:apply("start")
  screen:apply()
  
  state:draw()
  
  push:apply("end")
  
end

if not phoneMode then
  function love.resize(w, h)
    return push:resize(w, h)
  end
end