local util = require("tokyomono.util")

local M = {}

--- ANSI 16-color table derived from the palette. Used by `:terminal` and by the
--- ghostty/kitty extras, so the editor and the terminal always match.
--- ANSI magenta uses the same soft purple as syntax keywords.
---
--- Both variants use the same roles: "black" (0) is a shade of the background
--- and "white" (7, 15) is the text color. Most TUIs are designed for dark
--- terminals: they draw borders and titles in white and put black text on a
--- colored highlight (lazysql, htop, tview/tcell apps). Mapping white to the
--- background in light mode made those borders vanish and left dark text on
--- dark highlights.
---@param c tokyomono.Colors
---@return string[] 0-indexed colors
function M.ansi(c)
  local light = c.variant == "light"
  local bright = light and function(x)
    return util.darken(x, 0.12)
  end or function(x)
    return util.lighten(x, 0.14)
  end

  return {
    [0] = light and c.surface1 or c.surface3,
    c.red,
    c.green,
    c.yellow,
    c.blue,
    c.purple,
    c.cyan,
    c.fg,
    c.muted,
    bright(c.red),
    bright(c.green),
    bright(c.yellow),
    bright(c.blue),
    bright(c.purple),
    bright(c.cyan),
    light and util.darken(c.fg, 0.3) or util.lighten(c.fg, 0.4),
  }
end

return M
