local util = require("tokyomono.util")

---@param c tokyomono.Colors
---@param o tokyomono.Config
return function(c, o)
  local blend = util.blend
  local bg = o.transparent and c.none or c.bg
  local float_bg = o.transparent and c.none or (o.float.solid and c.surface1 or c.bg_float)
  local float_border = o.float.solid and { fg = c.surface1, bg = float_bg } or { fg = c.border, bg = float_bg }

  local hl = {
    -- Base -------------------------------------------------------------------
    Normal = { fg = c.fg, bg = bg },
    NormalNC = { fg = c.fg, bg = (o.dim_inactive and not o.transparent) and c.bg_dim or bg },
    NormalFloat = { fg = c.fg, bg = float_bg },
    FloatBorder = float_border,
    FloatTitle = { fg = c.fg, bg = float_bg, bold = true },
    FloatFooter = { fg = c.muted, bg = float_bg },
    FloatShadow = { bg = "#000000", blend = 80 },
    FloatShadowThrough = { bg = "#000000", blend = 100 },
    MsgArea = { fg = c.fg },
    MsgSeparator = { fg = c.border, bg = bg },
    ModeMsg = { fg = c.fg, bold = true },
    MoreMsg = { fg = c.accent, bold = true },
    Question = { fg = c.accent },
    ErrorMsg = { fg = c.red, bold = true },
    WarningMsg = { fg = c.yellow },
    OkMsg = { fg = c.green },
    StderrMsg = { fg = c.red },
    StdoutMsg = { fg = c.fg },
    NvimInternalError = { fg = c.bg, bg = c.red },
    Title = { fg = c.fg, bold = true },
    Directory = { fg = c.fg, bold = true },
    Conceal = { fg = c.muted },
    NonText = { fg = c.surface3 },
    EndOfBuffer = { fg = c.surface3 },
    Whitespace = { fg = c.surface3 },
    SpecialKey = { fg = c.muted },

    -- Cursor & lines ---------------------------------------------------------
    Cursor = { fg = c.bg, bg = c.fg },
    lCursor = { fg = c.bg, bg = c.fg },
    CursorIM = { fg = c.bg, bg = c.fg },
    TermCursor = { reverse = true },
    CursorLine = { bg = c.surface1 },
    CursorColumn = { bg = c.surface1 },
    ColorColumn = { bg = c.surface1 },
    LineNr = { fg = c.muted },
    LineNrAbove = { fg = c.muted },
    LineNrBelow = { fg = c.muted },
    CursorLineNr = { fg = c.fg, bold = true },
    CursorLineSign = { bg = c.none },
    CursorLineFold = { fg = c.fg },
    SignColumn = { fg = c.muted, bg = bg },
    FoldColumn = { fg = c.muted, bg = bg },
    Folded = { fg = c.fg, bg = c.surface1, italic = true },
    QuickFixLine = { bg = c.select, bold = true },

    -- Selection & search (color here helps you find things) ------------------
    Visual = { bg = c.surface3 },
    VisualNOS = { bg = c.surface2 },
    Search = { fg = c.fg, bg = c.search },
    CurSearch = { fg = c.bg, bg = c.accent, bold = true },
    IncSearch = { fg = c.bg, bg = c.accent, bold = true },
    Substitute = { fg = c.bg, bg = c.orange, bold = true },
    MatchParen = { bg = c.surface3, bold = true },

    -- Windows, bars ----------------------------------------------------------
    WinSeparator = { fg = c.border, bg = bg },
    VertSplit = { fg = c.border, bg = bg },
    StatusLine = { fg = c.fg, bg = c.surface2 },
    StatusLineNC = { fg = c.muted, bg = c.surface1 },
    StatusLineTerm = { fg = c.fg, bg = c.surface2 },
    StatusLineTermNC = { fg = c.muted, bg = c.surface1 },
    TabLine = { fg = c.muted, bg = c.surface1 },
    TabLineFill = { bg = bg },
    TabLineSel = { fg = c.fg, bg = c.surface2, bold = true, sp = c.accent, underline = true },
    WinBar = { fg = c.fg, bg = bg },
    WinBarNC = { fg = c.muted, bg = bg },
    WildMenu = { fg = c.fg, bg = c.select, bold = true },

    -- Popup menu -------------------------------------------------------------
    Pmenu = { fg = c.fg, bg = float_bg },
    PmenuSel = { bg = c.select, bold = true },
    PmenuKind = { fg = c.muted, bg = float_bg },
    PmenuKindSel = { fg = c.fg, bg = c.select },
    PmenuExtra = { fg = c.muted, bg = float_bg },
    PmenuExtraSel = { fg = c.muted, bg = c.select },
    PmenuMatch = { fg = c.accent, bold = true },
    PmenuMatchSel = { fg = c.accent, bg = c.select, bold = true },
    PmenuSbar = { bg = float_bg },
    PmenuThumb = { bg = c.surface3 },
    PmenuBorder = float_border,
    PmenuShadow = { bg = "#000000", blend = 80 },
    PmenuShadowThrough = { bg = "#000000", blend = 100 },
    ComplMatchIns = { fg = c.muted },
    ComplHint = { fg = c.muted },
    ComplHintMore = { fg = c.muted },

    -- Snippets ---------------------------------------------------------------
    SnippetTabstop = { bg = c.surface2 },
    SnippetTabstopActive = { bg = c.surface3, bold = true },

    -- Spell ------------------------------------------------------------------
    SpellBad = { sp = c.red, undercurl = true },
    SpellCap = { sp = c.yellow, undercurl = true },
    SpellLocal = { sp = c.cyan, undercurl = true },
    SpellRare = { sp = c.azure, undercurl = true },

    -- Diff & git (the places that deserve color) -----------------------------
    Added = { fg = c.git.add },
    Changed = { fg = c.git.change },
    Removed = { fg = c.git.delete },
    DiffAdd = { bg = blend(c.git.add, c.bg, 0.16) },
    DiffChange = { bg = blend(c.git.change, c.bg, 0.12) },
    DiffDelete = { fg = c.git.delete, bg = blend(c.git.delete, c.bg, 0.14) },
    DiffText = { bg = blend(c.git.change, c.bg, 0.30) },
    DiffTextAdd = { bg = blend(c.git.add, c.bg, 0.30) },
    diffAdded = { fg = c.git.add },
    diffChanged = { fg = c.git.change },
    diffRemoved = { fg = c.git.delete },
    diffFile = { fg = c.fg, bold = true },
    diffLine = { fg = c.accent },
    diffIndexLine = { fg = c.muted },

    -- Diagnostics ------------------------------------------------------------
    DiagnosticDeprecated = { sp = c.diag.warn, strikethrough = true },
    DiagnosticUnnecessary = { fg = c.muted, italic = true },

    -- LSP --------------------------------------------------------------------
    LspReferenceText = { bg = c.surface2 },
    LspReferenceRead = { bg = c.surface2 },
    LspReferenceWrite = { bg = c.surface2, underline = true, sp = c.muted },
    LspReferenceTarget = { bg = c.surface2 },
    LspInlayHint = { fg = c.muted, bg = c.surface1, italic = true },
    LspCodeLens = { fg = c.muted, italic = true },
    LspCodeLensSeparator = { fg = c.border },
    LspSignatureActiveParameter = { bg = c.surface2, bold = true, underline = true },
    LspInfoBorder = float_border,

    -- Health -----------------------------------------------------------------
    healthError = { fg = c.red },
    healthSuccess = { fg = c.green },
    healthWarning = { fg = c.yellow },

    -- Redraw debug -----------------------------------------------------------
    RedrawDebugNormal = { reverse = true },
    RedrawDebugClear = { bg = c.yellow },
    RedrawDebugComposed = { bg = c.green },
    RedrawDebugRecompose = { bg = c.red },
  }

  for name, color in pairs({ Error = c.diag.error, Warn = c.diag.warn, Info = c.diag.info, Hint = c.diag.hint, Ok = c.diag.ok }) do
    local tint = blend(color, c.bg, 0.10)
    hl["Diagnostic" .. name] = { fg = color }
    hl["DiagnosticSign" .. name] = { fg = color, bg = bg }
    hl["DiagnosticFloating" .. name] = { fg = color }
    hl["DiagnosticVirtualText" .. name] = { fg = color, bg = tint }
    hl["DiagnosticVirtualLines" .. name] = { fg = color }
    hl["DiagnosticUnderline" .. name] = { sp = color, undercurl = true }
    hl["DiagnosticLine" .. name] = { bg = tint }
  end

  return hl
end
