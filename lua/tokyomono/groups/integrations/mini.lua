--- mini.icons, mini.pick, mini.extra, mini.files, mini.tabline
---@param c tokyomono.Colors
---@param o tokyomono.Config
return function(c, o)
  local util = require("tokyomono.util")
  local float_bg = o.transparent and c.none or (o.float.solid and c.surface1 or c.bg_float)
  local bg = o.transparent and c.none or c.bg

  return {
    -- Icons keep their colors; red folds into orange to avoid implying errors.
    MiniIconsAzure = { fg = c.azure },
    MiniIconsBlue = { fg = c.blue },
    MiniIconsCyan = { fg = c.cyan },
    MiniIconsGreen = { fg = c.green },
    MiniIconsGrey = { fg = c.muted },
    MiniIconsOrange = { fg = c.orange },
    MiniIconsPurple = { fg = c.azure },
    MiniIconsRed = { fg = c.orange },
    MiniIconsYellow = { fg = c.yellow },

    -- mini.pick / mini.extra
    MiniPickNormal = { fg = c.fg, bg = float_bg },
    MiniPickBorder = { link = "FloatBorder" },
    MiniPickBorderBusy = { fg = c.accent, bg = float_bg },
    MiniPickBorderText = { fg = c.fg, bg = float_bg, bold = true },
    MiniPickCursor = { blend = 100, nocombine = true },
    MiniPickHeader = { fg = c.fg, bold = true },
    MiniPickIconDirectory = { fg = c.fg },
    MiniPickIconFile = { fg = c.fg },
    MiniPickMatchCurrent = { bg = c.select, bold = true },
    MiniPickMatchMarked = { bg = util.blend(c.accent, c.bg, 0.18) },
    MiniPickMatchRanges = { fg = c.accent, bold = true },
    MiniPickPreviewLine = { bg = c.surface2 },
    MiniPickPreviewRegion = { bg = c.surface3 },
    MiniPickPrompt = { fg = c.fg, bg = float_bg },
    MiniPickPromptCaret = { fg = c.accent, bg = float_bg },
    MiniPickPromptPrefix = { fg = c.accent, bg = float_bg, bold = true },
    MiniExtraPickers = { fg = c.fg },

    -- mini.files
    MiniFilesNormal = { fg = c.fg, bg = float_bg },
    MiniFilesBorder = { link = "FloatBorder" },
    MiniFilesBorderModified = { fg = c.git.change, bg = float_bg },
    MiniFilesCursorLine = { bg = c.select },
    MiniFilesDirectory = { fg = c.fg, bold = true },
    MiniFilesFile = { fg = c.fg },
    MiniFilesTitle = { fg = c.muted, bg = float_bg },
    MiniFilesTitleFocused = { fg = c.fg, bg = float_bg, bold = true },

    -- mini.tabline (accent underline on the current buffer, modified buffers use the git "change" color)
    MiniTablineCurrent = { fg = c.fg, bg = c.surface2, bold = true, sp = c.accent, underline = true },
    MiniTablineVisible = { fg = c.fg, bg = bg },
    MiniTablineHidden = { fg = c.muted, bg = bg },
    MiniTablineModifiedCurrent = { fg = c.git.change, bg = c.surface2, bold = true, sp = c.accent, underline = true },
    MiniTablineModifiedVisible = { fg = c.git.change, bg = bg },
    MiniTablineModifiedHidden = { fg = util.blend(c.git.change, c.bg, 0.7), bg = bg },
    MiniTablineFill = { bg = bg },
    MiniTablineTabpagesection = { fg = c.bg, bg = c.accent, bold = true },
    MiniTablineTrunc = { fg = c.muted, bg = bg },
  }
end
