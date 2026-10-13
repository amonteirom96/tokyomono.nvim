-- Renders assets/banner.svg and assets/preview.svg from the real palette.
-- Usage: nvim --headless -u NONE --cmd "set rtp^=." -l scripts/assets.lua

local ex = require("tokyomono")
local util = require("tokyomono.util")
local L, D = ex.colors("light"), ex.colors("dark")

local FONT = "'JetBrains Mono','SF Mono','Cascadia Code',Menlo,Consolas,monospace"
local SANS = "'Inter','SF Pro Display','Segoe UI',Helvetica,Arial,sans-serif"
local fmt, concat = string.format, table.concat

local function esc(s)
  return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function write(path, s)
  local f = assert(io.open(path, "w"))
  f:write(s)
  f:close()
end

local ACCENTS = { "green", "blue", "cyan", "purple", "yellow", "orange", "red" }

-------------------------------------------------------------------------------
-- Banner
-------------------------------------------------------------------------------
local function banner()
  local W, H = 1280, 420
  local o = {}
  local function add(...)
    o[#o + 1] = fmt(...)
  end

  add('<svg xmlns="http://www.w3.org/2000/svg" width="%d" height="%d" viewBox="0 0 %d %d">', W, H, W, H)
  add("<defs>")
  add('<clipPath id="left"><polygon points="0,0 %d,0 %d,%d 0,%d"/></clipPath>', W / 2 + 70, W / 2 - 70, H, H)
  add('<clipPath id="right"><polygon points="%d,0 %d,0 %d,%d %d,%d"/></clipPath>', W / 2 + 70, W, W, H, W / 2 - 70, H)
  add('<clipPath id="card"><rect width="%d" height="%d" rx="24"/></clipPath>', W, H)
  add("</defs>")
  add('<g clip-path="url(#card)">')
  add('<rect width="%d" height="%d" fill="%s"/>', W, H, L.bg)
  add('<rect width="%d" height="%d" fill="%s" clip-path="url(#right)"/>', W, H, D.bg)

  local function title(c, clip)
    add('<g clip-path="url(#%s)">', clip)
    add(
      '<text x="%d" y="200" text-anchor="middle" font-family="%s" font-size="96" font-weight="700" letter-spacing="-3" fill="%s">tokyomono</text>',
      W / 2, SANS, c.fg
    )
    add(
      '<text x="%d" y="258" text-anchor="middle" font-family="%s" font-size="24" fill="%s" letter-spacing="0.5">tokyonight, quieted down · red only for errors</text>',
      W / 2, SANS, c.fg
    )
    add(
      '<text x="%d" y="372" text-anchor="middle" font-family="%s" font-size="17" fill="%s" letter-spacing="4">NEOVIM · GHOSTTY · KITTY · LAZYGIT</text>',
      W / 2, FONT, c.muted
    )
    add("</g>")
  end
  title(L, "left")
  title(D, "right")

  -- accent dots: each drawn in the variant it sits on
  local n, gap, r = #ACCENTS, 38, 9
  local x0 = W / 2 - (n - 1) * gap / 2
  for i, k in ipairs(ACCENTS) do
    local x = x0 + (i - 1) * gap
    local c = x < W / 2 and L or D
    add('<circle cx="%d" cy="310" r="%d" fill="%s"/>', x, r, c[k])
  end
  add("</g>")
  add("</svg>")
  return concat(o, "\n")
end

-------------------------------------------------------------------------------
-- Preview: an editor mock-up rendered in both variants
-------------------------------------------------------------------------------
-- token = { text, style } where style: nil | "kw" | "comment" | "todo" | "str" | "fn" | "type" | "const"
local CODE = {
  { { "local", "kw" }, { " util = " }, { "require", "fn" }, { "(" }, { '"tokyomono.util"', "str" }, { ")" } },
  {},
  { { "-- ", "comment" }, { "TODO", "todo" }, { " cache blended results", "comment" } },
  { { "---@param fg ", "comment" }, { "Color", "type" }, { " color on top", "comment" } },
  { { "function", "kw" }, { " M." }, { "blend", "fn" }, { "(" }, { "fg, bg, alpha", "parameter" }, { ")" } },
  { { "  " }, { "local", "kw" }, { " r = fg." }, { "r", "property" }, { " * alpha + bg." }, { "r", "property" }, { " * (" }, { "1", "const" }, { " - alpha)" } },
  { { "  " }, { "local", "kw" }, { " hex = util." }, { "format", "fn" }, { "(" }, { '"#%02x"', "str" }, { ", r, " }, { "true", "const" }, { ")" } },
  { { "  " }, { "return", "kw" }, { " M.h" } },
  { { "end", "kw" } },
  {},
  { { "return", "kw" }, { " M" } },
}
local CURSOR, TODO = 8, 3
-- line -> git kind (numhl, like `numhl = true` in gitsigns)
local GIT = { [5] = "change", [6] = "add", [7] = "add", [10] = "delete" }

local MENU = {
  { "hex", "Function", "blue", "ƒ" },
  { "highlights", "Field", "cyan", "◆" },
  { "hue", "Variable", "fg", "x" },
  { "hsl", "Class", "yellow", "C" },
  { "http", "Module", "azure", "M" },
  { "hash", "Snippet", "green", "S" },
}

local function editor(c, ox, oy, w, h, label)
  local o = {}
  local function add(...)
    o[#o + 1] = fmt(...)
  end
  local fs, lh = 15, 26
  local cw = fs * 0.6
  local gutter = 52
  local top = oy + 44

  local id = "clip" .. label
  add('<clipPath id="%s"><rect x="%d" y="%d" width="%d" height="%d" rx="14"/></clipPath>', id, ox, oy, w, h)
  add('<g font-family="%s" font-size="%d" clip-path="url(#%s)">', FONT, fs, id)
  add('<rect x="%d" y="%d" width="%d" height="%d" rx="14" fill="%s" stroke="%s"/>', ox, oy, w, h, c.bg, c.border)

  -- tabline (mini.tabline)
  add('<rect x="%d" y="%d" width="%d" height="30" rx="14" fill="%s"/>', ox, oy, w, c.bg)
  add('<rect x="%d" y="%d" width="120" height="30" fill="%s"/>', ox + 14, oy + 2, c.surface2)
  add('<rect x="%d" y="%d" width="120" height="2" fill="%s"/>', ox + 14, oy + 30, c.accent)
  add('<text x="%d" y="%d" fill="%s" font-weight="700"><tspan fill="%s">●</tspan> blend.lua</text>', ox + 24, oy + 22, c.fg, c.blue)
  add('<text x="%d" y="%d" fill="%s"><tspan fill="%s">●</tspan> init.lua</text>', ox + 150, oy + 22, c.muted, c.azure)
  add('<text x="%d" y="%d" fill="%s" font-family="%s" font-size="13" text-anchor="end" letter-spacing="2">%s</text>', ox + w - 16, oy + 22, c.muted, SANS, label)

  for i, line in ipairs(CODE) do
    local y = top + (i - 1) * lh
    local base = y + lh * 0.68
    if i == CURSOR then
      add('<rect x="%d" y="%d" width="%d" height="%d" fill="%s"/>', ox + 1, y, w - 2, lh, c.surface1)
    end
    local g = GIT[i]
    if g then
      add('<rect x="%d" y="%d" width="%d" height="%d" fill="%s"/>', ox + 8, y + 2, gutter - 14, lh - 4, util.blend(c.git[g], c.bg, 0.14))
    end
    local nr_fill = g and c.git[g] or (i == CURSOR and c.fg or c.muted)
    add('<text x="%d" y="%d" text-anchor="end" fill="%s"%s>%d</text>', ox + gutter - 12, base, nr_fill, (g or i == CURSOR) and ' font-weight="700"' or "", i)

    local parts = {}
    for _, tok in ipairs(line) do
      local text, style = tok[1], tok[2]
      if style == "kw" then
        parts[#parts + 1] = fmt('<tspan fill="%s" font-weight="700">%s</tspan>', c.code.keyword, esc(text))
      elseif style == "property" then
        parts[#parts + 1] = fmt('<tspan fill="%s">%s</tspan>', c.code.property, esc(text))
      elseif style == "parameter" then
        parts[#parts + 1] = fmt('<tspan fill="%s">%s</tspan>', c.code.parameter, esc(text))
      elseif style == "comment" then
        parts[#parts + 1] = fmt('<tspan fill="%s" font-style="italic">%s</tspan>', c.comment, esc(text))
      elseif style == "str" then
        parts[#parts + 1] = fmt('<tspan fill="%s">%s</tspan>', c.code.string, esc(text))
      elseif style == "fn" then
        parts[#parts + 1] = fmt('<tspan fill="%s">%s</tspan>', c.code.func, esc(text))
      elseif style == "type" then
        parts[#parts + 1] = fmt('<tspan fill="%s">%s</tspan>', c.code.type, esc(text))
      elseif style == "const" then
        parts[#parts + 1] = fmt('<tspan fill="%s">%s</tspan>', c.code.constant, esc(text))
      elseif style == "todo" then
        parts[#parts + 1] = fmt('<tspan fill="%s" font-weight="700">%s</tspan>', c.bg, esc(text))
      else
        parts[#parts + 1] = esc(text)
      end
    end
    -- TODO marker background
    if i == TODO then
      add('<rect x="%d" y="%d" width="%d" height="%d" rx="3" fill="%s"/>', ox + gutter + 3 * cw - 2, y + 4, 4 * cw + 4, lh - 8, c.accent)
    end
    add('<text x="%d" y="%d" fill="%s" xml:space="preserve">%s</text>', ox + gutter, base, c.fg, concat(parts))
  end

  -- diagnostic virtual text on the cursor line
  local dy = top + (CURSOR - 1) * lh
  local dx = ox + gutter + 14 * cw
  add('<rect x="%d" y="%d" width="%d" height="%d" rx="4" fill="%s"/>', dx, dy + 3, 25 * cw, lh - 6, util.blend(c.diag.error, c.bg, 0.10))
  add('<text x="%d" y="%d" fill="%s" xml:space="preserve">■ undefined field `h`</text>', dx + 8, dy + lh * 0.68, c.diag.error)
  -- undercurl-ish under M.h
  local ux = ox + gutter + 9 * cw
  add('<path d="M%d %d q2 -3 4 0 t4 0 t4 0 t4 0 t4 0 t4 0 t4 0" fill="none" stroke="%s" stroke-width="1.3"/>', ux, dy + lh - 3, c.diag.error)

  -- completion menu (blink.cmp) under the cursor
  local mx, my = ox + gutter + 11 * cw, top + CURSOR * lh + 2
  local mw, mh = 250, #MENU * 24 + 12
  add('<rect x="%d" y="%d" width="%d" height="%d" rx="8" fill="%s" stroke="%s"/>', mx, my, mw, mh, c.bg_float, c.border)
  for j, item in ipairs(MENU) do
    local iy = my + 6 + (j - 1) * 24
    if j == 1 then
      add('<rect x="%d" y="%d" width="%d" height="24" fill="%s"/>', mx + 1, iy, mw - 2, c.surface2)
    end
    local kind = c[item[3]]
    add('<rect x="%d" y="%d" width="16" height="16" rx="4" fill="%s"/>', mx + 10, iy + 4, util.blend(kind, c.bg, 0.2))
    add('<text x="%d" y="%d" fill="%s" font-size="11" font-weight="700" text-anchor="middle">%s</text>', mx + 18, iy + 16, kind, item[4])
    add(
      '<text x="%d" y="%d" fill="%s"%s><tspan fill="%s" font-weight="700">h</tspan>%s</text>',
      mx + 36, iy + 17, c.fg, j == 1 and ' font-weight="700"' or "", c.accent, esc(item[1]:sub(2))
    )
    add('<text x="%d" y="%d" fill="%s" text-anchor="end" font-size="13">%s</text>', mx + mw - 12, iy + 17, kind, item[2])
  end

  -- statusline
  local sy = oy + h - 34
  add('<rect x="%d" y="%d" width="%d" height="34" fill="%s"/>', ox + 1, sy, w - 2, c.surface2)
  add('<rect x="%d" y="%d" width="70" height="34" fill="%s"/>', ox + 1, sy, c.blue)
  add('<text x="%d" y="%d" fill="%s" font-weight="700">NOR</text>', ox + 20, sy + 22, c.bg)
  add('<text x="%d" y="%d" fill="%s">[tokyomono]  <tspan fill="%s">E:1</tspan> <tspan fill="%s">W:2</tspan></text>', ox + 86, sy + 22, c.blue, c.diag.error, c.diag.warn)
  add('<text x="%d" y="%d" fill="%s" text-anchor="end"><tspan fill="%s"> main</tspan>  <tspan fill="%s">●</tspan> lua  8:14</text>', ox + w - 16, sy + 22, c.fg, c.green, c.blue)
  add("</g>")
  add('<rect x="%d" y="%d" width="%d" height="%d" rx="14" fill="none" stroke="%s"/>', ox, oy, w, h, c.border)
  return concat(o, "\n")
end

local function preview()
  local W, H = 1280, 500
  local ew, eh = 610, 460
  return concat({
    fmt('<svg xmlns="http://www.w3.org/2000/svg" width="%d" height="%d" viewBox="0 0 %d %d">', W, H, W, H),
    editor(L, 20, 20, ew, eh, "LIGHT"),
    editor(D, W - ew - 20, 20, ew, eh, "DARK"),
    "</svg>",
  }, "\n")
end

vim.fn.mkdir("assets", "p")
write("assets/banner.svg", banner())
write("assets/preview.svg", preview())
print("assets/banner.svg, assets/preview.svg written")
