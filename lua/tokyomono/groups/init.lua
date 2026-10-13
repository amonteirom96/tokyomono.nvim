local M = {}

--- Core modules, always loaded.
M.core = { "editor", "syntax" }

--- Integrations: option key -> module under groups/ or groups/integrations/.
M.integrations = {
  treesitter = "treesitter",
  semantic_tokens = "semantic_tokens",
  blink = "integrations.blink",
  dropbar = "integrations.dropbar",
  gitsigns = "integrations.gitsigns",
  grug_far = "integrations.grug_far",
  lazy = "integrations.lazy",
  mason = "integrations.mason",
  mini = "integrations.mini",
  statusline = "integrations.statusline",
}

---@param c tokyomono.Colors
---@param o tokyomono.Config
---@return table<string, tokyomono.Style>
function M.get(c, o)
  local hl = {}
  local function add(mod)
    for name, spec in pairs(require("tokyomono.groups." .. mod)(c, o)) do
      hl[name] = spec
    end
  end

  for _, mod in ipairs(M.core) do
    add(mod)
  end
  for key, mod in pairs(M.integrations) do
    if o.integrations[key] ~= false then
      add(mod)
    end
  end

  if o.on_highlights then
    o.on_highlights(hl, c, c.variant)
  end
  return hl
end

return M
