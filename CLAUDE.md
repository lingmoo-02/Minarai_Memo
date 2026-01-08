# Minarai Memo - AI開発ガイドライン

見習い職人が学んだ技術を写真とメモで記録するアプリケーション。AI開発を効率化するための最小限のルール。

---

## 1. 技術スタック

- **フレームワーク**: Rails 7.2.1（Ruby 3.3.6）
- **データベース**: PostgreSQL
- **フロントエンド**: Hotwire（Turbo + Stimulus）、Tailwind CSS、DaisyUI
- **認証**: Devise + Google OAuth 2.0
- **画像処理**: CarrierWave + MiniMagick
- **ファイルストレージ**: ローカル（開発）、AWS S3（本番）
- **その他**: Kaminari（ページネーション）、Groupdate（チャート）、Chart.js

---

## 2. アーキテクチャ

### ディレクトリ構造

```
Minarai_Memo/
├── app/
│   ├── models/
│   │   ├── user.rb                    (Devise認証、Google OAuth)
│   │   └── note.rb                    (ノート、画像アップロード)
│   ├── controllers/
│   │   ├── notes_controller.rb        (CRUD操作)
│   │   ├── profiles_controller.rb     (プロフィール管理)
│   │   └── users/
│   │       ├── registrations_controller.rb
│   │       ├── sessions_controller.rb
│   │       ├── passwords_controller.rb
│   │       └── omniauth_callbacks_controller.rb
│   ├── views/
│   │   ├── notes/                     (index, show, new, edit)
│   │   ├── profiles/                  (show, edit)
│   │   ├── devise/                    (ログイン、登録)
│   │   └── shared/                    (header, footer, error_messages)
│   ├── uploaders/
│   │   ├── note_image_uploader.rb     (ノート画像: 800x800, thumb 300x200)
│   │   └── avatar_uploader.rb         (ユーザーアバター)
│   ├── javascript/
│   │   └── controllers/
│   │       ├── dropdown_controller.js
│   │       └── notes_chart_controller.js
│   └── assets/
│       └── stylesheets/
│           └── application.tailwind.css
├── config/
│   ├── routes.rb
│   ├── locales/
│   │   └── ja.yml                     (日本語翻訳)
│   └── initializers/
│       ├── devise.rb
│       └── omniauth.rb
├── test/
│   ├── models/
│   ├── system/
│   └── fixtures/
├── Gemfile
├── docker-compose.yml
└── CLAUDE.md
```

### 主要フロー
1. ユーザー認証（Devise + Google OAuth）
2. ノート作成・編集・削除（画像アップロード含む）
3. プロフィール管理（アバター、統計表示）
4. 進捗チャート表示（groupdate + Chart.js）

---

## 3. 主要モデルと関係

### User
- Devise認証モデル
- `has_many :notes, dependent: :destroy`
- Google OAuth連携：`uid`, `provider` フィールド必須
- 画像：`avatar`（AvatarUploader）

### Note
- `belongs_to :user`
- 属性：`title`（255文字以下）、`body`（65535文字以下）、`note_image`
- 画像：`note_image`（NoteImageUploader）
- ページネーション：1ページ4件

### ルーティング
```
root → static_pages#top
resources :notes
resource :profile, only: %i[show edit update]
```

---

## 4. AIが守るべき注意点

### セキュリティ（必須）
- **Strong Parameters**: 許可属性を明示的に指定
- **バリデーション**: 全属性に presence, length, uniqueness を設定
- **画像ホワイトリスト**: jpg, jpeg, gif, png のみ許可
- **ファイルサイズ**: 5MB以下に制限
- **CSRF保護**: デフォルト有効（変更不可）
- **XSS対策**: ERB自動エスケープを使用、`html_safe` は不使用
- **SQL Injection**: ActiveRecord メソッド使用、生SQL禁止

### 実装ルール
- **言語**: すべてのユーザー向けメッセージは日本語のみ
- **i18n**: エラーメッセージとバリデーション属性名を `config/locales/ja.yml` で管理
- **既存パターン踏襲**: NotesController, User, Note モデルを参考に実装
- **ファイル配置**: app/uploaders/, app/javascript/controllers/, app/views/shared/ など既存構造に従う

### 開発プロセス
1. モデル：マイグレーション → バリデーション定義
2. アップロード：アップローダー作成 → リサイズ・サムネイル設定
3. コントローラー：Strong Parameters → アクション実装
4. ビュー：ERBテンプレート → 日本語ラベル
5. テスト：モデルテスト → システムテスト
6. デプロイ：`.env.example` 更新 → Render環境変数設定

### 絶対厳禁
- カスタムCSS追加（Tailwind使用）
- 不要なヘルパー・concern 作成
- `system`, `exec` コマンド実行
- 生SQL実行
- パスワードをログ出力
