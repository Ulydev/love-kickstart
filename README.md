![kickstart][kickstart]

# love-kickstart

love-kickstarter is a project template that aims at providing the most straightforward tools to quickly set up a LÖVE game, which makes it useful for game jams and hackatons.

Setup - **main.lua**
----------------

Set the internal resolution of your game
```lua
WWIDTH, WHEIGHT = 1920, 1080
```

Add external libraries and custom classes (e.g. Player class)
```lua
--Includes
require "/include/player" --example
```

Start making your game by editing and adding new scenes! By default, **main.lua** redirects to the **game** scene, located in "*/scenes*".
```lua
--game.lua

game:update(dt)
  moveObjects(dt)
end

game:draw()
  drawObjects()
end
```

What's included
----------------

[push](https://github.com/Ulydev/push) - Handles everything resolution-related

[shack](https://github.com/Ulydev/shack) - Lets you quickly add screen effects such as shake, rotate, shear and scale

[lem](https://github.com/Ulydev/lem) - Allows you to set up events and call them whenever and wherever in your code

[lue](https://github.com/Ulydev/lue) - Adds hue to your game

[stager](https://github.com/Ulydev/stager) - Manages all the different scenes and lets you switch between them



[kickstart]: http://s32.postimg.org/t5bydkfad/love.png
