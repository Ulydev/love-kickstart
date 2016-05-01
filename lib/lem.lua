-- lem.lua v0.1

-- Copyright (c) 2015 Ulysse Ramage
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local lem = {}
lem.__index = lem

function lem:new()
  local _manager = {}
  setmetatable(_manager, lem)

  _manager.handlers = {}

  return _manager
end

--[[ Private ]]--

function lem:eventExists(eventname)
  return self.handlers[eventname] and true or false
end

function lem:getHandlers(eventname)
  return self.handlers[eventname]
end

function lem:initHandlers(eventname)
  self.handlers[eventname] = {}
end

function lem:registerHandler(eventname, callback)
  table.insert(self.handlers[eventname], callback)
end

--[[ Public ]]--

function lem:on(eventname, callback)
  if not self:eventExists(eventname) then self:initHandlers(eventname) end
  self:registerHandler(eventname, callback)
  return self
end

function lem:emit(eventname, params)
  if not self:eventExists(eventname) then return self end
  for k, v in pairs(self:getHandlers(eventname)) do --v = callback
    v(params)
  end
  return self
end

function lem:remove(eventname, callback)
  if not self:eventExists(eventname) then return self end
  local callbackString = string.dump(callback)
  for k, v in pairs(self:getHandlers(eventname)) do
    if string.dump(v) == callbackString then
      self.handlers[eventname][k] = nil
    end
  end
  return self
end

function lem:reset(eventname)
  if not self:eventExists(eventname) then return self end
  self:initHandlers(eventname)
  return self
end

function lem:getListenerCount(eventname)
  return (self:eventExists(eventname) and #self:getHandlers(eventname) or -1)
end

--[[ Aliases ]]--

function lem:addListener(...) return self:on(...) end
function lem:removeListener(...) return self:remove(...) end
function lem:removeListeners(...) return self:reset(...) end

--[[ End ]]--

return lem
