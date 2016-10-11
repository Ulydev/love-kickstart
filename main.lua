io.stdout:setvbuf('no') --fixes print issues

--//////////////////////////////////--
--//-\\-//-[[- SETTINGS -]]-\\-//-\\--
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\--

WWIDTH, WHEIGHT = 1920, 1080 --16/9 aspect ratio

--//////////////////////////////////--
--//-\\-//-[[- INCLUDES -]]-\\-//-\\--
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\--

--Libraries
push = require "lib.push"
screen = require "lib.shack" --Screen effects (shake, rotate, shear, scale)
lem = require "lib.lem" --Events
lue = require "lib.lue" --Hue
state = require "lib.stager" --Scenes and transitions
audio = require "lib.wave" --Audio
trail = require "lib.trail" --Trails
soft = require "lib.soft" --Lerp
ease = require "lib.easy" --Easing



--Includes - Custom libraries



--Classes



--///////////////////////////////--
--//-\\-//-[[- SETUP -]]-\\-//-\\--
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\--

local os = love.system.getOS()

phoneMode = (os == "iOS" or os == "Android") and true or false --handles mobile platforms
fullscreenMode = phoneMode and true or false --enables fullscreen if on mobile

local windowWidth, windowHeight = love.window.getDesktopDimensions()

if fullscreenMode then
  RWIDTH, RHEIGHT = windowWidth, windowHeight
else
  RWIDTH = windowWidth*.7 RHEIGHT = windowHeight*.7
end

push:setupScreen(WWIDTH, WHEIGHT, RWIDTH, RHEIGHT, {
  fullscreen = fullscreenMode,
  resizable = not phoneMode
})

--///////////////////////////////////--
--//-\\-//-[[- FUNCTIONS -]]-\\-//-\\--
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\--

function love.load()
  
  screen:setDimensions(push:getDimensions())
  
  state:switch("scenes/game", {})
  
end

function love.update(dt)
  
  screen:update(dt)
  lue:update(dt)
  soft:update(dt)
  trail:update(dt)
  
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
