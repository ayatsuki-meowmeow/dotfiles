-- Go 開発環境
-- LazyVim の lang.go extra (config/lazy.lua で import 済み) をベースに、
-- プロジェクトの gofmt/goimports/golangci-lint 運用に合わせて調整する。
--
-- LazyVim デフォルトからの主な変更点:
--   - conform.nvim の整形を { goimports } のみに (gofumpt を外す)
--     -> goimports は内部で gofmt 相当の整形も行うため、これだけで gofmt+imports を満たす
--   - gopls の gofumpt オプションを無効化
--   - golangci-lint は Homebrew 版に統一 (CI と同一バイナリ)
--     -> Mason の ensure_installed から除外し、nvim-lint の cmd を Homebrew パスに固定
--
-- そのまま利用される (extra が既にセットアップ済み) 機能:
--   - gopls (LSP): 補完・go-to-definition・hover・staticcheck・inlay hints 等
--   - nvim-lint による golangci-lint 実行 (BufWritePost/BufReadPost/InsertLeave)
--   - Mason による goimports / gopls の自動インストール

-- Homebrew の golangci-lint パスを解決する (Apple Silicon / Intel 双方対応)
local function resolve_brew_golangcilint()
  for _, path in ipairs({ "/opt/homebrew/bin/golangci-lint", "/usr/local/bin/golangci-lint" }) do
    if vim.uv.fs_stat(path) then
      return path
    end
  end
  return nil
end

return {
  -- gopls: gofumpt 強制を無効化
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = false,
            },
          },
        },
      },
    },
  },

  -- conform.nvim: 保存時整形は goimports のみ (= gofmt + import 整理)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "goimports" },
      },
    },
  },

  -- Mason: golangci-lint は Homebrew で管理するため、自動インストール対象から外す
  -- (lang.go extra が ensure_installed に追加してくるため、opts 関数で除去する)
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(tool)
        return tool ~= "golangci-lint"
      end, opts.ensure_installed or {})
    end,
  },

  -- nvim-lint: golangci-lint の実行バイナリを Homebrew 版に固定
  -- Mason は bin ディレクトリを PATH の先頭に prepend するため、
  -- 明示的に絶対パスを指定しないと Mason 版 (古い) を拾ってしまう。
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local brew_bin = resolve_brew_golangcilint()
      if brew_bin then
        opts.linters = opts.linters or {}
        opts.linters.golangcilint = vim.tbl_deep_extend("force", opts.linters.golangcilint or {}, {
          cmd = brew_bin,
        })
      end
    end,
  },
}
