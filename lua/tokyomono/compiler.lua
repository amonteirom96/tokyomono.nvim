--- Turns the highlight table into a flat Lua chunk of `nvim_set_hl` calls with
--- integer colors, then dumps it to stripped LuaJIT bytecode. Loading the theme
--- from cache is a single `loadfile` + one call: no palette math, no table
--- merging, no string->color parsing.
local M = {}

local fmt, concat = string.format, table.concat

local ATTRS = {
  "bold", "italic", "underline", "undercurl", "underdouble", "underdotted",
  "underdashed", "strikethrough", "reverse", "standout", "nocombine", "altfont",
}

---@param v string?
---@return string?
local function color(v)
  if v == nil or v == "NONE" then
    return v and '"NONE"' or nil
  end
  return fmt("0x%s", v:sub(2))
end

---@param spec tokyomono.Style
local function serialize(spec)
  if spec.link then
    return fmt("{link=%q}", spec.link)
  end
  local parts = {}
  for _, k in ipairs({ "fg", "bg", "sp" }) do
    local v = color(spec[k])
    if v then
      parts[#parts + 1] = k .. "=" .. v
    end
  end
  for _, k in ipairs(ATTRS) do
    if spec[k] then
      parts[#parts + 1] = k .. "=true"
    end
  end
  if spec.blend then
    parts[#parts + 1] = "blend=" .. spec.blend
  end
  return "{" .. concat(parts, ",") .. "}"
end

---@param name string colors_name
---@param variant tokyomono.Variant
---@param hl table<string, tokyomono.Style>
---@param terminal string[]?
---@return string source
function M.source(name, variant, hl, terminal)
  local names = vim.tbl_keys(hl)
  table.sort(names)

  local lines = {
    "local h=vim.api.nvim_set_hl",
    "local g=vim.g",
    -- Every variant sets the same (complete) group set, so switching between
    -- tokyomono variants overwrites everything and `hi clear` is pure waste.
    'local prev=g.colors_name',
    'if prev and prev:sub(1,7)~="tokyomono" then vim.cmd("hi clear") end',
    fmt('if vim.o.background~=%q then vim.o.background=%q end', variant, variant),
    fmt("g.colors_name=%q", name),
  }
  for _, n in ipairs(names) do
    lines[#lines + 1] = fmt("h(0,%q,%s)", n, serialize(hl[n]))
  end
  if terminal then
    for i = 0, 15 do
      lines[#lines + 1] = fmt("g.terminal_color_%d=%q", i, terminal[i])
    end
  end
  return concat(lines, "\n")
end

---@param src string
---@param path string
---@return function
function M.write(src, path)
  local fn = assert(load(src, "=tokyomono"))
  vim.fn.mkdir(vim.fs.dirname(path), "p")
  local f = io.open(path, "wb")
  if f then
    f:write(string.dump(fn, true))
    f:close()
  end
  return fn
end

return M
