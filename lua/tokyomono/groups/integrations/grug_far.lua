---@param c tokyomono.Colors
---@param o tokyomono.Config
return function(c, o)
  local blend = require("tokyomono.util").blend
  return {
    GrugFarHelpHeader = { fg = c.muted },
    GrugFarHelpHeaderKey = { fg = c.accent, bold = true },
    GrugFarHelpWinHeader = { fg = c.fg, bold = true },
    GrugFarHelpWinActionKey = { fg = c.accent, bold = true },
    GrugFarHelpWinActionPrefix = { fg = c.muted },
    GrugFarHelpWinActionText = { fg = c.fg },
    GrugFarHelpWinActionDescription = { fg = c.muted },
    GrugFarInputLabel = { fg = c.fg, bold = true },
    GrugFarInputPlaceholder = { fg = c.muted, italic = true },
    GrugFarResultsHeader = { fg = c.fg, bold = true },
    GrugFarResultsStats = { fg = c.muted },
    GrugFarResultsActionMessage = { fg = c.accent },
    GrugFarResultsCmdHeader = { fg = c.muted },
    GrugFarResultsPath = { fg = c.fg, bold = true, underline = true },
    GrugFarResultsLineNr = { fg = c.muted },
    GrugFarResultsColumnNr = { fg = c.muted },
    GrugFarResultsNumbersSeparator = { fg = c.muted },
    GrugFarResultsNumberLabel = { fg = c.muted },
    GrugFarResultsCursorLineNo = { fg = c.fg, bold = true },
    GrugFarResultsLongLineStr = { fg = c.muted },
    GrugFarResultsMatch = { fg = c.fg, bg = c.search, bold = true },
    GrugFarResultsMatchAdded = { fg = c.git.add, bg = blend(c.git.add, c.bg, 0.16) },
    GrugFarResultsMatchRemoved = { fg = c.git.delete, bg = blend(c.git.delete, c.bg, 0.14), strikethrough = true },
    GrugFarResultsAddIndicator = { fg = c.git.add },
    GrugFarResultsRemoveIndicator = { fg = c.git.delete },
    GrugFarResultsChangeIndicator = { fg = c.git.change },
    GrugFarResultsDiffSeparatorIndicator = { fg = c.muted },
    GrugFarVisualBufrange = { bg = c.surface2 },
  }
end
