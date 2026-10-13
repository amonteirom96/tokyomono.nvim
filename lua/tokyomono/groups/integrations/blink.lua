---@param c tokyomono.Colors
---@param o tokyomono.Config
return function(c, o)
  local hl = {
    BlinkCmpMenu = { link = "Pmenu" },
    BlinkCmpMenuBorder = { link = "PmenuBorder" },
    BlinkCmpMenuSelection = { link = "PmenuSel" },
    BlinkCmpScrollBarThumb = { link = "PmenuThumb" },
    BlinkCmpScrollBarGutter = { link = "PmenuSbar" },
    BlinkCmpLabel = { fg = c.fg },
    BlinkCmpLabelDeprecated = { fg = c.muted, strikethrough = true },
    BlinkCmpLabelMatch = { fg = c.accent, bold = true },
    BlinkCmpLabelDetail = { fg = c.muted },
    BlinkCmpLabelDescription = { fg = c.muted },
    BlinkCmpSource = { fg = c.muted },
    BlinkCmpKind = { fg = c.muted },
    BlinkCmpGhostText = { fg = c.muted, italic = true },
    BlinkCmpDoc = { link = "NormalFloat" },
    BlinkCmpDocBorder = { link = "FloatBorder" },
    BlinkCmpDocSeparator = { fg = c.border },
    BlinkCmpDocCursorLine = { link = "CursorLine" },
    BlinkCmpSignatureHelp = { link = "NormalFloat" },
    BlinkCmpSignatureHelpBorder = { link = "FloatBorder" },
    BlinkCmpSignatureHelpActiveParameter = { link = "LspSignatureActiveParameter" },
  }

  -- Colored kinds. Blink links BlinkCmpKind<X> -> CmpItemKind<X> when
  -- `use_nvim_cmp_as_default` is on, so set both.
  for kind, key in pairs(require("tokyomono.kinds")) do
    local spec = { fg = c[key] }
    hl["BlinkCmpKind" .. kind] = spec
    hl["CmpItemKind" .. kind] = spec
  end
  hl.CmpItemAbbrMatch = { fg = c.accent, bold = true }
  hl.CmpItemAbbrMatchFuzzy = { fg = c.accent, bold = true }
  hl.CmpItemAbbrDeprecated = { fg = c.muted, strikethrough = true }
  hl.CmpItemMenu = { fg = c.muted }

  return hl
end
