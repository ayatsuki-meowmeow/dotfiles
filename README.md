# Dotfiles Setup Guide

このプロジェクトは、macOS環境での開発を快適にするための設定ファイル群（dotfiles）を管理しています。以下の手順に従ってセットアップを行ってください。

---

## **Homebrewのインストール**

HomebrewはmacOS用のパッケージマネージャーです。このプロジェクトではHomebrewを使用して必要なツールをインストールします。

1. ターミナルを開き、以下のコマンドを実行してHomebrewをインストールします：

   ```zsh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
   ```

2. インストールが完了したら、以下のコマンドでbrewが正しく動作することを確認してください：

   ```zsh
   brew --version
   ```

## **install.shの使い方**

このプロジェクトには、dotfilesをセットアップするためのスクリプトinstall.shが含まれています。このスクリプトを実行することで、必要な設定ファイルをホームディレクトリにシンボリックリンクとして配置します。

   ```zsh
   cd ~/dotfiles
   ./install.sh
   ```

## **Brewfileについて**

1. 作成

   ```zsh
   brew bundle dump
   ```

2. インストール

   ```zsh
   brew bundle
   ```
