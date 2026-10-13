-- nvim --headless -u NONE --cmd "set rtp^=." -l tests/smoke.lua
local ok_all = true
local function check(cond, msg)
  if not cond then ok_all = false; print("FAIL: " .. msg) end
end

vim.env.XDG_CACHE_HOME = vim.fn.tempname()
local ex = require("tokyomono")

for _, name in ipairs({ "tokyomono-light", "tokyomono-dark", "tokyomono" }) do
  local ok, err = pcall(vim.cmd.colorscheme, name)
  check(ok, name .. ": " .. tostring(err))
  check(vim.g.colors_name == name, name .. ": colors_name=" .. tostring(vim.g.colors_name))
  local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
  check(normal.fg and normal.bg, name .. ": Normal has fg/bg")
  -- Six syntax accents, with neutral variables and operators.
  local c = ex.colors(vim.o.background)
  local want = {
    Keyword = c.purple, ["@keyword"] = c.purple, ["@keyword.return"] = c.purple,
    ["@variable.parameter"] = c.cyan, ["@variable.member"] = c.cyan, ["@property"] = c.cyan,
    ["@lsp.type.parameter"] = c.cyan, ["@lsp.type.property"] = c.cyan,
    String = c.green, ["@string"] = c.green,
    Function = c.blue, ["@function.call"] = c.blue, ["@function.method"] = c.blue,
    Type = c.yellow, ["@type"] = c.yellow, ["@type.builtin"] = c.yellow, ["@constructor"] = c.yellow,
    Number = c.orange, Boolean = c.orange, ["@constant"] = c.orange, ["@constant.builtin"] = c.orange, ["@number"] = c.orange,
  }
  want.Comment, want["@comment"] = c.comment, c.comment
  for _, g in ipairs({ "@variable", "@module", "@operator" }) do
    want[g] = c.fg
  end
  for g, color in pairs(want) do
    local h = vim.api.nvim_get_hl(0, { name = g, link = false })
    check(h.fg == tonumber(color:sub(2), 16), ("%s: %s fg %s ~= %s"):format(name, g, tostring(h.fg), color))
  end
  -- color where it matters
  local add = vim.api.nvim_get_hl(0, { name = "GitSignsAdd" }).fg
  local del = vim.api.nvim_get_hl(0, { name = "GitSignsDelete" }).fg
  check(add and del and add ~= del and add ~= normal.fg, name .. ": gitsigns colored")
  check(vim.api.nvim_get_hl(0, { name = "BlinkCmpKindFunction" }).fg ~= vim.api.nvim_get_hl(0, { name = "BlinkCmpKindVariable" }).fg, name .. ": kinds differ")
  check(vim.api.nvim_get_hl(0, { name = "MiniIconsRed" }).fg ~= nil, name .. ": mini.icons")
  check(vim.g.terminal_color_1 ~= nil, name .. ": terminal colors")
end

-- background switch follows for "tokyomono"
vim.cmd.colorscheme("tokyomono")
vim.o.background = "light"
local light_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
check(light_bg == tonumber(ex.colors("light").bg:sub(2), 16), "auto variant follows background=light")
vim.o.background = "dark"
check(vim.api.nvim_get_hl(0, { name = "Normal" }).bg == tonumber(ex.colors("dark").bg:sub(2), 16), "auto variant follows background=dark")

-- cache written and setup invalidates key
local dir = vim.fn.stdpath("cache") .. "/tokyomono"
check(#vim.fn.readdir(dir) >= 3, "cache files exist")
ex.setup({ transparent = true })
vim.cmd.colorscheme("tokyomono-dark")
check(vim.api.nvim_get_hl(0, { name = "Normal" }).bg == nil, "transparent applied after setup")
ex.setup({ on_highlights = function(hl) hl.Normal.fg = "#ff0000" end })
vim.cmd.colorscheme("tokyomono-dark")
check(vim.api.nvim_get_hl(0, { name = "Normal" }).fg == 0xff0000, "on_highlights applied")

-- red is reserved for errors and Git deletions: nothing in code or kinds/icons uses it
for _, v in ipairs({ "light", "dark" }) do
  local c = ex.colors(v)
  local allowed = {
    Error = true, ErrorMsg = true, StderrMsg = true, NvimInternalError = true, SpellBad = true,
    healthError = true, RedrawDebugRecompose = true, MasonError = true, LazyTaskError = true,
    ["@comment.error"] = true, ["@lsp.type.unresolvedReference"] = true,
  }
  for n, spec in pairs(ex.highlights(v)) do
    local red = spec.fg == c.red or spec.bg == c.red or spec.sp == c.red
    local meaning = n:find("Error") or n:find("Delete") or n:find("Removed") or n:find("Remove") or n:find("minus") or n:find("Topdelete")
    check(not red or allowed[n] or meaning, ("%s: %s uses red outside errors/deletions"):format(v, n))
  end
  check(c.code.keyword == c.purple, v .. ": purple keywords")
  check(c.comment ~= c.fg and require("tokyomono.util").contrast(c.comment, c.bg) >= 4.5, v .. ": comment dimmer than fg, still AA")
end

-- ANSI: TUIs draw borders/text in white and put black text on colored
-- highlights (lazysql, htop), so both must stay readable in both variants
for _, v in ipairs({ "light", "dark" }) do
  local c = ex.colors(v)
  local a = require("tokyomono.terminal").ansi(c)
  local contrast = require("tokyomono.util").contrast
  for _, i in ipairs({ 7, 15 }) do
    check(contrast(a[i], c.bg) >= 4.5, ("%s: ansi %d readable on bg"):format(v, i))
  end
  for i = 1, 6 do
    check(contrast(a[0], a[i]) >= 4.5, ("%s: ansi 0 readable on ansi %d"):format(v, i))
  end
end

-- mono = true: pure monochrome
ex.setup({ mono = true })
vim.cmd.colorscheme("tokyomono-dark")
local nfg = vim.api.nvim_get_hl(0, { name = "Normal" }).fg
check(vim.api.nvim_get_hl(0, { name = "String", link = false }).fg == nfg, "mono: String in fg")
check(vim.api.nvim_get_hl(0, { name = "@function.call", link = false }).fg == nfg, "mono: @function.call in fg")
check(vim.api.nvim_get_hl(0, { name = "@type", link = false }).fg == nfg, "mono: @type in fg")
check(vim.api.nvim_get_hl(0, { name = "@constant.builtin", link = false }).fg == nfg, "mono: @constant.builtin in fg")
for _, g in ipairs({ "Keyword", "@keyword", "@property", "@variable.parameter", "@lsp.type.property", "@lsp.type.parameter" }) do
  check(vim.api.nvim_get_hl(0, { name = g, link = false }).fg == nfg, "mono: " .. g .. " in fg")
end
ex.setup({})

-- Compiled and direct loading must produce the same highlights.
for _, v in ipairs({ "light", "dark" }) do
  ex.setup({ cache = false })
  vim.cmd.colorscheme("tokyomono-" .. v)
  local direct = vim.api.nvim_get_hl(0, {})
  ex.setup({ cache = true })
  vim.cmd.colorscheme("tokyomono-" .. v)
  local cached = vim.api.nvim_get_hl(0, {})
  for group in pairs(ex.highlights(v)) do
    check(vim.deep_equal(direct[group], cached[group]), v .. ": cached/direct " .. group)
  end
  local c = ex.colors(v)
  check(c.git.delete == c.red, v .. ": deletions use red")
  check(vim.api.nvim_get_hl(0, { name = "StModeVisual" }).bg == tonumber(c.azure:sub(2), 16), v .. ": Visual uses azure")
end
ex.setup({})

-- highlights never produce invalid specs
for _, v in ipairs({ "light", "dark" }) do
  for n, spec in pairs(ex.highlights(v)) do
    for _, k in ipairs({ "fg", "bg", "sp" }) do
      local x = spec[k]
      check(x == nil or x == "NONE" or (type(x) == "string" and x:match("^#%x%x%x%x%x%x$")), ("%s %s.%s=%s"):format(v, n, k, tostring(x)))
    end
  end
end

print(ok_all and "ALL OK" or "FAILURES")
if not ok_all then os.exit(1) end
