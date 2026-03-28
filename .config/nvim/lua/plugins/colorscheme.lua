return {
  {
    "cocopon/iceberg.vim",
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd.colorscheme("iceberg")

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "iceberg",
        callback = function()
          -- Neo-tree パネル背景（エディタより明るく）
          vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "#272c42", fg = "#c6c8d1" })
          vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "#272c42", fg = "#c6c8d1" })
          vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "#272c42", fg = "#272c42" })

          -- 選択行
          vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = "#3d4463", bold = true })
          vim.api.nvim_set_hl(0, "NeoTreeFileName", { fg = "#c6c8d1" })
          vim.api.nvim_set_hl(0, "NeoTreeFileNameOpened", { fg = "#84a0c6", bold = true })
          vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = "#89b8c2" })
          vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = "#89b8c2" })

          -- バッファータブ
          vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { fg = "#c6c8d1", bold = true })
          vim.api.nvim_set_hl(0, "BufferLineBufferVisible", { fg = "#6b7089" })
          vim.api.nvim_set_hl(0, "BufferLineBufferInactive", { fg = "#444b71" })

          -- LSP インレイヒント（型推論）
          vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#6b7089", italic = true })
          vim.api.nvim_set_hl(0, "NonText", { fg = "#6b7089" })
        end,
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "iceberg",
    },
  },
}
