--- Generates themes for other tools from the exact same palette, so the
--- terminal, lazygit and Neovim always agree.
---
---   :TokyomonoExtras [dir]
---   nvim --headless -u NONE --cmd "set rtp^=." -c "lua require('tokyomono').extras()" -c q
local M = {}

---@class tokyomono.Extra
---@field ext string file extension (empty for none)
---@field render fun(c: tokyomono.Colors, ansi: string[], name: string): string

--- tool -> module
M.tools = {
  ghostty = "tokyomono.extras.ghostty",
  kitty = "tokyomono.extras.kitty",
  lazygit = "tokyomono.extras.lazygit",
}

---@param dir? string
---@return string dir
function M.generate(dir)
  -- <root>/lua/tokyomono/extras/init.lua -> <root>/extras
  dir = dir or (vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h:h:h") .. "/extras")
  local ex = require("tokyomono")
  local terminal = require("tokyomono.terminal")

  for tool, mod in pairs(M.tools) do
    local extra = require(mod) ---@type tokyomono.Extra
    local out = vim.fs.joinpath(dir, tool)
    vim.fn.mkdir(out, "p")
    for _, variant in ipairs({ "light", "dark" }) do
      local c = ex.colors(variant)
      local name = "tokyomono-" .. variant
      local f = assert(io.open(vim.fs.joinpath(out, name .. extra.ext), "w"))
      f:write(extra.render(c, terminal.ansi(c), name))
      f:close()
    end
  end
  return dir
end

return M
