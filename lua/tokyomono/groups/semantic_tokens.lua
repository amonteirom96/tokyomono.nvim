--- LSP semantic tokens. Monochrome like the rest of the code; only modifiers
--- that carry meaning get a style.

---@param c tokyomono.Colors
---@param o tokyomono.Config
return function(c, o)
  return {
    ["@lsp.type.comment"] = {}, -- let treesitter keep TODO/FIXME markers
    ["@lsp.mod.deprecated"] = { strikethrough = true },
    ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
    -- Every `const` in JS/TS is readonly; coloring them would paint half the
    -- file orange. Real constants still come through @lsp.type.enumMember etc.
    ["@lsp.typemod.variable.readonly"] = vim.tbl_extend("force", { fg = c.fg }, o.styles.constants),
    ["@lsp.type.keyword"] = { link = "@keyword" },
    ["@lsp.type.unresolvedReference"] = { sp = c.diag.error, undercurl = true },
  }
end
