---@class tokyomono.Util
local M = {}

local floor, max, min = math.floor, math.max, math.min

---@param hex string "#rrggbb"
---@return integer r, integer g, integer b
function M.rgb(hex)
  return tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
end

---@param r number
---@param g number
---@param b number
---@return string
function M.hex(r, g, b)
  local function c(v)
    return max(0, min(255, floor(v + 0.5)))
  end
  return string.format("#%02x%02x%02x", c(r), c(g), c(b))
end

--- Mix `fg` over `bg`. `alpha` = 1 returns `fg`, 0 returns `bg`.
---@param fg string
---@param bg string
---@param alpha number
---@return string
function M.blend(fg, bg, alpha)
  local fr, fg_, fb = M.rgb(fg)
  local br, bg_, bb = M.rgb(bg)
  return M.hex(fr * alpha + br * (1 - alpha), fg_ * alpha + bg_ * (1 - alpha), fb * alpha + bb * (1 - alpha))
end

---@param hex string
---@param amount number 0..1
function M.lighten(hex, amount)
  return M.blend("#ffffff", hex, amount)
end

---@param hex string
---@param amount number 0..1
function M.darken(hex, amount)
  return M.blend("#000000", hex, amount)
end

--- WCAG 2.x relative luminance.
---@param hex string
function M.luminance(hex)
  local function ch(v)
    v = v / 255
    return v <= 0.03928 and v / 12.92 or ((v + 0.055) / 1.055) ^ 2.4
  end
  local r, g, b = M.rgb(hex)
  return 0.2126 * ch(r) + 0.7152 * ch(g) + 0.0722 * ch(b)
end

--- WCAG 2.x contrast ratio (1..21).
---@param a string
---@param b string
function M.contrast(a, b)
  local la, lb = M.luminance(a), M.luminance(b)
  if la < lb then
    la, lb = lb, la
  end
  return (la + 0.05) / (lb + 0.05)
end

---@param dst table
---@param src table?
---@return table
function M.merge(dst, src)
  return src and vim.tbl_deep_extend("force", dst, src) or dst
end

return M
