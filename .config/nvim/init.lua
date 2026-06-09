-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- share clipboard with OS
vim.opt.clipboard:append("unnamedplus,unnamed")

-- jj to quit insert mode
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = true, silent = true })

vim.api.nvim_create_user_command("InitLua", function()
  vim.cmd.edit(vim.fn.stdpath("config") .. "/init.lua")
end, {})

-- マシン固有設定 (dotfiles 外で管理。~/.gitconfig.local 等と同じ思想)
-- ~/.config は dotfiles への symlink なので、追跡対象外にするため ~/ 直下を読む
local local_config = vim.fn.expand("~/.nvim.local.lua")
if vim.uv.fs_stat(local_config) then
  dofile(local_config)
end
