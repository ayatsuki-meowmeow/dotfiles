-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 絶対パスを表示
vim.keymap.set("n", "<leader>fp", function()
  vim.notify(vim.fn.expand("%:p"), vim.log.levels.INFO, { title = "Absolute path" })
end, { desc = "Show absolute path" })

-- 絶対パスをクリップボードにコピー
vim.keymap.set("n", "<leader>fy", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify(path, vim.log.levels.INFO, { title = "Copied absolute path" })
end, { desc = "Copy absolute path" })

-- プロジェクト名始まりの相対パスをコピー（先頭がプロジェクト名）
vim.keymap.set("n", "<leader>fY", function()
  local root = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  local rel = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
  local path = root .. "/" .. rel
  vim.fn.setreg("+", path)
  vim.notify(path, vim.log.levels.INFO, { title = "Copied project path" })
end, { desc = "Copy project-relative path" })
