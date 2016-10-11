-- soft.lua v0.1

-- Copyright (c) 2016 Ulysse Ramage
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local soft, softObject = {
  speed = 5,
  var = {}
}, {}

setmetatable(soft, soft)

--[[ Private ]]--

local function lerp(a, b, k) --smooth transitions
  if a == b then
    return a
  else
    if math.abs(a-b) < 0.005 then return b else return a * (1-k) + b * k end
  end
end

--[[ Public ]]--

function soft:update(dt)
  for k, v in pairs(self.var) do
    v:update(dt)
  end
end

function softObject:update(dt)
  if self.target then self.value = lerp(self.value, self.target, self.speed * dt) end
end

--

function soft:new(value)
  local _object = {
    value = value
  }
  
  setmetatable(_object, { __index = softObject })
  self.var[_object] = _object
  
  return _object
end

function softObject:set(value, params)
  if params and params.reset then self.target = value end
  self.value = value
  return self
end

function softObject:to(target, params)
  self.target = target
  self.speed = params and params.speed or soft.speed
  return self
end

function softObject:setSpeed(speed)
  self.speed = speed
  return self
end

function softObject:get(target)
  return target and self.target or self.value
end

function softObject:getTarget() return self:get(true) end

--[[ Aliases ]]--

softObject.s = softObject.set
softObject.t = softObject.to

softObject.g = softObject.get
softObject.gt = softObject.getTarget

--[[ End ]]--

return soft