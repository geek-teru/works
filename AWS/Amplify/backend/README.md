
### ビルド
sam build

### ローカル実行
sam local invoke

### ローカル実行
sam local start-api

### デプロイ 
sam deploy --guided

### デプロイ後のエンドポイント確認
sam list endpoints --output json

### Cognito認証とAPIテスト

1. **管理者権限で認証トークンを取得**

### デプロイ後のエンドポイント確認

idtoken=$(aws cognito-idp initiate-auth \
--client-id "クライアントID" \
--auth-flow "USER_PASSWORD_AUTH" \
--auth-parameters USERNAME="ユーザー名",PASSWORD="パスワード" \
--region ap-northeast-1 \
--query "AuthenticationResult.IdToken" | tr -d '"')

curl -X GET "https://<api-id>.execute-api.<region>.amazonaws.com/dev/get_user" \
-H "Authorization: Bearer $idtoken"

## 削除
sam delete