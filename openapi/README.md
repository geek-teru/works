# OpenAPI の使い方

### ER 図

```mermaid
erDiagram
    User {
        int id PK "ユーザーID"
        varchar(100) name "名前"
        varchar(100) email "メールアドレス"
        varchar(100) password "パスワード"
        timestamp created_at
        timestamp updateded_at
        timestamp deleted_at
    }
    Task {
        int id PK "タスクID"
        varchar(100) title "タイトル"
        varchar(255) description "詳細"
        date due_date "期限日"
        int status "ステータス (e.g., TODO, IN_PROGRESS, DONE)"
        int user_id FK "ユーザーID"
        timestamp created_at
        timestamp updateded_at
        timestamp deleted_at
    }


    User ||--o{ Task : "1対多"
```

## ローカルで Swagger UI を使う（Node.js 環境）

### スクリーンショット

![screenshot](images/screenshot-2025-04-18.png)

### 構成

```
/swagger-ui/dist/
  ├── index.html（公式から取得）
  ├── swagger-initializer.js（YAMLパスを指定）
  ├── openapi.yaml
  └── components
        ├── task.yaml
        └── user.yaml
```

### 準備

- swagger-ui を clone

```
git clone https://github.com/swagger-api/swagger-ui.git

# 作成した openapi.yaml をこの dist/ フォルダにコピー
cp /path/to/openapi.yaml ./openapi.yaml
```

- dist/swagger-initializer.js を編集

```
window.onload = function () {
  window.ui = SwaggerUIBundle({
    url: "openapi.yaml",  // ←ここにファイル名を指定
    dom_id: '#swagger-ui',
    presets: [
      SwaggerUIBundle.presets.apis,
      SwaggerUIStandalonePreset
    ],
    layout: "StandaloneLayout"
  });
};
```

```
npm install -g http-server
```

- 実行

```
cd swagger-ui/dist
http-server
```

- ブラウザで `http://127.0.0.1:8080/#/`を開く(キャッシュが残る可能性があるのでシークレットモードの方がいい)
