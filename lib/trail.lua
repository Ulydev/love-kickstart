-- trail.lua v0.1
-- inspired by Spyro and Taehl's work ( https://love2d.org/forums/ucp.php?i=pm&mode=compose&u=134819 )

-- Copyright (c) 2016 Ulysse Ramage
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local trail, trailObject = {
  var = {}
}, {}

local default = {
  --point
  duration = 1,
  amount = 100,
  rotation = 0,
  fill = "fill",
  
  --mesh
  mode = "stretch",
  width = 5
}

setmetatable(trail, trail)

--[[ Public ]]--

function trail:new(f)
  
  local _object = f
  
  assert(_object.content, "No content set.")
  
  _object.points = {}
  _object.duration = f.duration or default.duration
  _object.amount = f.amount or default.amount * (_object.duration / default.duration)
  _object.fade = f.fade
  _object.delay = _object.duration / _object.amount
  _object.time = _object.delay
  
  if f.type == "point" then

    _object.content.rotation = default.rotation
  
  elseif f.type == "mesh" then

    _object.content.mode = _object.content.mode or default.mode
    _object.width = f.content.width or default.width
    _object.content.mesh = love.graphics.newMesh(_object.duration / _object.delay / _object.delay, "strip")
    _object.content.mesh:setTexture(_object.content.source)

  end
  
  _object.active = true
  
  setmetatable(_object, { __index = trailObject })
  
  _object:reset()
  _object:setMotion()
  
  self.var[_object] = _object
  
  return _object
  
end

function trailObject:reset()
  
  if self.type == "mesh" then
    if self.content.mode == "repeat" then
      self.content.length = 0
    end
    self.vertices = {}
  end
  
end

--{ x, y, duration, width, pmotion=pm}
--{ x, y, alpha, rotation, pmotion=pm}

function trailObject:add(x, y)
  
  if self.type == "point" then
    
    table.insert(self.points, 1, { x, y, 1, self.rotation, motion = self:copyMotion() })
    
  elseif self.type == "mesh" then
    
    if self.content.mode == "repeat" then
			self.content.length = self.points[1][5]
		end
    
		table.insert(self.points, 1, { self.x, self.y, 1 })
    
  end
  
end

--

function trail:update(dt)
  
  for k, v in pairs(self.var) do
    v:update(dt)
  end
  
end

function trailObject:update(dt)
  
  assert(self.x and self.y, "No position set.")
  
  if self.active then
    self.time = self.time - dt
    if self.time < 0 then
      if self.type == "point" then print("added stuff") end
      self:add(self.x, self.y)
      self.time = self.time % self.delay
    end
  end
  
  if self.type == "mesh" then
    self.points[1] = {
      self.x,
      self.y,
      1,
      self.width,
      motion = self:copyMotion()
    }
  end
  
  for i = #self.points, 1, -1 do
    local point = self.points[i]
    
    point[3] = math.max(point[3] - dt / self.duration, 0)
    
    -- hack: point motion!
		local _motion = point.motion
		if _motion then
      point[1] = point[1] + _motion.x * dt
      point[2] = point[2] + _motion.y * dt
			_motion.x = _motion.x + _motion.vx * dt
      _motion.y = _motion.y + _motion.vy * dt
		end
    
    if self.type == "mesh" then
      
      self:updateVertex(i)
      
    end
    
    if point[3] <= 0 then
      table.remove(self.points, #self.points)
      if self.type == "mesh" then
        table.remove(self.vertices, #self.vertices)
        table.remove(self.vertices, #self.vertices)
      end
    end
    
  end
  
  if self.type == "mesh" then
    
    if #self.vertices > 3 then
      
      self.content.mesh:setVertices(self.vertices)
      
    end
      
  end
  
  return self
  
end

function trailObject:updateVertex(index)
  
  local pv = self.points[index+1]
  local v = self.points[index]
  local nv = self.points[index-1]
  
  local vertices = self.vertices
  
  if self.content.mode == "stretch" then
			  
			if index == 1 then
        
				local dist = ((v[1]-pv[1])^2+(v[2]-pv[2])^2)^.5
				local vert = {(v[2]-pv[2])*v[4]/(dist*2), (v[1]-pv[1])*v[4]/(dist*2)}

				vertices[1] = {
					v[1]+vert[1], v[2]-vert[2], v[3], 0
        }
				vertices[2] = {
					v[1]-vert[1], v[2]+vert[2], v[3], 1
        }
        
			elseif index == #self.points then
        
				local dist = math.sqrt((nv[1]-v[1])^2+(nv[2]-v[2])^2)
				local vert = {(nv[2]-v[2])*v[4]/(dist*2), -(nv[1]-v[1])*v[4]/(dist*2)}

				vertices[#self.points*2-1] = {
					v[1]+vert[1], v[2]-vert[2], v[3], 0
        }
				vertices[#self.points*2] = {
					v[1]-vert[1], v[2]+vert[2], v[3], 1
        }
        
			else
        
				local dist = math.sqrt((nv[1]-pv[1])^2+(nv[2]-pv[2])^2)
				local vert = {(nv[2]-pv[2])*v[4]/(dist*2), (nv[1]-pv[1])*v[4]/(dist*2)}

				vertices[index*2-1] = {
					v[1]+vert[1], v[2]-vert[2], v[3], 0
        }
				vertices[index*2] = {
					v[1]-vert[1], v[2]+vert[2], v[3], 1
        }
        
			end
      
		elseif self.content.mode == "repeat" then
      
			if index == 1 then
				local dist = math.sqrt((v[1]-pv[1])^2+(v[2]-pv[2])^2)
				local vert = {(v[2]-pv[2])*v[4]/(dist*2), (v[1]-pv[1])*v[4]/(dist*2)}

				v[5] = dist / (self.content.source:getWidth()/(self.content.source:getHeight()/self.width)) + self.content.length

				vertices[1] = {
					v[1]+vert[1], v[2]-vert[2], v[5], 0, 255, 255, 255, 255*v[3]
        }
				vertices[2] = {
					v[1]-vert[1], v[2]+vert[2], v[5], 1, 255, 255, 255, 255*v[3]
        }
        
			elseif index == #self.points then
        
				local dist = math.sqrt((nv[1]-v[1])^2+(nv[2]-v[2])^2)
				local vert = {(nv[2]-v[2])*v[4]/(dist*2), -(nv[1]-v[1])*v[4]/(dist*2)}
        
				vertices[#self.points*2-1] = {
					v[1]+vert[1], v[2]-vert[2], v[5], 0, 255, 255, 255, 1
        }
				vertices[#self.points*2] = {
					v[1]-vert[1], v[2]+vert[2], v[5], 1, 255, 255, 255, 1
        }
        
			else
        
				local dist = math.sqrt((nv[1]-pv[1])^2+(nv[2]-pv[2])^2)
				local vert = {(nv[2]-pv[2])*v[4]/(dist*2), (nv[1]-pv[1])*v[4]/(dist*2)}
        
				vertices[index*2-1] = {
					v[1]+vert[1], v[2]-vert[2], v[5], 0, 255, 255, 255, 255*(v[3] + self.delay)
        }
				vertices[index*2] = {
					v[1]-vert[1], v[2]+vert[2], v[5], 1, 255, 255, 255, 255*(v[3] + self.delay)
        }
        
			end
      
		end
  
end

--

function trailObject:setPosition(x, y)
  
  local _init = not (self.x and self.y)
  
  self.x, self.y = x, y
  
  if _init then
    self.points = {
      { x, y, 1, self.width, 0 },
      { x, y, 1 - self.delay, self.width, 0 }
    }
  end
  
  return self
  
end

function trailObject:setDuration(duration)
  
  self.duration = duration
  return self
  
end

function trailObject:setMotion(x, y, vx, vy)
  
  self.motion = {
    x = x or 0,
    y = y or 0,
    vx = vx or 0,
    vy = vy or 0
  }
  return self
  
end

function trailObject:copyMotion()
  
  return {
    x = self.motion.x,
    y = self.motion.y,
    vx = self.motion.vx,
    vy = self.motion.vy
  }
  
end

function trailObject:setRotation(rotation)
  
  self.rotation = rotation
  return self
  
end

--

function trailObject:draw()
  
  local col = {}
  col[1], col[2], col[3], col[4] = love.graphics.getColor()
  
  if self.type == "point" then
    
    for i = #self.points, 1, -1 do
      
      local point = self.points[i]
      
      local size = self.fade and (self.fade == "grow" and (2-point[3]) or point[3]) or 1
      love.graphics.setColor(col[1], col[2], col[3], col[4] * point[3])
      if self.content.type == "image" then
        local width, height = self.content.source:getWidth() * size, self.content.source:getHeight() * size
        love.graphics.draw(self.content.source, point[1], point[2], point[4], size, size, (width/size)*.5, (height/size)*.5)
      elseif self.content.type == "rectangle" then
        local width, height = self.content.width * size, self.content.height * size
        love.graphics.rectangle(self.content.fill or default.fill, point[1]-width*.5, point[2]-height*.5, width, height)
      elseif self.content.type == "circle" then
        local radius = self.content.radius * size
        love.graphics.circle(self.content.fill or default.fill, point[1], point[2], radius)
      end
      
    end
    
  elseif self.type == "mesh" then
    
    self.content.mesh:setDrawRange()
    love.graphics.draw(self.content.mesh)
    
  end
  
  love.graphics.setColor(unpack(col))
  
end

function trailObject:enable()
  if self.type == "mesh" then return self end
  
  self.active = true
  if self.type == "point" then self.time = self.delay end
  return self
  
end

function trailObject:disable()
  if self.type == "mesh" then return self end
  
  self.active = false
  return self
  
end

function trailObject:setWidth(width)
  
  self.width = width
  return self
  
end

--[[ Aliases ]]--

function trailObject:toggle() return self.active and self:disable() or self:enable() end

--[[ End ]]--

return trail