# Amplify Gen2 + Next.js + Cognito セットアップ手順

## 1. Terraformでの環境構築
- cognito.tf を作成（Cognitoユーザープールとクライアントの設定）
- terraform apply を実行

## 2. Next.jsプロジェクトのセットアップ
- プロジェクトディレクトリの作成
- 必要なパッケージのインストール
```

npm install aws-amplify @aws-amplify/ui-react next react react-dom
npm install --save-dev typescript @types/react @types/react-dom @types/node

# 以下でpackage.jsonのパッケージをインストール
npm install
```

## 3. プロジェクト構造の作成
```
myapp/
├── app/
│   ├── components/
│   ├── layout.tsx
│   └── page.tsx
├── amplify.yml
├── package.json
└── tsconfig.json
```

## 4. 各ファイルの作成
- amplify.yml を作成（ビルド設定）
- tsconfig.json を作成（TypeScript設定）
- app/layout.tsx を作成（レイアウト設定）
- app/page.tsx を作成（メインページ）
- app/components/UserInfoForm.tsx を作成（フォームコンポーネント）

## 5. ローカル開発の確認

## 6. Amplifyコンソールでの設定
- 新しいアプリケーションの作成
- リポジトリの連携
- 環境変数の設定：`AMPLIFY_MONOREPO_APP_ROOT=AWS/Amplify/myapp`