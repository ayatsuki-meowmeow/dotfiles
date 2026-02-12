-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- share clipboard with OS
vim.opt.clipboard:append("unnamedplus,unnamed")

-- jj to quit insert mode
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = true, silent = true })

vim.api.nvim_create_user_command("InitLua", function()
  vim.cmd.edit(vim.fn.stdpath("config") .. "/init.lua")
end, {})
