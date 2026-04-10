local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { "LazyVim/LazyVim", import = "lazyvim.plugins.extras.lang.typescript" },
    { "LazyVim/LazyVim", import = "lazyvim.plugins.extras.lang.tailwind" },
    { "LazyVim/LazyVim", import = "lazyvim.plugins.extras.lang.go" },
    {
      "shellRaining/hlchunk.nvim",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        require("hlchunk").setup({
          chunk = { enable = true },
          indent = { enable = true },
          line_num = { enable = true },
        })
      end,
    },
    {
      "dnlhc/glance.nvim",
      cmd = "Glance",
      keys = {
        { "gR", "<cmd>Glance references<cr>", desc = "Glance References" },
        { "gD", "<cmd>Glance definitions<cr>", desc = "Glance Definitions" },
        { "gY", "<cmd>Glance type_definitions<cr>", desc = "Glance Type Definitions" },
        { "gM", "<cmd>Glance implementations<cr>", desc = "Glance Implementations" },
      },
    },
    {
      "bassamsdata/namu.nvim",
      opts = {
        global = {},
        namu_symbols = {
          options = {},
        },
      },
      keys = {
        { "<leader>ss", "<cmd>Namu symbols<cr>", desc = "Jump to LSP symbol" },
        { "<leader>sw", "<cmd>Namu workspace<cr>", desc = "LSP Symbols - Workspace" },
      },
    },
    {
      "OXY2DEV/markview.nvim",
      lazy = false,

      -- Completion for `blink.cmp`
      -- dependencies = { "saghen/blink.cmp" },
    },
    {
      "okuuva/auto-save.nvim",
      event = { "InsertLeave", "TextChanged" },
      opts = {
        enabled = true,
        debounce_delay = 2000, -- 2秒待ってから保存（auto-formatと併用するなら長めが安定）
        -- 保存したくないファイルタイプを除外
        condition = function(buf)
          local filetype = vim.fn.getbufvar(buf, "&filetype")
          -- gitcommitやharpoonなど保存不要なものは除外
          if vim.list_contains({ "gitcommit", "gitrebase" }, filetype) then
            return false
          end
          return true
        end,
      },
    },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "iceberg", "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
