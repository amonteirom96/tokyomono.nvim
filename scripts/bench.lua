-- nvim --headless -u NONE --cmd "set rtp^=." -l scripts/bench.lua
require("tokyomono").clear_cache()
local hr = vim.uv.hrtime
local function ms(t) return (hr() - t) / 1e6 end

local t = hr()
vim.cmd.colorscheme("tokyomono-dark")
print(("cold (build + compile + write): %.3f ms"):format(ms(t)))

local N = 200
t = hr()
for _ = 1, N do vim.cmd.colorscheme("tokyomono-dark") end
print(("cached (avg of %d):             %.3f ms"):format(N, ms(t) / N))

t = hr()
for _ = 1, N do vim.cmd.colorscheme("habamax") end
print(("reference: habamax (avg):      %.3f ms"):format(ms(t) / N))
