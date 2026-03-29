# dotfiles

> English version: [README.md](README.md)

## 概要

Nix Flake をベースに macOS 環境を宣言的に管理する dotfiles です。

`nix-darwin` でシステム設定、`Home Manager` でユーザー環境、`nix-homebrew` で GUI アプリを管理し、`flake.nix` をエントリーポイントとしてすべてを統合しています。

Apple Silicon Mac 1 台構成を前提としており、`sudo darwin-rebuild switch --flake .#imaikosuke` の 1 コマンドで環境全体を再現できます。

## 前提条件

- macOS（Apple Silicon）
- Nix がインストール済みで flakes が有効になっていること
- nix-darwin が利用できること

## ディレクトリ構成

```text
.
├── flake.nix                          # エントリーポイント
├── flake.lock
├── nix-darwin/
│   ├── configuration.nix              # macOS システム設定
│   ├── home_manager.nix               # Home Manager 統合
│   └── homebrew.nix                   # Homebrew パッケージ管理
└── home-manager/
    ├── home.nix                       # ユーザー環境の設定
    ├── cursor/
    │   ├── cursor.nix                 # Cursor 拡張機能
    │   └── settings.json              # Cursor ユーザー設定
    ├── git/
    │   └── .gitconfig                 # Git / ghq 設定
    ├── ghostty/
    │   ├── config                     # Ghostty 端末設定
    │   └── banner.txt                 # 起動時バナー
    ├── starship/
    │   └── starship.toml              # Starship プロンプト設定
    └── zsh/
        ├── .zshrc                     # zsh エントリーポイント
        ├── aliases.zsh                # エイリアス定義
        ├── chpwd.zsh                  # cd 後の自動 ls
        └── sghq.zsh                   # ghq + fzf リポジトリ移動
```

## 管理内容

### nix-darwin — macOS システム設定

| 項目 | 内容 |
|------|------|
| プラットフォーム | `aarch64-darwin` |
| Touch ID sudo | `security.pam.services.sudo_local.touchIdAuth` で有効化 |

### nix-homebrew — GUI アプリ（cask）

Homebrew は宣言的に管理されており、設定から外れたパッケージは自動で削除されます。

| cask |
|------|
| google-chrome |
| slack |
| obsidian |
| ghostty |
| raycast |
| cursor |
| font-jetbrains-mono-nerd-font |

### Home Manager — CLI ツールとユーザー設定

**Nix パッケージ**

| パッケージ | 用途 |
|-----------|------|
| bat | cat の代替 |
| git | バージョン管理 |
| ghq | リポジトリ管理 |
| tree | ディレクトリツリー表示 |
| zsh-completions | zsh 追加補完 |

**programs（Home Manager モジュール）**

| プログラム | 設定内容 |
|-----------|---------|
| zsh | 補完、autosuggestion、`~/.config/zsh/.zshrc` の読み込み |
| fzf | zsh 連携有効 |
| mise | zsh 連携有効、プロジェクトごとのランタイム/ツール版管理 |
| starship | zsh 連携有効、`starship.toml` でカスタマイズ |

**dotfiles（`home.file` でシンボリックリンク）**

| 配置先 | ソース |
|--------|--------|
| `~/.gitconfig` | `home-manager/git/.gitconfig` |
| `~/.config/starship.toml` | `home-manager/starship/starship.toml` |
| `~/.config/zsh/` | `home-manager/zsh/` |
| `~/.config/ghostty/config` | `home-manager/ghostty/config` |
| `~/.config/ghostty/banner.txt` | `home-manager/ghostty/banner.txt` |
| `~/Library/Application Support/Cursor/User/settings.json` | `home-manager/cursor/settings.json` |
| `~/.cursor/extensions/` | Nix でビルドした拡張機能 |

**Cursor 拡張機能（nixpkgs）**

Astro, Auto Rename Tag, ESLint, GitHub Actions, GitLens, Markdown All in One, MDX, Prettier, Tailwind CSS IntelliSense, vscode-icons

## 初期セットアップ

### 1. Nix をインストールする

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. リポジトリをクローンする

```bash
git clone git@github.com:imaikosuke/dotfiles.git ~/ghq/github.com/imaikosuke/dotfiles
cd ~/ghq/github.com/imaikosuke/dotfiles
```

### 3. 設定を反映する

```bash
sudo darwin-rebuild switch --flake .#imaikosuke
```

これにより nix-darwin、Home Manager、Homebrew の設定がまとめて反映されます。

### 4. 日常の運用

```bash
# 設定変更を反映
sudo darwin-rebuild switch --flake .#imaikosuke

# flake 入力を更新してから反映
nix flake update && sudo darwin-rebuild switch --flake .#imaikosuke
```
