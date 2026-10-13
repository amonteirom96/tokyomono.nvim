---@class tokyomono
local M = {}

--- Bump to invalidate every user's compiled cache after changing highlights.
M.version = "0.1.1"

local cache_dir = vim.fn.stdpath("cache") .. "/tokyomono"
local configured = false
local key ---@type string?

---@param opts? tokyomono.Config
function M.setup(opts)
  require("tokyomono.config").set(opts)
  configured = true
  key = nil
end

---@return tokyomono.Config
local function options()
  return require("tokyomono.config").options
end

---@return string
local function cache_key()
  if not key then
    key = configured and require("tokyomono.config").hash() or ("default-" .. M.version)
  end
  return key
end

---@param name string
---@return tokyomono.Variant
local function resolve_variant(name)
  if name == "tokyomono-light" then
    return "light"
  elseif name == "tokyomono-dark" then
    return "dark"
  end
  local v = options().variant
  if v == "light" or v == "dark" then
    return v
  end
  return vim.o.background == "light" and "light" or "dark"
end

--- Full palette (base + derived) for a variant, after `on_colors`.
---@param variant? tokyomono.Variant defaults to the current 'background'
---@return tokyomono.Colors
function M.colors(variant)
  return require("tokyomono.palette").get(variant or resolve_variant("tokyomono"), options())
end

--- Final highlight table for a variant, after `on_highlights`.
---@param variant? tokyomono.Variant
---@return table<string, tokyomono.Style>
function M.highlights(variant)
  local o = options()
  return require("tokyomono.groups").get(M.colors(variant), o)
end

---@param name string
---@param variant tokyomono.Variant
---@return string
local function build(name, variant)
  local o = options()
  local c = require("tokyomono.palette").get(variant, o)
  local hl = require("tokyomono.groups").get(c, o)
  local term = o.terminal_colors and require("tokyomono.terminal").ansi(c) or nil
  return require("tokyomono.compiler").source(name, variant, hl, term)
end

---@param prefix string
---@param keep string
local function prune(prefix, keep)
  for file in vim.fs.dir(cache_dir) do
    if vim.startswith(file, prefix) and file ~= keep then
      os.remove(cache_dir .. "/" .. file)
    end
  end
end

--- Entry point used by `colors/*.lua`.
---@param name? "tokyomono"|"tokyomono-light"|"tokyomono-dark"
function M.load(name)
  name = name or "tokyomono"
  local variant = resolve_variant(name)

  if not options().cache then
    return assert(load(build(name, variant), "=tokyomono"))()
  end

  local prefix = name .. "_" .. variant .. "_"
  local file = prefix .. cache_key()
  local path = cache_dir .. "/" .. file
  local fn = loadfile(path)
  if not fn then
    fn = require("tokyomono.compiler").write(build(name, variant), path)
    prune(prefix, file)
  end
  fn()
end

--- Rebuild the cache for the active colorscheme (e.g. after editing an
--- `on_highlights` closure whose upvalues changed).
function M.compile()
  M.clear_cache()
  local name = vim.g.colors_name
  if name and vim.startswith(name, "tokyomono") then
    vim.cmd.colorscheme(name)
  end
end

function M.clear_cache()
  vim.fn.delete(cache_dir, "rf")
  key = nil
end

--- Generate terminal/tool themes (ghostty, kitty, lazygit) from the palette.
---@param dir? string output directory, defaults to `<plugin>/extras`
function M.extras(dir)
  return require("tokyomono.extras").generate(dir)
end

return M
