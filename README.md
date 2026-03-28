# dotfiles

Nix flake をベースに、`nix-darwin`、`Home Manager`、`nix-homebrew` を組み合わせて macOS 環境を管理するための `dotfiles` です。

このリポジトリでは、macOS のシステム設定、Homebrew パッケージ、ユーザー単位の dotfiles を宣言的に管理します。

## 概要

- システム設定は `nix-darwin` で管理
- ユーザー環境は `Home Manager` で管理
- Homebrew は `nix-homebrew` と `homebrew` モジュールで宣言的に管理
- エントリーポイントは `flake.nix`

現状の構成は Apple Silicon 向けの 1 台構成で、ホスト名 `MacBook` を対象にしています。

## ディレクトリ構成

```text
.
├── flake.nix
├── flake.lock
├── nix-darwin
│   ├── configuration.nix
│   ├── home_manager.nix
│   └── homebrew.nix
└── home-manager
    ├── home.nix
    ├── cursor
    │   ├── cursor.nix
    │   └── settings.json
    ├── git
    │   └── .gitconfig
    ├── ghostty
    │   ├── config
    │   └── banner.txt
    ├── starship
    │   └── starship.toml
    └── zsh
        ├── .zshrc
        ├── aliases.zsh
        ├── chpwd.zsh
        └── sghq.zsh
```

各ファイルの役割は次のとおりです。

- `flake.nix`
  - flake の入力と出力を定義します。
  - `darwinConfigurations."MacBook"` がこの環境のエントリーポイントです。
- `nix-darwin/configuration.nix`
  - macOS 側の基本設定をまとめます。
  - プラットフォーム、ユーザーのホームディレクトリ、Touch ID sudo などを定義します。
- `nix-darwin/home_manager.nix`
  - `Home Manager` を `nix-darwin` に統合します。
  - ユーザー `imai` に対して `home-manager/home.nix` を読み込みます。
- `nix-darwin/homebrew.nix`
  - `nix-homebrew` と Homebrew 管理の設定です。
  - `brew` と `cask` の一覧、更新ポリシーを定義します。
- `home-manager/home.nix`
  - ユーザー単位の設定です。
  - `git`、`zsh`、`home.file` などを管理します。
  - `imports` で [home-manager/cursor/cursor.nix](home-manager/cursor/cursor.nix) を読み込みます。
- `home-manager/cursor/cursor.nix`
  - Cursor 用の Home Manager フラグメントです。
  - `nixpkgs` の `vscode-extensions.*` をまとめ、`~/.cursor/extensions` に配置します。
- `home-manager/cursor/settings.json`
  - `~/Library/Application Support/Cursor/User/settings.json` として配置される Cursor のユーザー設定です。
  - 自動保存、テーマ、フォント、Explorer/Git 周りの挙動を定義します。
- `home-manager/git/.gitconfig`
  - `~/.gitconfig` として配置される Git 設定です（`ghq` の `ghq.root` などもここに含めます）。
- `home-manager/zsh/.zshrc`
  - `~/.config/zsh/.zshrc` として配置される zsh の実体設定です。
  - Home Manager が生成する `~/.zshrc` から読み込みます。
- `home-manager/zsh/sghq.zsh`
  - `sghq` コマンドと `Ctrl+G` キーバインドを定義します。
  - `ghq list --full-path github.com` と `fzf` を使って GitHub リポジトリを選び、選択先へ移動します。
- `home-manager/zsh/chpwd.zsh`
  - Ghostty 利用時のみ、`cd` 後に `ls -laG` でディレクトリ一覧を表示します（一部ホーム直下のディレクトリは除外）。
- `home-manager/ghostty/config`
  - `~/.config/ghostty/config` として配置される Ghostty の設定です（テーマ、フォント、背景の透過・ぼかしなど）。
- `home-manager/ghostty/banner.txt`
  - `~/.config/ghostty/banner.txt` として配置される起動時バナー用の ASCII アートです。内容を変えれば表示だけ差し替えられます。

## 管理対象

このリポジトリで現在管理している主な内容は以下です。

- macOS
  - `aarch64-darwin` 向け設定
  - `sudo` での Touch ID 認証
- Homebrew
  - `google-chrome`
  - `slack`
  - `obsidian`
  - `ghostty`
  - `raycast`
  - `cursor`
  - `font-jetbrains-mono-nerd-font`
  - `tree`
- Home Manager
  - Cursor のユーザー設定（`~/Library/Application Support/Cursor/User/settings.json`）
  - Cursor の拡張機能（`~/.cursor/extensions`、定義は [home-manager/cursor/cursor.nix](home-manager/cursor/cursor.nix)）
  - `git`
  - `ghq`（パッケージと `ghq.root` などの設定は `home-manager/git/.gitconfig` の `[ghq]` に記述）
  - `zsh`（補完・`zsh-autosuggestions`・`zsh-completions` は `home-manager/home.nix` の `programs.zsh` / `home.packages`）
  - `sghq`（`fzf` + `ghq` でリポジトリ検索して移動する zsh 関数）
  - Ghostty 上での `cd` 後の自動 `ls`（`chpwd.zsh`）
  - Ghostty 起動時の zsh バナー（`GHOSTTY_RESOURCES_DIR` が設定されているインタラクティブシェルで `banner.txt` を表示）
  - Ghostty の端末設定（`~/.config/ghostty/config`）
  - `~/.gitconfig`

### Cursor

Cursor アプリ本体は Homebrew の cask（[nix-darwin/homebrew.nix](nix-darwin/homebrew.nix)）で入れ、ユーザー設定と拡張は Home Manager で宣言管理します。

- **設定**: [home-manager/cursor/settings.json](home-manager/cursor/settings.json) を編集し、`darwin-rebuild switch --flake .#MacBook` で反映します。
- **拡張**: [home-manager/cursor/cursor.nix](home-manager/cursor/cursor.nix) の `cursorExtensions` リストに `pkgs.vscode-extensions` の属性を追加・削除し、同じく `darwin-rebuild switch --flake .#MacBook` で反映します。
- **現在入れている拡張**（nixpkgs 名）: Astro、Auto Rename Tag、ESLint、GitHub Actions、GitLens、Markdown All in One、MDX、Prettier、Tailwind CSS IntelliSense、vscode-icons。

### ghq

`ghq` は Git config の `ghq.*` で動作します。`ghq.root` などは [home-manager/git/.gitconfig](home-manager/git/.gitconfig) の `[ghq]` を編集し、`darwin-rebuild switch --flake .#MacBook` で反映します。

### zsh

zsh の詳細設定は `home-manager/zsh/` に分けて管理します。現在は次を定義しています。

- `home-manager/home.nix` の `programs.zsh`
  - 補完（`enableCompletion`）
  - 履歴ベースの入力補助（`zsh-autosuggestions`）
  - 追加の補完定義（`zsh-completions` パッケージ）
- `home-manager/zsh/.zshrc`
  - Home Manager が生成する `~/.zshrc` から読み込まれるエントリーポイントです。
  - Ghostty 上では `GHOSTTY_RESOURCES_DIR` を検知したときだけ、`~/.config/ghostty/banner.txt` を Tokyo Night の青系アクセント色で表示します。
- `home-manager/zsh/aliases.zsh`
  - zsh のエイリアス定義です。
- `home-manager/zsh/sghq.zsh`
  - `sghq` コマンド
  - `Ctrl+G` キーバインド
- `home-manager/zsh/chpwd.zsh`
  - `chpwd` フック（Ghostty かつ除外ディレクトリ以外で `ls -laG`）

`sghq` または `Ctrl+G` で `fzf` が開き、`ghq` 管理下の GitHub リポジトリを選ぶと、そのディレクトリへ移動できます。

## 前提条件

この設定は、次の前提で作られています。

- macOS を利用していること
- Apple Silicon 環境であること
- Nix が導入済みで、flakes が利用できること
- `nix-darwin` が利用できること
- ユーザー名が `imai`、ホームディレクトリが `/Users/imai` であること

別ユーザーや別ホストで使う場合は、そのままでは動かない箇所があります。詳しくは「カスタマイズが必要な箇所」を参照してください。

## セットアップ

### 1. リポジトリを配置する

任意の場所に clone します。

```bash
git clone <your-repo-url> ~/ghq/github.com/imai/dotfiles
cd ~/ghq/github.com/imai/dotfiles
```

`~/ghq` は一例です。任意のパスで構いません。

### 2. 設定を反映する

リポジトリのルートで次を実行します。

```bash
darwin-rebuild switch --flake .#MacBook
```

これにより、`flake.nix` の `darwinConfigurations."MacBook"` が評価され、`nix-darwin`、`Home Manager`、Homebrew 設定がまとめて反映されます。

## 日常運用

設定を変更したあとの基本操作は次のとおりです。

### 設定を反映する

```bash
darwin-rebuild switch --flake .#MacBook
```

### flake 入力を更新する

```bash
nix flake update
darwin-rebuild switch --flake .#MacBook
```

`flake.lock` が更新されるため、依存する `nixpkgs` や各入力のバージョンを追従できます。

### flake を確認する

```bash
nix flake check
```

定義内容の確認に使えます。出力が少ない構成でも、評価確認として有用です。

## カスタマイズが必要な箇所

このリポジトリには、現在の利用環境に合わせた固定値がいくつかあります。

### ホスト名

`flake.nix` では次のようにホストを定義しています。

```nix
darwinConfigurations."MacBook" = nix-darwin.lib.darwinSystem { ... };
```

別名のホストで運用したい場合は、この属性名に合わせて `darwin-rebuild switch --flake .#<host>` の `<host>` を変更します。

### ユーザー名とホームディレクトリ

以下の設定は `imai` と `/Users/imai` を前提にしています。

- `nix-darwin/configuration.nix`
- `nix-darwin/home_manager.nix`
- `nix-darwin/homebrew.nix`
- `home-manager/home.nix`

別ユーザーで使う場合は、これらの値を変更してください。

### アーキテクチャ

`nix-darwin/configuration.nix` では次を指定しています。

```nix
nixpkgs.hostPlatform = "aarch64-darwin";
```

Intel Mac で利用する場合は、環境に合わせて見直しが必要です。

## Homebrew 管理について

Homebrew は `nix-darwin/homebrew.nix` で管理しています。

ポイントは次のとおりです。

- `nix-homebrew.enable = true`
- `homebrew.enable = true`
- `onActivation.upgrade = true`
- `onActivation.cleanup = "uninstall"`
- `global.autoUpdate = false`

このため、設定反映時に必要なアップグレードが行われ、設定から外れたパッケージは削除対象になります。Homebrew を手作業で追加・削除する運用とは少し挙動が異なるため注意してください。

## 注意点

### `nix.enable = false` について

`nix-darwin/configuration.nix` では `nix.enable = false` になっています。

これは、この設定ファイル側で Nix 自体の有効化を行っていない、という意味です。Nix の導入方法や管理方法は、手元のインストール手順に依存します。

### 秘密情報管理は未導入

現状、このリポジトリには `sops`、`agenix` などの秘密情報管理の仕組みは入っていません。

また、`home-manager/git/.gitconfig` には Git のユーザー名とメールアドレスが含まれています。公開範囲や共有方法には注意してください。

## 変更時の見方

どこを変更すればよいか迷ったときは、次を目安にすると分かりやすいです。

- macOS 全体の挙動を変えたい: `nix-darwin/configuration.nix`
- Homebrew アプリを追加したい: `nix-darwin/homebrew.nix`
- CLI ツールや dotfiles を追加したい: `home-manager/home.nix`
- Ghostty の見た目やバナー文言を変えたい: `home-manager/ghostty/config` と `home-manager/ghostty/banner.txt`
- Git や `ghq` の設定を変更したい: `home-manager/git/.gitconfig`

## 今後の拡張候補

- ホストごとに設定を分ける
- ユーザー名やホームパスを共通変数化する
- シークレット管理を導入する
- 開発ツールやシェル設定を `Home Manager` 側で拡充する
