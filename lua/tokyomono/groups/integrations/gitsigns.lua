--- gitsigns: add = green, change = blue, delete = orange.
---@param c tokyomono.Colors
---@param o tokyomono.Config
return function(c, o)
  local blend = require("tokyomono.util").blend
  local hl = {
    GitSignsCurrentLineBlame = { fg = c.muted, italic = true },
    GitSignsVirtLnum = { fg = c.muted },
    GitSignsNoEOLPreview = { fg = c.muted },
  }

  local sets = {
    Add = c.git.add,
    Change = c.git.change,
    Delete = c.git.delete,
    Changedelete = c.git.change,
    Topdelete = c.git.delete,
    Untracked = c.git.add,
  }

  for kind, color in pairs(sets) do
    local tint = blend(color, c.bg, 0.14)
    local ln = blend(color, c.bg, kind == "Change" and 0.10 or 0.13)
    local g = "GitSigns" .. kind
    hl[g] = { fg = color }
    hl[g .. "Nr"] = { fg = color, bg = tint, bold = true }
    hl[g .. "Ln"] = { bg = ln }
    hl[g .. "Cul"] = { fg = color, bg = c.surface1 }
    hl[g .. "Preview"] = { bg = ln }
    hl[g .. "Inline"] = { bg = blend(color, c.bg, 0.30) }
    hl[g .. "LnInline"] = { bg = blend(color, c.bg, 0.30) }
    hl[g .. "VirtLn"] = { bg = ln }
    hl[g .. "VirtLnInline"] = { bg = blend(color, c.bg, 0.30) }
    -- staged: same hue, quieter
    local staged = blend(color, c.bg, 0.55)
    hl["GitSignsStaged" .. kind] = { fg = staged }
    hl["GitSignsStaged" .. kind .. "Nr"] = { fg = staged, bg = blend(color, c.bg, 0.07) }
    hl["GitSignsStaged" .. kind .. "Ln"] = { bg = blend(color, c.bg, 0.07) }
  end
  hl.GitSignsDeleteVirtLn = { fg = c.git.delete, bg = blend(c.git.delete, c.bg, 0.13) }

  return hl
end
