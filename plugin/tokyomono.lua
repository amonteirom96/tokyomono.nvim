if vim.g.loaded_tokyomono then
  return
end
vim.g.loaded_tokyomono = true

local cmd = vim.api.nvim_create_user_command

cmd("TokyomonoCompile", function()
  require("tokyomono").compile()
end, { desc = "tokyomono: rebuild the compiled highlight cache" })

cmd("TokyomonoClearCache", function()
  require("tokyomono").clear_cache()
end, { desc = "tokyomono: delete the compiled highlight cache" })

cmd("TokyomonoExtras", function(args)
  local out = require("tokyomono").extras(args.args ~= "" and args.args or nil)
  vim.notify("tokyomono: extras written to " .. out)
end, { nargs = "?", complete = "dir", desc = "tokyomono: generate ghostty/kitty/lazygit themes" })
