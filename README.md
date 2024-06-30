# 概要
サービス名：In-Body.com

「In-Body.com」は、健康や筋トレなどのSNSサイトです。
本サイトを通じて、自分の記録を残すことと、他の人の記録やノウハウを見て、健康やダイエットなどのモチベーションを上げて、目標に向かっていってほしいという想いで制作しました。

サービスURL：　https://www.kumaydevelop.com/

かんたんログインで会員登録せずに機能をお試しいただけます。

# ポイント

1. Rails + Vue.jsでのSPA開発、RailsをAPI・Vueを画面と役割を切り離して作成しました
2. Dockerを使用して環境差分が出にくいような構築を行いました
3. SPモードでも表示できるようにレスポンシブ対応を行なっています
4. RailsではRspec、Vue.jsではJestでの単体テストやスナップショットテストを実行しました
5. Vue.jsはVercel、RailsはECSにデプロイしました
6. Github ActionsでCI/CDを構築しました
7. 定時バッチ、メールなどのその他機能を入れています
8. terraformでインフラを管理しています

# 使用技術

### バックエンド

| 技術 | 詳細 |
|:------------:|:------------:|
| Ruby(3.2.3)        | 開発言語         |
| Rails(7.0.8)       | APIサーバー         |
| dotenv         | Env管理        |
| devise、devise_token_auth           | ユーザー認証、トークン管理|
| rack-cors       | CORS対策         |
| active_storage      | 画像管理         |
| kaminari      | ページング         |
| aws-sdk-rails、aws-sdk-s3         |  ヘルスチェック用         |
| okcomputer         | S3とSESの管理         |
| rspec       | ControllerとModelのテスト         |
| rubocop         | フォーマッター         |

### フロントエンド

| 技術 | 詳細 |
|:------------:|:------------:|
| Vue.js(3.4.21)         | 開発言語         |
| axios         | 開発言語         |
| chart.js      | グラフ表示のため         |
| js-cookie        | Cookieに保存、削除するため        |
| vee-validate、yup          | バリデーションチェックのため|
| vue-datepicker       | 日付選択のため         |
| markdown-it       | マークダウンの表示のため         |
| primevue      | 部分的にコンポネントを使用         |
| tailwindcss      | 部分的に使用(marginやpaddingの表記)         |
| jest        | 単体テスト、スナップショットテスト        |

### インフラ周り

| 技術 | 詳細 |
|:------------:|:------------:|
| Docker         | 開発環境、本番環境ともに使用         |
| ECS(Fargate)        | Docker imageをECSにアップして本番反映         |
| Vercel      | フロントエンドをデプロイ、Guthubと連携         |
| js-cookie        | Cookieに保存、削除するため        |
| RDS          | DBはPostgresを使用|
| Route53       | 独自ドメインを登録するため         |
| S3       | ActiveStorageを用いて画像データをS3バケットに保存        |
| SES      | メールの送信に使用(開発者のみに届くメール)         |
| tailwindcss      | 部分的に使用(marginやpaddingの表記)         |
| AWS System Manager      | 本番環境の環境変数を管理       |
| ECS スケジュールタスク      | 定時バッチ     |
| Github Actions      | CI/CD     |
| Terraform      | インフラをコード化    |

# フォルダ構成

### プロジェクトフォルダ

- src/backend →　Railsプロジェクト
- src/frontend →　Vue.jsプロジェクト
- src/terraform →　terraformのファイル管理

### Vue.jsのコンポネントフォルダ

- src/componernts/atom →　最小のコンポネント（ボタンなど）
- src/componernts/layout →　最小のコンポネントの組み合わせ
- src/componernts/page →　画面

# インフラ構成図

![body-record-infla-map](https://github.com/yasu1234/body-record/assets/20049397/e6554f08-6f09-4f5a-a8f0-f1ab2b903ba8)

# 機能一覧

- 会員登録 / 退会
- ログイン（devise_token_auth） / ログアウト
- ゲストログイン
- パスワード変更 / メールアドレス変更
- 自分の記録一覧表示、検索(日付やキーワード)
- 記録の作成(日付や体重、メモ、画像を登録する、非公開設定も可能) / 編集 / 記録の画像削除 / 記録削除
- 他ユーザーの記録一覧表示、検索(日付やキーワード)
- 記録のコメント機能
- ユーザー検索(名前やサポートしているユーザーなどの条件) / ソート機能(サポーターが多い順)
- ユーザーのサポート(応援)機能(SNSのいいねに近い)
- 記事検索機能(タイトルやブックマークしているもののみ表示など)
- 記事作成 / 編集 / 画像削除 / 記事削除
- 記事のブックマーク機能
- 記事のコメント機能(作成、編集、削除)
- マイページ、ユーザーのページ機能　(プロフィールや体重のグラフ、作成した記事などが見られる)
- プロフィール編集(目標体重やサムネイル、紹介文の編集)
- 問い合わせ / 一覧確認 / ステータスが対応済みになったらバッチでデータ削除
- 問い合わせが作成されたら開発者にメール送信

# 主要機能(動画)

- 記録登録

https://github.com/yasu1234/body-record/assets/20049397/9a232c39-fae7-4a11-ac87-f6d8f7c3aa1e

- 記録検索

https://github.com/yasu1234/body-record/assets/20049397/73d8e47b-e7b2-4bf8-812d-01895dadff71

- 記事登録

https://github.com/yasu1234/body-record/assets/20049397/df684bf0-a9ac-48b4-a2e6-6a5266a6e239

- ユーザー選択から他のユーザーの記録表示

https://github.com/yasu1234/body-record/assets/20049397/2ff5bf3f-a32a-4e81-8072-474c992c6809


# ER図

<img width="1317" alt="Screen Shot 2024-06-26 at 7 50 25" src="https://github.com/yasu1234/body-record/assets/20049397/7b379183-884b-445b-b844-c65730dcccaf">
