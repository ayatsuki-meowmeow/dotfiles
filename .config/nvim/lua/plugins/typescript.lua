return {
  -- neo-tree等でファイル移動/リネームした際にLSPへ通知してimportを自動修正
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim",
    },
    event = "BufReadPre",
    config = function()
      require("lsp-file-operations").setup()
    end,
  },

  -- vtsls: ファイル移動時のimport自動更新を有効化
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
            },
            javascript = {
              updateImportsOnFileMove = { enabled = "always" },
            },
          },
        },
      },
    },
  },
}
