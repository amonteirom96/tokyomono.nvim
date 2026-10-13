---@param c tokyomono.Colors
---@param o tokyomono.Config
return function(c, o)
  local hl = {
    DropBarCurrentContext = { bg = c.surface2 },
    DropBarCurrentContextIcon = { bg = c.surface2 },
    DropBarCurrentContextName = { fg = c.fg, bg = c.surface2, bold = true },
    DropBarHover = { bg = c.surface2 },
    DropBarIconHover = { bg = c.surface2 },
    DropBarIconUIIndicator = { fg = c.muted },
    DropBarIconUIPickPivot = { fg = c.accent, bold = true },
    DropBarIconUISeparator = { fg = c.muted },
    DropBarIconUISeparatorMenu = { fg = c.muted },
    DropBarMenuCurrentContext = { bg = c.select },
    DropBarMenuHoverEntry = { bg = c.select },
    DropBarMenuHoverIcon = { bg = c.surface3 },
    DropBarMenuHoverSymbol = { bold = true },
    DropBarMenuNormalFloat = { link = "NormalFloat" },
    DropBarMenuFloatBorder = { link = "FloatBorder" },
    DropBarMenuSbar = { link = "PmenuSbar" },
    DropBarMenuThumb = { link = "PmenuThumb" },
    DropBarFzfMatch = { fg = c.accent, bold = true },
    DropBarPreview = { bg = c.surface2 },
    DropBarKindDir = { fg = c.fg },
    DropBarKindFile = { fg = c.fg, bold = true },
    DropBarIconKindFolder = { fg = c.blue },
    DropBarIconKindTerminal = { fg = c.green },
    DropBarKindTerminal = { fg = c.fg },
  }

  -- Kind icons colored exactly like the completion menu. Names stay monochrome.
  for kind, key in pairs(require("tokyomono.kinds")) do
    hl["DropBarIconKind" .. kind] = { fg = c[key] }
  end

  -- Icons for dropbar's treesitter-only kinds
  for kind, key in pairs({
    Call = "blue",
    Declaration = "blue",
    Element = "cyan",
    Identifier = "fg",
    List = "orange",
    MarkdownH1 = "fg",
    Pair = "cyan",
    Scope = "azure",
    Section = "fg",
    Specifier = "azure",
    Statement = "azure",
    Table = "yellow",
    Type = "yellow",
    Macro = "azure",
    Repeat = "azure",
    IfStatement = "azure",
    ElseStatement = "azure",
    ForStatement = "azure",
    WhileStatement = "azure",
    DoStatement = "azure",
    SwitchStatement = "azure",
    CaseStatement = "azure",
    BreakStatement = "azure",
    ContinueStatement = "azure",
    GotoStatement = "azure",
    ReturnStatement = "azure",
    Delete = "orange",
    Rule = "azure",
    RuleSet = "azure",
    BlockMappingPair = "cyan",
    Unit = "orange",
  }) do
    hl["DropBarIconKind" .. kind] = { fg = c[key] }
  end

  return hl
end
