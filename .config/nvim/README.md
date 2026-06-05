# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

---

## 📝 チートシート

`<leader>` は **Space** キー。picker は **snacks.picker**。

### プロジェクト全体を grep（全文検索）

| キー | 動作 |
|------|------|
| `<Space>/` / `<Space>sg` | ルートディレクトリ全体をライブ grep（開いて検索語を入力） |
| `<Space>sG` | cwd 基準で grep |
| Visual 選択 → `<Space>sg` | 選択した文字列で grep |

> ⚠️ LazyVim 標準の `<Space>sw`（カーソル下の単語を grep）は、この設定では
> namu.nvim の「LSP workspace symbols」に上書きされている（`lua/config/lazy.lua`）。

### ファイルパスの確認・コピー（`lua/config/keymaps.lua` で定義）

| キー | 動作 |
|------|------|
| `<Space>fp` | 絶対パスを画面に表示 |
| `<Space>fy` | 絶対パスをクリップボードにコピー |
| `<Space>fY` | プロジェクト名始まりの相対パスをコピー（例: `dotfiles/.config/nvim/init.lua`） |

標準コマンドで確認する場合:

- `1<C-g>` … ステータス行にフルパス表示
- `:echo expand('%:p')` … 絶対パス
- `:echo expand('%')` … cwd 基準の相対パス

### 依存コマンド（必須）

snacks.picker の grep / ファイル検索は外部バイナリを直接 spawn する。
**シェルのエイリアス/関数ではなく実バイナリが PATH 上に必要。**

```sh
brew install ripgrep fd
```

- `rg`（ripgrep）… grep に必須。未インストールだと `Failed to spawn rg` エラー
- `fd` … ファイル検索の高速化

> 確認: `which -a rg` がフルパス（例 `/opt/homebrew/bin/rg`）を返せば OK。
> `rg` のみが返る場合はエイリアス/関数なので nvim からは見えない。
