## API Gateway, Lambda連携(MyApp_v1)
### 設計
* 構成
  * API Gateway, Lambda
* 機能
  * まずはLambdaでリクエストの内容をjsonから辞書へ変換しAPIGateway経由でレスポンスを返すだけのアプリ

### 実装
* MyApp_v1のテスト
```
# ローカルにデプロイ
cd MyApp_v1/
sam build
sam local start-api

# 動作確認
curl -X POST http://127.0.0.1:3000/budget \
-H "Content-Type: application/json" \
-d '{"Timestamp": 1692307200, "Category": "Groceries", "Amount": 100}'
{"message": "Request received successfully", "data": {"Timestamp": 1692307200, "Category": "Groceries", "Amount": 100}}
```
