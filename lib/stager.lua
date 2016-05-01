-- stager.lua v0.1

-- Copyright (c) 2016 Ulysse Ramage
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local stager = {
  state = {},
  global = {
    update = {},
    draw = {}
  }
}
setmetatable(stager, stager)

--[[ Public ]]--

function stager:new() --create new state
  return {}
end

function stager:switch(path, params)
  
  if self.state.unload then self.state.unload() end
  
  local matches={}
  for match in string.gmatch(path,"[^;]+") do
    matches[#matches+1] = match
  end
  path = matches[1]
  
  package.loaded[path]=false

  self.state = require(path)
  
  if self.state.load then self.state.load(params) end
  
  return self
end

function stager:update(dt)
  if self.state.update then self.state.update(dt) end
  return self
end

function stager:draw()
  if self.state.draw then self.state.draw() end
  return self
end

return stager