## DyanmoDB連携追加(MyApp_v2)
### 設計
* 構成
  * API Gateway, Lambda, DyanmoDB
* 機能
  * Lambdaでリクエストの内容をjsonから辞書へ変換しDyanmoDBに登録し、登録した内容をReturnValuesで取得する。
  * 取得した登録内容を標準出力する。


### 実装
* DynamoDBはdynamodb-localというコンテナイメージを利用する。
* そのままではaws_samコンテナとdynamodb-localコンテナが別々のDockerネットワークで起動するため疎通できないので、Dockerネットワークを作成し、aws_samコンテナとdynamodb-localを同じネットワークで起動する。

#### Dockerネットワーク作成
以下のコマンドでDockerネットワークを作成する。
```
docker network create aws-sam-network

```


#### dynamodb-localセッティング
```
# dynamoDB localコンテナを起動
docker run -d -p 8000:8000 --network aws-sam-network --name dynamodb.local amazon/dynamodb-local

# テーブル作成
aws dynamodb create-table \
    --table-name MyBudgetTable \
    --attribute-definitions AttributeName=Category,AttributeType=S AttributeName=Timestamp,AttributeType=N \
    --key-schema AttributeName=Category,KeyType=HASH AttributeName=Timestamp,KeyType=RANGE \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --endpoint-url http://localhost:8000

# ローカルからテーブル確認
aws dynamodb list-tables --endpoint-url http://localhost:8000

```

#### AWS SAMをローカルにデプロイ
```
# ローカルにデプロイ
cd MyApp_v2/
sam build
sam local start-api --docker-network aws-sam-network

# 動作確認 
curl -X POST http://localhost:3000/budget \
-H "Content-Type: application/json" \
-d '{"Timestamp": 1692307200, "Category": "Groceries",  "Amount": 100}'

```

## DyanmoDBのTips
### DynamoDBにオートインクリメント機能はない  
* DynamoDBには、一般的な関係データベースで提供されるような「オートインクリメント機能」はありません。
* しかし、ラムダ関数を使ってカウンターとして使用するアイテムをDynamoDBに保存しておき、そのカウンターをインクリメントして新しい値を取得するなどして実現可能

## 追加されたレコードを取得する方法
* PostgreSQLなどのリレーショナルデータベースで利用できるRETURNING文のように、INSERTやUPDATEの結果として新しいレコード全体を返す機能は直接的にはありません。
* DynamoDBのput_itemした後にget_itemで取得する。

* ReturnValuesのオプション
  * NONE (デフォルト): 何も返しません。
  * ALL_OLD: 操作前のアイテムの完全なコピーを返します。
  * UPDATED_OLD: 操作前のアイテムの更新された属性のみを返します。
  * ALL_NEW: 操作後のアイテムの完全なコピーを返します。
  * UPDATED_NEW: 操作後のアイテムの更新された属性のみを返します。

## sam local start-apiでDynamoDB用のコンテナは起動しない
* DynamoDBをローカルで使用するには、別途DynamoDBのローカルインスタンスを起動する必要があります。
* Dockerを使用してDynamoDBローカルを起動するには、以下のコマンドを実行します。
* `docker run -d -p 8000:8000 amazon/dynamodb-local`