-- easy.lua v0.1

-- Copyright (c) 2016 Ulysse Ramage
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local easy = {}

local default = {
  quad    = "x * x",
  cubic   = "x * x * x",
  quart   = "x * x * x * x",
  quint   = "x * x * x * x * x",
  expo    = "2 ^ (10 * (x - 1))",
  sine    = "-math.cos(x * (math.pi * .5)) + 1",
  circ    = "-(math.sqrt(1 - (x * x)) - 1)",
  back    = "x * x * (2.7 * x - 1.7)",
  elastic = "-(2^(10 * (x - 1)) * math.sin((x - 1.075) * (math.pi * 2) / .3))"
}

local func = {}

local function makefunc(str, expr)
  local load = loadstring or load
  return load("return function(x) " .. str:gsub("%$e", expr) .. " end")()
end

local function generateEase(name, f)
  func[name .. "in"] = makefunc("return $e", f)
  func[name .. "out"] = makefunc([[
    x = 1 - x
    return 1 - ($e)
  ]], f)
  func[name .. "inout"] = makefunc([[
    x = x * 2
    if x < 1 then
      return .5 * ($e)
    else
      x = 2 - x
      return .5 * (1 - ($e)) + .5
    end 
  ]], f)
end

function easy:get(name, value)
  if not func[name] then name = name .. "in" end
  assert(func[name] ~= nil, "Function doesn't exist")
  return func[name](value)
end

function easy:add(name, f)
  assert(func[name] == nil, "Function already exists")
  return generateEase(name, f)
end

--all credits to rxi

for k, v in pairs(default) do
  generateEase(k, v)
end

--shortcut to easy:get

setmetatable(easy, { __call = easy.get })

return easy
