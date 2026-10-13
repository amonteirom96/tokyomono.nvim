-- Adapted TokyoNight palette; modified for TokyoMono. See NOTICE and
-- LICENSE-TokyoNight for source attribution and license.
local util = require("tokyomono.util")

local M = {}

--- TokyoNight Night hues with a quieter syntax and a matching light palette.
--- Light accents are darkened for readable text on the cool paper background.
--- Red is reserved for errors and Git deletions; Visual mode uses azure.
M.base = {
  light = {
    bg = "#e1e2e7",
    fg = "#343b58",
    red = "#a52a45",
    orange = "#8b471e",
    yellow = "#795413",
    green = "#456523",
    cyan = "#20627a",
    azure = "#4f539c",
    blue = "#345aa0",
  },
  dark = {
    bg = "#1a1b26",
    fg = "#c0caf5",
    red = "#f7768e",
    orange = "#ff9e64",
    yellow = "#e0af68",
    green = "#9ece6a",
    cyan = "#7dcfff",
    azure = "#a9b1d6",
    blue = "#7aa2f7",
  },
}

---@class tokyomono.BasePalette
---@field bg string
---@field fg string
---@field red string
---@field orange string
---@field yellow string
---@field green string
---@field cyan string
---@field azure string
---@field blue string

---@class tokyomono.Colors: tokyomono.BasePalette
---@field variant "light"|"dark"
---@field none "NONE"
---@field bg_float string
---@field bg_dim string      background for inactive windows (dim_inactive)
---@field surface1 string    cursorline, subtle rows
---@field surface2 string    selection, active tab, statusline
---@field surface3 string    stronger selection / match paren
---@field select string      current item in lists: popup menu, pickers, file explorers
---@field border string
---@field muted string       UI chrome only (line numbers, whitespace) — never code
---@field comment string     comments: fg faded toward bg, still WCAG AA
---@field accent string      single UI focal color (matches, prompts)
---@field search string      background for search matches
---@field code { string: string, func: string, type: string, constant: string, keyword: string, property: string, parameter: string }
---@field git { add: string, change: string, delete: string }
---@field diag { error: string, warn: string, info: string, hint: string, ok: string }

--- Build the full, derived color table for a variant.
---@param variant "light"|"dark"
---@param opts tokyomono.Config
---@return tokyomono.Colors
function M.get(variant, opts)
  local b = vim.deepcopy(M.base[variant])
  local c = b --[[@as tokyomono.Colors]]
  local is_light = variant == "light"
  local blend = util.blend

  c.variant = variant
  c.none = "NONE"

  -- UI surfaces lean slightly blue, with the TokyoNight blue lean. Alphas are tuned to
  -- keep a gentle separation.
  local tint = blend(c.azure, c.fg, 0.5)
  c.surface1 = blend(tint, c.bg, is_light and 0.05 or 0.06)
  c.surface2 = blend(tint, c.bg, is_light and 0.08 or 0.085)
  c.surface3 = blend(tint, c.bg, is_light and 0.14 or 0.13)
  -- Current item in every list (Pmenu, pickers, explorers). surface2 is too
  -- faint to spot at a glance, so both variants use surface3 (about the same
  -- perceived lightness step from bg in light and dark).
  c.select = c.surface3
  c.border = blend(tint, c.bg, is_light and 0.24 or 0.22)
  c.muted = blend(c.fg, c.bg, is_light and 0.64 or 0.50)
  -- Comments step back from the code without dropping below AA (4.5:1): fg
  -- with the UI's blue lean, faded toward bg. Italic does the rest.
  c.comment = blend(blend(tint, c.fg, 0.35), c.bg, is_light and 0.84 or 0.7)
  c.bg_dim = is_light and blend(c.fg, c.bg, 0.03) or util.darken(c.bg, 0.12)
  c.bg_float = c.bg
  c.accent = c.blue
  -- Tinted accent, same hue family as the UI so it stays clean. Stronger than
  -- surface3 so it reads apart from Visual.
  c.search = blend(c.accent, c.bg, is_light and 0.25 or 0.32)

  local mono = opts.mono
  c.code = {
    string = mono and c.fg or c.green,
    func = mono and c.fg or c.blue,
    type = mono and c.fg or c.yellow,
    constant = mono and c.fg or c.orange,
    keyword = c.fg,
    property = mono and c.fg or c.cyan,
    parameter = mono and c.fg or c.cyan,
  }
  c.git = { add = c.green, change = c.blue, delete = c.red }
  c.diag = { error = c.red, warn = c.yellow, info = c.blue, hint = c.cyan, ok = c.green }

  if opts.on_colors then
    opts.on_colors(c, variant)
  end
  return c
end

return M
