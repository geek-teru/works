# アプリケーション設計書

## 1. 概要
ユーザー情報管理システム

### 1.1 目的
- ユーザー認証機能の実装
- ユーザー情報の登録と管理
- セキュアなAPIアクセスの実現

### 1.2 ディレクトリ
- backend: バックエンドAPIの設定
- frontend: フロントエンドの設定
- terraform: インフラストラクチャの設定

## 2. 設計

### 2.1 フロントエンド（Amplify + Next.js）
- **認証機能**
  - Amazon Cognito による認証
  - ホストされたUI
  - サインイン/サインアウト機能

- **UI実装**
  - ヘッダーコンポーネント
    - ユーザー名表示
    - サインアウトボタン
  - ナビゲーションバー
    - ユーザー情報入力フォーム
  - メインコンテンツエリア

### 2.2 インフラストラクチャ（Terraform）
- **Cognito設定**
  - ユーザープール
  - アプリケーションクライアント
  - OAuth設定

### 2.3 バックエンド（API Gateway + Lambda）
- **API Gateway**
  - RESTful API の実装
  - Cognito認証との統合
  - CORSの設定

- **Lambda関数**
  - age_group(10歳ごとのグループ),count(人数)を返すモック。値は固定値

### 2.4 セキュリティ
- **IAM設定**
  - Lambdaの実行ロール
  - API Gatewayの実行権限

## 3. 技術スタック
- **フロントエンド**
  - Next.js
  - AWS Amplify
  - TypeScript
  - Amplify UI Components

- **バックエンド**
  - AWS Lambda(python3.11)
  - API Gateway

- **インフラストラクチャ**
  - Terraform
  - AWS SAM

## 4. デプロイメント
- **フロントエンド**
  - AWS Amplifyホスティング
  - 自動デプロイ（GitHub連携）

- **バックエンド**
  - AWS SAMによるデプロイ
  - 環境ごとのステージ管理