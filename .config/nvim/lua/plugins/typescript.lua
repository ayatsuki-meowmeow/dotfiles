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

  -- vtsls: ファイル移動時のimport自動更新を有効化 + drizzle等の複雑な型への対応
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              -- drizzle-ormの複雑な型推論のためメモリ上限を引き上げ
              tsserver = {
                maxTsServerMemory = 4096,
              },
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
