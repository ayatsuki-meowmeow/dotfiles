#!/bin/bash
set -eu # -e を追加してエラー時に即時終了

# 実行場所のディレクトリを取得 (スクリプトが ~/dotfiles にある前提)
THIS_DIR=$(cd $(dirname $0); pwd)

# dotfiles ディレクトリのパスを明確にする (ホームディレクトリからの相対パスなど)
# もしスクリプトが ~/dotfiles にあるなら、これで ~/dotfiles が入る
DOTFILES_DIR="$THIS_DIR"
# もしくは絶対パスを指定しても良い
# DOTFILES_DIR="$HOME/dotfiles"

# スクリプトが置かれているディレクトリに移動
cd "$THIS_DIR" || exit 1 # cd に失敗したら終了

# Git サブモジュールの初期化・更新 (必要なら)
if [ -f .gitmodules ]; then
  echo "Initializing/Updating Git submodules..."
  git submodule init
  git submodule update --init --recursive # --init --recursive を追加するとより確実
fi

echo "Starting setup..."

# dotfiles ディレクトリ内のファイルをループ処理
for f in .??*; do
    # シンボリックリンクを作成したくないファイル/ディレクトリを除外
    case "$f" in
        .git | .gitmodules | .gitignore | .gitconfig.local.template | README.md | LICENSE | install.sh | .ssh | .claude ) # スクリプト名やREADMEなどを追加
            echo "Skipping $f"
            continue
            ;;
    esac

    # シンボリックリンクを作成 (リンク元: dotfilesディレクトリ内のファイル, リンク先: ホームディレクトリ)
    ln -snfv "$DOTFILES_DIR/$f" "$HOME/$f"

done

echo "Linking process finished."

# .ssh/config の個別処理
if [ -f "$DOTFILES_DIR/.ssh/config" ]; then
    echo "Setting up .ssh/config..."
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    ln -snfv "$DOTFILES_DIR/.ssh/config" "$HOME/.ssh/config"
    chmod 600 "$HOME/.ssh/config"
fi

# .ssh/config.local の処理
if [ ! -e "$HOME/.ssh/config.local" ] && [ -e "$DOTFILES_DIR/.ssh/config.local.template" ]; then
    echo "Creating ~/.ssh/config.local from template..."
    cp "$DOTFILES_DIR/.ssh/config.local.template" "$HOME/.ssh/config.local"
    chmod 600 "$HOME/.ssh/config.local"
    echo "Please edit ~/.ssh/config.local to add your private SSH configurations."
fi

# .claude/CLAUDE.md の個別処理 (ディレクトリは丸ごとリンクせず、ファイル単位で配置)
if [ -f "$DOTFILES_DIR/.claude/CLAUDE.md" ]; then
    echo "Setting up .claude/CLAUDE.md..."
    mkdir -p "$HOME/.claude"
    ln -snfv "$DOTFILES_DIR/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
fi

# .claude/hooks/commit-workflow-reminder.sh の個別処理
# フックスクリプトは symlink で配置し、settings.json には jq で冪等マージする。
# settings.json は各マシン固有の実体ファイルとして維持する（symlink しない）:
#   - 既に存在する場合 -> PreToolUse フック定義を追記マージ（重複登録しない）
#   - 存在しない場合   -> 空オブジェクトから新規作成してマージ
if [ -f "$DOTFILES_DIR/.claude/hooks/commit-workflow-reminder.sh" ]; then
    echo "Setting up commit-workflow reminder hook..."
    mkdir -p "$HOME/.claude/hooks"
    ln -snfv "$DOTFILES_DIR/.claude/hooks/commit-workflow-reminder.sh" "$HOME/.claude/hooks/commit-workflow-reminder.sh"

    SETTINGS="$HOME/.claude/settings.json"
    HOOK_CMD="$HOME/.claude/hooks/commit-workflow-reminder.sh"
    if which jq >/dev/null 2>&1; then
        [ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"
        TMP_SETTINGS=$(mktemp)
        # 既存の同一 command エントリを除去してから追記することで冪等にする
        jq --arg cmd "$HOOK_CMD" '
          .hooks //= {} |
          .hooks.PreToolUse = (
            [ (.hooks.PreToolUse // [])[]
              | select(((.hooks // []) | map(.command) | index($cmd)) | not) ]
            + [ { matcher: "Bash", hooks: [ { type: "command", command: $cmd } ] } ]
          )
        ' "$SETTINGS" > "$TMP_SETTINGS" && mv "$TMP_SETTINGS" "$SETTINGS"
        echo "  -> commit-workflow hook を $SETTINGS に登録しました"
    else
        echo "  -> jq が見つかりません。$SETTINGS に PreToolUse フックを手動で追加してください"
    fi
fi

# .gitconfig.local の処理
if [ ! -e "$HOME/.gitconfig.local" ] && [ -e "$DOTFILES_DIR/.gitconfig.local.template" ]; then
    echo "Creating ~/.gitconfig.local from template..."
    cp "$DOTFILES_DIR/.gitconfig.local.template" "$HOME/.gitconfig.local"
fi

# cmux config の処理
if [ -f "$DOTFILES_DIR/.config/ghostty/config" ]; then
    echo "Setting up cmux config..."
    mkdir -p "$HOME/Library/Application Support/com.cmuxterm.app"
    ln -snfv "$DOTFILES_DIR/.config/ghostty/config" "$HOME/Library/Application Support/com.cmuxterm.app/config.ghostty"
fi

# Emacs / Cask の処理 (必要なら)
if [ -d "$THIS_DIR/.emacs.d" ] && which cask >/dev/null 2>&1; then
  echo "Setting up .emacs.d..."
  cd "$THIS_DIR/.emacs.d" || exit 1
  cask upgrade || echo "Cask upgrade failed, continuing..." # エラーでも止めない場合
  cask install || echo "Cask install failed, continuing..." # エラーでも止めない場合
  cd "$THIS_DIR" # 元のディレクトリに戻る
fi

# fzf-git.sh の処理
echo "Installing fzf-git.sh..."
curl -sfo "$HOME/.fzf-git.sh" https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh

# Brewfile の処理 (必要なら)
if which brew >/dev/null 2>&1; then
    echo "Running brew bundle..."
    brew bundle --verbose --file="$DOTFILES_DIR/Brewfile"
else
    echo "Homebrew not found, skipping brew bundle."
fi

# gh extensions の処理
if which gh >/dev/null 2>&1; then
    echo "Installing gh extensions..."
    gh extension install seachicken/gh-poi
fi

cat << END

**************************************************
DOTFILES SETUP FINISHED! bye.
**************************************************

END

exit 0
