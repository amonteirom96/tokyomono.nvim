--- Groups for a hand-written statusline (`%#StModeNormal#`, `%#StGit#`, ...).
--- Each mode gets a filled block plus a `Sep` group for the powerline edge.

---@param c tokyomono.Colors
---@param o tokyomono.Config
return function(c, o)
  local bg = c.surface2
  local hl = {
    StProject = { fg = c.blue, bg = bg },
    StGit = { fg = c.green, bg = bg },
    StError = { fg = c.diag.error, bg = bg },
    StWarn = { fg = c.diag.warn, bg = bg },
    StInfo = { fg = c.diag.info, bg = bg },
    StHint = { fg = c.diag.hint, bg = bg },
    StLsp = { fg = c.accent, bg = bg },
  }

  -- No purple in the palette: Command takes azure, like ANSI magenta does.
  local modes = {
    Normal = c.blue,
    Insert = c.green,
    Visual = c.azure,
    Replace = c.orange,
    Command = c.azure,
    Other = c.cyan,
  }
  for mode, color in pairs(modes) do
    hl["StMode" .. mode] = { fg = c.bg, bg = color, bold = true }
    hl["StMode" .. mode .. "Sep"] = { fg = color, bg = bg }
  end

  return hl
end
