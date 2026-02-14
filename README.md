# Neovim 設定マニュアル

## インストール

```bash
git clone git@github.com:tkdhss111/nvim.git
```

HTTPS の場合:

```bash
git clone https://github.com/tkdhss111/nvim.git
```

### 自動セットアップ（推奨）

リポジトリに含まれる `install.sh` を実行すると、必要な依存パッケージのインストールからシンボリックリンクの作成、プラグインの初期化まで一括で行えます。

```bash
cd nvim/.config/nvim
chmod +x install.sh
./install.sh
```

**install.sh が行うこと:**

1. システムパッケージのインストール（git, ripgrep, ctags, build-essential 等）
2. Neovim のバージョン確認・インストール（>= 0.11 必須）
3. Node.js のインストール（nvm 経由、v22）
4. Python ツールのインストール（black, isort）
5. Node.js ツールのインストール（prettier）
6. StyLua（Lua フォーマッター）のインストール
7. R 言語サーバーのインストール
8. DuckDB のインストール（オプション、parquet プレビュー用）
9. Claude Code CLI のインストール（オプション）
10. 設定ファイルのシンボリックリンク作成（`~/.config/nvim`）
11. 必要なディレクトリの作成（`~/VIM_BACKUP_FILES` 等）
12. ctags の Modern Fortran 対応設定
13. プラグイン・Tree-sitter パーサー・Mason ツールのヘッドレスインストール（オプション）

**対応OS:** Ubuntu / Debian 系（その他の Linux でも手動調整で対応可能）

### 手動セットアップ

Neovim の設定ファイルはリポジトリ内の `.config/nvim/` にあります。
`~/.config/nvim` へシンボリックリンクを作成してください。

```bash
ln -s /path/to/nvim/.config/nvim ~/.config/nvim
```

例（クローン先が `~/nvim` の場合）:

```bash
ln -s ~/nvim/.config/nvim ~/.config/nvim
```

既に `~/.config/nvim` が存在する場合は、先にバックアップしてください:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
ln -s ~/nvim/.config/nvim ~/.config/nvim
```

## 概要

この設定は **lazy.nvim** をプラグインマネージャーとして使用し、**tokyonight-night** カラースキームを採用しています。

**リーダーキー:** `,`（カンマ）

---

## キーボードショートカット一覧

### ナビゲーション - カーソル移動

| ショートカット | モード | 動作 |
|----------------|--------|------|
| `Ctrl+h` | Normal/Visual | 行頭へ移動（`0`と同じ） |
| `Ctrl+l` | Normal/Visual | 行末へ移動（`$`と同じ） |
| `Ctrl+j` | Normal | 5行下へ移動 |
| `Ctrl+k` | Normal | 5行上へ移動 |
| `Ctrl+o` | Normal | 前のジャンプ位置に戻る（バッファ間移動も可） |
| `Ctrl+i` | Normal | 次のジャンプ位置に進む |

### 行・選択範囲の移動 (mini.move)

| ショートカット | モード | 動作 |
|----------------|--------|------|
| `Alt+j` | Normal/Visual | 行/選択範囲を下へ移動 |
| `Alt+k` | Normal/Visual | 行/選択範囲を上へ移動 |
| `Alt+h` | Normal/Visual | 行/選択範囲を左へ移動 |
| `Alt+l` | Normal/Visual | 行/選択範囲を右へ移動 |

### インサートモード補助

| ショートカット | 動作 |
|----------------|------|
| `Ctrl+l` | デリート |
| `Ctrl+j` | カーソルを下へ |
| `Ctrl+k` | カーソルを上へ |
| `Space` | インサートモードへ（ノーマルから） |

*注: `Ctrl+h` はスニペットのジャンプ（前のプレースホルダ）に予約されています。*

### ウィンドウ操作

| ショートカット | 動作 |
|----------------|------|
| `Shift+h` | 左のウィンドウへ移動 |
| `Shift+j` | 下のウィンドウへ移動 |
| `Shift+k` | 上のウィンドウへ移動 |
| `Shift+l` | 右のウィンドウへ移動 |
| `Shift+Up` | ウィンドウの高さを縮小 |
| `Shift+Down` | ウィンドウの高さを拡大 |
| `Shift+Left` | ウィンドウの幅を縮小 |
| `Shift+Right` | ウィンドウの幅を拡大 |

### タブ操作

| ショートカット | 動作 |
|----------------|------|
| `,tn` | 新しいタブを開く |
| `,tc` | タブを閉じる |
| `,to` | 他のタブをすべて閉じる |
| `Tab` | 次のタブへ移動 |
| `Shift+Tab` | 前のタブへ移動 |

### テキストオブジェクト操作（Vim 標準）

`y`（ヤンク）、`d`（削除）、`c`（変更）などのオペレータと `i`（内側）/ `a`（外側）を組み合わせて、括弧や引用符で囲まれたテキストを操作できます。

**`yi` — 内側をヤンク（yank inside）:**

| コマンド | 動作 | 例 |
|----------|------|----|
| `yi)` or `yi(` | `()` 内のテキストをヤンク | `func(abc)` → `abc` をヤンク |
| `yi]` or `yi[` | `[]` 内のテキストをヤンク | `arr[123]` → `123` をヤンク |
| `yi}` or `yi{` | `{}` 内のテキストをヤンク | `{key: val}` → `key: val` をヤンク |
| `yi"` | `""` 内のテキストをヤンク | `"hello"` → `hello` をヤンク |
| `yi'` | `''` 内のテキストをヤンク | `'world'` → `world` をヤンク |
| `` yi` `` | `` `` `` 内のテキストをヤンク | `` `code` `` → `code` をヤンク |
| `yit` | HTMLタグ内のテキストをヤンク | `<p>text</p>` → `text` をヤンク |
| `yiw` | カーソル上の単語をヤンク | `hello` → `hello` をヤンク |

**`ya` — 外側をヤンク（yank around）:**

| コマンド | 動作 | 例 |
|----------|------|----|
| `ya)` | `()` を含めてヤンク | `func(abc)` → `(abc)` をヤンク |
| `ya"` | `""` を含めてヤンク | `"hello"` → `"hello"` をヤンク |

**`vi` — 内側を選択（visual inside）:**

| コマンド | 動作 | 例 |
|----------|------|----|
| `vi)` or `vi(` | `()` 内のテキストを選択 | `func(abc)` → `abc` を選択 |
| `vi]` or `vi[` | `[]` 内のテキストを選択 | `arr[123]` → `123` を選択 |
| `vi}` or `vi{` | `{}` 内のテキストを選択 | `{key: val}` → `key: val` を選択 |
| `vi"` | `""` 内のテキストを選択 | `"hello"` → `hello` を選択 |
| `vi'` | `''` 内のテキストを選択 | `'world'` → `world` を選択 |
| `vit` | HTMLタグ内のテキストを選択 | `<p>text</p>` → `text` を選択 |
| `viw` | カーソル上の単語を選択 | `hello` → `hello` を選択 |

**`va` — 外側を選択（visual around）:**

| コマンド | 動作 | 例 |
|----------|------|----|
| `va)` | `()` を含めて選択 | `func(abc)` → `(abc)` を選択 |
| `va"` | `""` を含めて選択 | `"hello"` → `"hello"` を選択 |
| `va{` | `{}` を含めて選択 | `{key: val}` → `{key: val}` を選択 |
| `vat` | HTMLタグを含めて選択 | `<p>text</p>` → `<p>text</p>` を選択 |

**`di` / `ci` / `da` / `ca` — 削除・変更との組み合わせ:**

| コマンド | 動作 |
|----------|------|
| `di)` | `()` 内のテキストを削除 |
| `ci"` | `""` 内のテキストを削除して挿入モードへ |
| `da]` | `[]` を含めて削除 |
| `ca{` | `{}` を含めて削除して挿入モードへ |

### テキスト操作

| ショートカット | 動作 |
|----------------|------|
| `ciy` | ヤンクしたテキストで単語を置換 |
| `Ctrl+p` | ヤンクしたテキストで単語を置換 |
| `cy` | ヤンクしたテキストで行を置換 |
| `,ww` | 折り返しの切り替え |

### ファイルエクスプローラー (NERDTree)

**グローバルショートカット:**

| ショートカット | 動作 |
|----------------|------|
| `Ctrl+n` | NERDTree の表示/非表示 |
| `Ctrl+c` | 現在のファイルを NERDTree で表示 |
| `Shift+r` | NERDTree を更新 |

**NERDTree 内 - ファイルを開く:**

| ショートカット | 動作 |
|----------------|------|
| `Enter` または `o` | 現在のウィンドウで開く |
| `s` | 縦分割で開く |
| `i` | 横分割で開く |
| `t` | 新しいタブで開く |
| `go` | プレビュー（カーソルは NERDTree に残る） |
| `gi` | 横分割でプレビュー |
| `gs` | 縦分割でプレビュー |

**NERDTree 内 - ファイル操作:**

| ショートカット | 動作 |
|----------------|------|
| `m` | ファイルメニューを開く（作成/削除/移動/コピー） |
| `a` | 新規ファイル作成（メニュー経由） |
| `d` | ファイル削除（メニュー経由） |
| `m` | ファイル名変更/移動（メニュー経由） |
| `c` | ファイルコピー（メニュー経由） |

**NERDTree 内 - ナビゲーション:**

| ショートカット | 動作 |
|----------------|------|
| `u` | 親ディレクトリへ移動 |
| `C` | 選択したディレクトリをルートに変更 |
| `R` | ツリーを更新 |
| `I` | 隠しファイルの表示/非表示 |
| `?` | ヘルプの表示/非表示 |

### バッファ内検索（Vim 標準）

| コマンド | 動作 |
|----------|------|
| `/{pattern}` | 前方検索 |
| `?{pattern}` | 後方検索 |
| `n` | 次の一致へ移動 |
| `N` | 前の一致へ移動 |
| `*` | カーソル下の単語を前方検索 |
| `#` | カーソル下の単語を後方検索 |

### 検索・置換 (Ferret)

バックエンドに `rg` (ripgrep) を使用。隠しファイルも検索対象、`build/` は除外。

| コマンド | 動作 |
|----------|------|
| `:Ack {pattern}` | プロジェクト全体を検索し、結果を QuickFix リストに表示 |
| `:Ack {pattern} {path}` | 指定パス内を検索 |
| `:Acks /{old}/{new}/` | QuickFix リスト内の一致箇所を一括置換 |

**典型的なワークフロー:**

1. `:Ack foo` — プロジェクト内の `foo` を検索
2. QuickFix リストで結果を確認（`:cn`/`:cp` で移動）
3. `:Acks /foo/bar/` — 検索結果の `foo` を `bar` に一括置換

### ファジーファインダー (Telescope)

| ショートカット | 動作 |
|----------------|------|
| `,ff` | ファイル検索 |
| `,fg` | テキスト検索（grep） |
| `,fb` | バッファ一覧 |
| `,fh` | ヘルプタグ検索 |
| `,fo` | 最近開いたファイル |
| `,fk` | キーマップ検索 |

### タグジャンプ (gutentags / ctags)

タグファイルは gutentags により自動生成・更新されます。プロジェクトルートは `.gutctags` → `.git` の順で検出されます。`.git` が存在しないプロジェクトでは、ルートディレクトリに空の `.gutctags` ファイルを作成してください。

| ショートカット | 動作 |
|----------------|------|
| `Ctrl+]` | カーソル下のシンボルの定義へジャンプ |
| `Ctrl+t` | ジャンプ前の位置に戻る |
| `:ts {name}` | タグ候補の一覧から選択してジャンプ |
| `:tn` / `:tp` | 次 / 前のタグ候補へ移動 |
| `,tv` / `F8` | Vista タグバーの表示/非表示 |

タグファイルはファイル保存時に自動更新されるため、手動でのタグ生成は不要です。Fortran では `_smo`（サブモジュール実装）ファイルが優先されるようにカスタマイズされています。

### LSP (コード補助機能)

| ショートカット | 動作 |
|----------------|------|
| `gd` | 定義へジャンプ |
| `gD` | 宣言へジャンプ |
| `gr` | 参照一覧 |
| `gi` | 実装へジャンプ |
| `,rn` | シンボル名変更 |
| `,ca` | コードアクション |
| `,e` | 診断メッセージをフロート表示 |
| `[d` | 前の診断へ |
| `]d` | 次の診断へ |
| `,f` | コードフォーマット（conform.nvim 経由） |

*注: `gd`（定義へジャンプ）は gutentags の `Ctrl+]` と機能が重複します。LSP サーバーが有効な場合は `gd`（LSP）が優先され、LSP 非対応の言語では `Ctrl+]`（ctags）を使用してください。*

### Git 操作 (vim-fugitive)

| コマンド | 動作 |
|----------|------|
| `:Git status` | Git status（ステージング・アンステージングも可能） |
| `:Git commit` | Git commit |
| `:Git blame` | 行ごとの blame 表示 |
| `:Git diff` | Git diff（分割表示） |
| `:Git log` | Git log |
| `:Git push` | リモートへ push |
| `:Git pull` | リモートから pull |

### R プログラミング (R.nvim)

*`.r`, `.rmd`, `.quarto` ファイルで有効*

| ショートカット | モード | 動作 |
|----------------|--------|------|
| `Enter` | Normal | 現在行を R コンソールへ送信 |
| `Enter` | Visual | 選択範囲を R コンソールへ送信 |
| `,l` | Normal | 現在行を R コンソールへ送信 |
| `,l` | Visual | 選択範囲を R コンソールへ送信 |
| `,su` | Normal | 1行目から現在行までを送信 |
| `,sd` | Normal | 現在行からファイル末尾までを送信 |
| `;;` | Insert | ` <- ` を挿入（代入演算子） |
| `>>` | Insert | ` \|> ` を挿入（パイプ演算子） |

### Fortran プログラミング

*`.f90`, `.f95`, `.f03` 等の Fortran ファイルで有効*

| ショートカット | モード | 動作 |
|----------------|--------|------|
| `,,` | Insert | `%` を挿入（型メンバーアクセス） |

`%` 記号は conceal 機能により `.` として表示されます。ctags は `_smo`（サブモジュール実装）ファイルを優先してジャンプします。

### ビルド / 実行コマンド

| ショートカット | 動作 |
|----------------|------|
| `F2` | 保存して `make debugrun` |
| `F3` | 保存して `make test` |
| `F4` | 保存して `make run` |
| `F5` | 保存して `make release` |
| `F6` | 保存して `make relwithdebinfo`（Fortran ファイルのみ） |

### ターミナル

| ショートカット | モード | 動作 |
|----------------|--------|------|
| `F12` | Normal | 分割ウィンドウでターミナルを開く |
| `Esc` | Terminal | ターミナルモードを終了 |

### 補完 (nvim-cmp)

| ショートカット | 動作 |
|----------------|------|
| `Ctrl+Space` | 補完を手動起動 |
| `Enter` | 選択を確定 |
| `Ctrl+n` | 次の候補 |
| `Ctrl+p` | 前の候補 |

補完ソース（優先順）: Copilot → LSP → LSP シグネチャ → バッファ → パス

### Claude Code (AI アシスタント)

| ショートカット | モード | 動作 |
|----------------|--------|------|
| `,ac` | Normal | Claude Code の表示/非表示 |
| `,af` | Normal | Claude Code にフォーカス |
| `,ar` | Normal | 前回のセッションを再開 |
| `,aC` | Normal | 会話を続行 |
| `,ab` | Normal | 現在のバッファを Claude に追加 |
| `,as` | Visual | 選択範囲を Claude に送信 |

### GitHub Copilot

**コード補完 (copilot.lua):**

| ショートカット | モード | 動作 |
|----------------|--------|------|
| `Tab` | Insert | 提案を承認 |
| `Alt+]` | Insert | 次の提案 |
| `Alt+[` | Insert | 前の提案 |
| `Ctrl+e` | Insert | 提案を却下 |
| `Alt+Enter` | Insert | 提案パネルを開く |

**Copilot Chat:**

| ショートカット | 動作 |
|----------------|------|
| `,cc` | Copilot Chat を開く |
| `,ce` | 選択コードを説明 |
| `,cf` | 選択コードを修正 |
| `,ct` | テストを生成 |
| `,cq` | 質問する |

### スニペット (mini.snippets + vim.snippet)

| ショートカット | モード | 動作 |
|----------------|--------|------|
| `Ctrl+s` | Insert | スニペットを展開 |
| `Tab` | Insert | 次のプレースホルダへジャンプ |
| `Ctrl+h` | Insert | 前のプレースホルダへジャンプ |
| `Ctrl+c` | Insert | スニペット編集を中止 |

スニペットファイルは `~/.config/nvim/snippets/` に配置。言語別（`.lua`, `.py`, `.f90`, `.cpp`, `.md`）およびグローバル（`global.json`）のスニペットに対応。

### Markdown プレビュー

| ショートカット | 動作 |
|----------------|------|
| `,mp` | Neovim 内 Markdown プレビューの切り替え (markview.nvim) |
| `:MarkdownPreview` | ブラウザで Markdown プレビューを開く |
| `:MarkdownPreviewStop` | ブラウザプレビューを停止 |

### Parquet ファイル操作

DuckDB を使用した Parquet ファイルの読み書きに対応（DuckDB のインストールが必要）。

| コマンド | 動作 |
|----------|------|
| `:ParquetToCsv [output.csv]` | Parquet → CSV 変換 |
| `:CsvToParquet [output.parquet]` | CSV → Parquet 変換 |

NERDTree 等で Parquet ファイルを開くと、DuckDB により自動的に CSV に変換されて表示されます。通常の CSV として編集し、`:w` で保存すると自動的に Parquet に書き戻されます。

```
Parquet ファイルを開く → [DuckDB: Parquet→CSV] → CSV として編集 → :w → [DuckDB: CSV→Parquet] → Parquet 更新
```

### その他

| ショートカット | 動作 |
|----------------|------|
| `Esc` | 検索ハイライトを解除 |
| `gc` | コメントのトグル（mini.comment） |

---

## エディタ設定

- **インデント:** スペース2個（タブは展開、vim-sleuth による自動検出あり）
- **行番号:** 有効（絶対番号）
- **カーソル行:** ハイライト表示
- **検索:** 大文字小文字を無視（大文字入力時は区別）
- **クリップボード:** システムと同期
- **Undo履歴:** セッション間で保持
- **自動ディレクトリ変更:** 有効（`autochdir`）
- **折り返し:** 有効（単語境界で改行、`↪ ` プレフィックス表示）

### フォーマッター (conform.nvim)

保存時に自動フォーマットが実行されます。手動フォーマットは `,f` キー。

| 言語 | フォーマッター |
|------|--------------|
| Lua | stylua |
| Python | isort, black |
| JSON | prettier |
| YAML | prettier |
| Markdown | prettier |

### 自動保存・バックアップ (auto-save.nvim)

ファイルは **auto-save.nvim** により自動保存されます（`InsertLeave` / `TextChanged` から3秒後）。

**バックアップファイルの保存先:**

```
~/VIM_BACKUP_FILES/
```

**バックアップファイルの命名規則:**

ファイル名に時刻（時間単位）のタイムスタンプが付加されます。

```
元ファイル:  main.py
バックアップ: main.py_2025-11-06_14
              main.py_2025-11-06_15
              main.py_2025-11-07_09
```

**過去のファイルを復元するには:**

```bash
# バックアップ一覧を確認
ls ~/VIM_BACKUP_FILES/

# 特定ファイルのバックアップを検索
ls ~/VIM_BACKUP_FILES/ | grep "ファイル名"

# 復元（コピー）
cp ~/VIM_BACKUP_FILES/main.py_2025-11-06_14 ./main.py
```

**Undo 履歴:**

セッション間で Undo 履歴が保持されるため、Neovim を再起動しても `u` で過去の変更を戻せます。Undo ファイルは `~/.local/state/nvim/undo/` に保存されます。

---

## LSP サーバー

Mason により自動インストール・管理されます。

| サーバー | 言語 |
|----------|------|
| lua_ls | Lua |
| pyright | Python |
| yamlls | YAML |
| r_language_server | R |
| fortls | Fortran |
| texlab | LaTeX |

---

## インストール済みプラグイン

### コア

- **[lazy.nvim](https://github.com/folke/lazy.nvim)** - プラグインマネージャー
- **[tokyonight.nvim](https://github.com/folke/tokyonight.nvim)** - カラースキーム (night スタイル)
- **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)** - シンタックスハイライト (Tree-sitter)
- **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)** - LSP クライアント設定
- **[mason.nvim](https://github.com/mason-org/mason.nvim)** - LSP / ツール インストーラー
- **[mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim)** - Mason と LSP の連携
- **[nvim-cmp](https://github.com/hrsh7th/nvim-cmp)** - 自動補完エンジン
- **[conform.nvim](https://github.com/stevearc/conform.nvim)** - コードフォーマッター
- **[vim-sleuth](https://github.com/tpope/vim-sleuth)** - インデント自動検出

### ナビゲーション・UI

- **[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)** - ファジーファインダー (fzf-native, ui-select 拡張付き)
- **[NERDTree](https://github.com/preservim/nerdtree)** - ファイルエクスプローラー
- **[mini.statusline](https://github.com/echasnovski/mini.statusline)** - ステータスライン
- **[vista.vim](https://github.com/liuchengxu/vista.vim)** - タグバー（LSP/ctags 対応）
- **[neoscroll.nvim](https://github.com/karb94/neoscroll.nvim)** - スムーズスクロール

### 編集支援

- **[mini.nvim](https://github.com/echasnovski/mini.nvim)** - 行移動 (mini.move)、テキスト整列 (mini.align)、引数の分割/結合 (mini.splitjoin)、コメント (mini.comment)、キーヒント (mini.clue)、スニペット (mini.snippets)
- **[vim-gutentags](https://github.com/ludovicchabant/vim-gutentags)** - 自動タグ生成・管理
- **[ferret](https://github.com/wincent/ferret)** - プロジェクト全体の検索・置換（`:Ack`/`:Acks`）
- **[todo-comments.nvim](https://github.com/folke/todo-comments.nvim)** - TODO/FIX/NOTE コメントのハイライト
- **[auto-save.nvim](https://github.com/okuuva/auto-save.nvim)** - 自動保存・バックアップ

### Git

- **[vim-fugitive](https://github.com/tpope/vim-fugitive)** - Git コマンド連携
- **[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)** - 行変更のサイン表示

### AI アシスタント

- **[copilot.lua](https://github.com/zbirenbaum/copilot.lua)** - GitHub Copilot コード補完
- **[copilot-cmp](https://github.com/zbirenbaum/copilot-cmp)** - Copilot と nvim-cmp の連携
- **[CopilotChat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim)** - Copilot チャット
- **[claudecode.nvim](https://github.com/coder/claudecode.nvim)** - Claude Code AI アシスタント連携

### 言語サポート

- **[R.nvim](https://github.com/R-nvim/R.nvim)** - R 言語サポート
- **[csv.vim](https://github.com/chrisbra/csv.vim)** - CSV ファイルサポート
- **parquet.nvim** (ローカル) - Parquet ファイルの読み書き（DuckDB 経由）

### Markdown

- **[markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)** - ブラウザでの Markdown プレビュー
- **[markview.nvim](https://github.com/OXY2DEV/markview.nvim)** - Neovim 内 Markdown プレビュー

### その他

- **[toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)** - ターミナルトグル
- **[plenary.nvim](https://github.com/nvim-lua/plenary.nvim)** - ユーティリティライブラリ
- **[nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)** - ファイルアイコン（Nerd Font 使用時）

---

## ディレクトリ構成

```
~/.config/nvim/
├── init.lua                  # エントリーポイント（lazy.nvim 初期化）
├── lua/
│   ├── config/
│   │   ├── options.lua       # エディタ設定
│   │   ├── keymaps.lua       # キーマップ
│   │   ├── autocmds.lua      # 自動コマンド
│   │   └── snippets.lua      # スニペット設定 (mini.snippets)
│   ├── plugins/              # プラグイン定義（lazy.nvim が自動読み込み）
│   │   ├── init.lua          # コアプラグイン
│   │   ├── lsp.lua           # LSP 設定
│   │   ├── cmp.lua           # 補完設定
│   │   ├── telescope.lua     # Telescope 設定
│   │   ├── treesitter.lua    # Tree-sitter 設定
│   │   ├── mason.lua         # Mason 設定
│   │   ├── colorscheme.lua   # カラースキーム
│   │   ├── nerdtree.lua      # NERDTree 設定
│   │   ├── mini.lua          # mini.nvim モジュール
│   │   ├── statusline.lua    # ステータスライン
│   │   ├── git.lua           # Git プラグイン
│   │   ├── copilot.lua       # Copilot 設定
│   │   ├── claude.lua        # Claude Code 設定
│   │   ├── conform.lua       # フォーマッター設定
│   │   ├── r.lua             # R 言語設定
│   │   ├── ferret.lua        # 検索・置換
│   │   ├── ctags.lua         # タグ管理
│   │   ├── markdown.lua      # Markdown プラグイン
│   │   ├── parquet.lua       # Parquet サポート
│   │   └── others.lua        # その他のプラグイン
│   └── parquet/
│       └── init.lua          # Parquet モジュール本体
├── snippets/
│   └── global.json           # グローバルスニペット
├── install.sh                # セットアップスクリプト
└── venv/                     # Python 仮想環境（black, isort）
```

---

## 初心者向けヒント

1. `,fk` でキーマップ一覧を表示
2. `Ctrl+n` でファイルエクスプローラーを開く
3. `,ff` でファイルを素早く検索
4. `,fg` でファイル内のテキストを検索
5. `Ctrl+]` でシンボルの定義へジャンプ（`Ctrl+t` で戻る）
6. `,f` で現在のファイルをフォーマット
7. `:Git status` で Git status を確認

より体系的に学びたい場合は **[初心者向け演習](exercises.md)** を参照してください。基本操作から LSP、Git、AI アシスタントまで段階的に習得できます。