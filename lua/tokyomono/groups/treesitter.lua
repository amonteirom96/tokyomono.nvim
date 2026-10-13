--- Treesitter captures. Most captures fall back to the legacy groups through
--- Neovim's default links, so we only set what the default colorscheme hard-codes
--- plus the captures where style or meaning matters.

---@param c tokyomono.Colors
---@param o tokyomono.Config
return function(c, o)
  local s = o.styles
  local fg = c.fg

  local str, func, typ, const = c.code.string, c.code.func, c.code.type, c.code.constant

  ---@param style tokyomono.Style
  ---@param color? string
  local function with(style, color)
    return vim.tbl_extend("force", { fg = color or fg }, style)
  end

  local function marker(color)
    return { fg = c.bg, bg = color, bold = true }
  end

  return {
    ["@variable"] = with(s.variables),
    ["@variable.builtin"] = with(s.keywords, c.code.keyword),
    ["@variable.parameter"] = with(s.variables, c.code.parameter),
    ["@variable.member"] = with(s.variables, c.code.property),

    ["@constant"] = with(s.constants, const),
    ["@constant.builtin"] = with(s.constants, const),
    ["@constant.macro"] = with(s.constants, const),
    ["@number"] = with(s.constants, const),
    ["@number.float"] = with(s.constants, const),
    ["@boolean"] = with(s.constants, const),
    ["@module"] = { fg = fg },
    ["@module.builtin"] = { fg = fg },
    ["@label"] = with(s.keywords, c.code.keyword),

    ["@string"] = with(s.strings, str),
    ["@string.documentation"] = vim.tbl_extend("force", { fg = o.muted_comments and c.muted or c.comment }, s.comments),
    ["@string.regexp"] = with(s.strings, str),
    ["@string.escape"] = { fg = str, bold = true },
    ["@string.special.url"] = { fg = str, underline = true },
    ["@character"] = with(s.strings, str),
    ["@character.special"] = { fg = str, bold = true },

    ["@type"] = with(s.types, typ),
    ["@type.builtin"] = with(s.types, typ),
    ["@type.definition"] = with(s.types, typ),
    ["@attribute"] = { fg = fg },
    ["@property"] = with(s.variables, c.code.property),

    ["@function"] = with(s.functions, func),
    ["@function.builtin"] = with(s.functions, func),
    ["@function.call"] = with(s.functions, func),
    ["@function.macro"] = with(s.functions, func),
    ["@function.method"] = with(s.functions, func),
    ["@function.method.call"] = with(s.functions, func),
    ["@constructor"] = with(s.types, typ),
    ["@operator"] = with(s.operators),

    ["@keyword"] = with(s.keywords, c.code.keyword),
    ["@keyword.function"] = with(s.keywords, c.code.keyword),
    ["@keyword.return"] = with(s.keywords, c.code.keyword),
    ["@keyword.operator"] = with(s.keywords, c.code.keyword),

    ["@punctuation"] = { fg = fg },
    ["@punctuation.special"] = { fg = fg },
    ["@tag"] = { fg = fg },
    ["@tag.builtin"] = { fg = fg },
    ["@tag.attribute"] = { fg = fg, italic = true },
    ["@tag.delimiter"] = { fg = fg },

    -- Comment markers. Red only for FIXME/BUG (errors).
    ["@comment.error"] = marker(c.red),
    ["@comment.warning"] = marker(c.yellow),
    ["@comment.todo"] = marker(c.accent),
    ["@comment.note"] = marker(c.cyan),

    -- Markup
    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.heading"] = { fg = fg, bold = true },
    ["@markup.heading.1.delimiter.vimdoc"] = { fg = c.muted },
    ["@markup.heading.2.delimiter.vimdoc"] = { fg = c.muted },
    ["@markup.quote"] = { fg = fg, italic = true },
    ["@markup.math"] = { fg = fg },
    ["@markup.link"] = { fg = fg },
    ["@markup.link.label"] = { fg = fg, bold = true },
    ["@markup.link.url"] = { fg = fg, underline = true },
    ["@markup.raw"] = { fg = fg, bg = c.surface1 },
    ["@markup.raw.block"] = { fg = fg },
    ["@markup.list"] = { fg = fg, bold = true },
    ["@markup.list.checked"] = { fg = c.green },
    ["@markup.list.unchecked"] = { fg = c.muted },

    ["@diff.plus"] = { fg = c.git.add },
    ["@diff.minus"] = { fg = c.git.delete },
    ["@diff.delta"] = { fg = c.git.change },
  }
end
