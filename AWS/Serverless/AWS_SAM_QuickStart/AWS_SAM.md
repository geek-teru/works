## 概要
公式サイトによると「AWS Serverless Application Model （AWS SAM) は、Infrastructure as Code (IaC) を使用してサーバーレスアプリケーションを構築するためのオープンソースフレームワークです。」とのこと

https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/what-is-sam.html

## インストール手順
* SAM CLIのインストール(linux)
```
yum -y install unzip
curl -L -o aws-sam-cli-linux-arm64.zip https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
unzip aws-sam-cli-linux-arm64.zip -d sam-installation
./sam-installation/install
```

https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/install-sam-cli.html

## docker環境構築手順
* docker起動
```
docker-compose up -d
```

* ログイン
```
docker exec -it awssam.local bash --login
```

* 削除
```
docker-compose down --rmi all --volumes --remove-orphans
```

## Tutorial
https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/serverless-getting-started-hello-world.html

### 環境
* WindowsマシンのVSCodeとGit bashで実行
* aws-cli/2.4.17 認証情報を登録済み
* SAM CLI, version 1.121.0
  * WindowsにインストールしてGit bashで実行する場合、`sam.cmd` コマンドに読み替えて実行する。
* Windows環境のPythonバージョン11
* LambdaのPythonバージョン11

### 手順
* 1.プロジェクトの作成
```
sam init

Which template source would you like to use?
        1 - AWS Quick Start Templates
        2 - Custom Template Location
Choice: 1

Choose an AWS Quick Start application template
        1 - Hello World Example
        2 - Data processing
        3 - Hello World Example with Powertools for AWS Lambda
        4 - Multi-step workflow
        5 - Scheduled task
        6 - Standalone function
        7 - Serverless API
        8 - Infrastructure event management
        9 - Lambda Response Streaming
        10 - Serverless Connector Hello World Example
        11 - Multi-step workflow with Connectors
        12 - GraphQLApi Hello World Example
        13 - Full Stack
        14 - Lambda EFS example
        15 - DynamoDB Example
        16 - Machine Learning
```
* 2.アプリケーションのビルド

以下のコマンドを実行すると、.aws-sam/buildにアーティファクトが作成される。

```
cd sam-app/
sam build
```

* アプリケーションのデプロイ

以下のコマンドでAWSへデプロイする
```
sam deploy --guided

```

以下のプロンプトに答える。

> HelloWorldFunction has no authentication. Is this okay? をデフォルトのNにするとエラーになるので注意
```
Setting default arguments for 'sam deploy'
        ========================================= 
        Stack Name [sam-app]: 
        AWS Region [ap-northeast-1]: 
        #Shows you resources changes to be deployed and require a 'Y' to initiate deploy
        Confirm changes before deploy [Y/n]: n
        #SAM needs permission to be able to create roles to connect to the resources in your template
        Allow SAM CLI IAM role creation [Y/n]: 
        #Preserves the state of previously provisioned resources when an operation fails
        Disable rollback [y/N]: 
        HelloWorldFunction has no authentication. Is this okay? [y/N]: y
        Save arguments to configuration file [Y/n]: 
        SAM configuration file [samconfig.toml]: 
        SAM configuration environment [default]:
```

実行結果のOutputsに作成されたリソースやAPIのエンドポイントが出力されている
* アプリケーションを実行する

以下のコマンドでOutputsを確認できる
```
sam list endpoints --output json

  {
    "LogicalResourceId": "ServerlessRestApi",
    "PhysicalResourceId": "xxxxxxxxxx",
    "CloudEndpoint": [
      "https://xxxxxxxxxx.execute-api.ap-northeast-1.amazonaws.com/Prod",
      "https://xxxxxxxxxx.execute-api.ap-northeast-1.amazonaws.com/Stage"
    ],
    "Methods": [
      "/hello['get']"
    ]
  }
```

* curlで疎通確認
以下のコマンドで疎通確認を行う。
```
curl https://xxxxxxxxxx.execute-api.ap-northeast-1.amazonaws.com/Prod/hello
{"message": "hello world"}
```

## ローカル環境でテストする
### 前提
ローカルでAPIのテストする方法は以下の2つがある
1. 関数を一回だけ呼び出す `local invoke`
2. APIをローカルにホストする `local start-api`

### 準備
* テストはローカルマシン上に Docker が必要

### local invoke
```
cd sam-app
sam local invoke

# 結果
START RequestId: 31a02b68-6c88-48a1-85ca-ce52eed908a3 Version: $LATEST
END RequestId: ad5a399e-8511-49a9-bbe4-406ec995623b
REPORT RequestId: ad5a399e-8511-49a9-bbe4-406ec995623b  Init Duration: 0.07 ms  Duration: 412.12 ms     Billed Duration: 413 msMemory Size: 128 MB     Max Memory Used: 128 MB
{"statusCode": 200, "body": "{\"message\": \"hello world\"}"}
```

### local start-api
```
cd sam-app
sam local start-api

# 起動完了
 * Running on http://127.0.0.1:3000
2024-08-16 23:32:58 Press CTRL+C to quit

# テスト
curl http://127.0.0.1:3000/hello
{"message": "hello world"}
```

## CI/CD
ソースコードを変更後以下のコマンドでコンテナのイメージをビルドする。※ここではHelloworldに時刻を追加するように変更した。

```
sam build --use-container
```

APIを起動する。
```
sam local start-api

```

ローカルでテストする
```
curl http://127.0.0.1:3000/hello
{"message": "hello world. 14:56:13"}
```

AWSで事前の動作確認
```
curl https://xxxxxxxxxx.execute-api.ap-northeast-1.amazonaws.com/Prod/hello
{"message": "hello world"}
```

AWSに変更を適用する
```
sam sync --watch
```

AWSで適用後の動作確認
```
curl https://xxxxxxxxxx.execute-api.ap-northeast-1.amazonaws.com/Prod/hello
{"message": "hello world. 15:11:20"}
```

## 削除
以下のコマンドでスタックを削除できる

```
sam delete
```

## 外部パッケージの利用(pythonの場合)
* requirements.txtファイルにはインストールしたいパッケージの名前とバージョンを記述しsam build コマンドを実行する。
* sam build は requirements.txt を読み取り、必要な依存関係をインストールしデプロイ用にパッケージングする。
* ローカルへのインストールやパッケージングは不要

## 参考:Quick Start application template

https://github.com/aws/aws-sam-cli-app-templates

1. Hello World Example
最も基本的なLambda関数の例で、API GatewayをトリガーとしてLambda関数が実行されます。単純な「Hello, World!」のレスポンスを返すAPIです。
2. Data processing
データ処理を行うテンプレートです。Lambda関数がS3バケットにアップロードされたファイルを処理するワークフローを示します。データのETL（抽出、変換、ロード）処理などに適しています。
3. Hello World Example with Powertools for AWS Lambda
Hello Worldの例に加えて、AWS Lambda Powertoolsを使用した例です。Powertoolsは、Lambda関数でのロギング、トレーシング、メトリクスの処理を簡素化するライブラリです。
4. Multi-step workflow
複数のステップを持つワークフローを実装するテンプレートです。AWS Step FunctionsとLambdaを組み合わせて、マルチステップの処理を実現します。
5. Scheduled task
定期的に実行されるタスクのテンプレートです。EventBridge（以前はCloudWatch Events）を使用して、スケジュールされたイベントによってLambda関数をトリガーします。
6. Standalone function
単独のLambda関数を作成するテンプレートです。API Gatewayや他のリソースと連携しない、単一のLambda関数の実装に使います。
7. Serverless API
完全なサーバーレスAPIを構築するテンプレートです。AWSのマネージドサービスを利用してAPIを構築します。具体的には、AWS Lambda、Amazon API Gateway、DynamoDBなどのサービスを組み合わせて、スケーラブルで高可用性のAPIを提供します。
8. Infrastructure event management
インフラストラクチャのイベント管理を行うテンプレートです。たとえば、CloudFormationスタックのイベントに応じてLambda関数をトリガーする場合などに使用します。
9. Lambda Response Streaming
Lambda関数からのレスポンスをストリーミングするテンプレートです。従来の完全なレスポンスを返す代わりに、部分的にデータをストリームしてクライアントに返すことができます。
10. Serverless Connector Hello World Example
サーバーレスコネクタを使用したHello Worldの例です。これにより、Lambda関数が他のAWSリソース（例: S3、DynamoDB）と簡単に接続できます。
11. Multi-step workflow with Connectors
サーバーレスコネクタを用いたマルチステップのワークフローを実装するテンプレートです。複数のAWSサービス間のワークフローを簡単に設定できます。
12. GraphQLApi Hello World Example
AWS AppSyncを使用してGraphQL APIを構築するテンプレートです。シンプルなGraphQLのエンドポイントを設定し、Lambdaでバックエンドロジックを実装します。
13. Full Stack
フロントエンドとバックエンドを含む、完全なフルスタックアプリケーションのテンプレートです。通常、S3を使ったフロントエンドのホスティングと、LambdaやAPI Gatewayを使ったバックエンドの実装が含まれます。
14. Lambda EFS example
Lambda関数でAmazon EFS（Elastic File System）を使用する例です。ファイルシステムが必要な場合に、Lambda関数がEFSにアクセスできるように設定します。
15. DynamoDB Example
DynamoDBを使用するLambda関数のテンプレートです。テーブルのデータを読み書きする操作を実装します。
16. Machine Learning
機械学習をサーバーレスで実行するテンプレートです。通常はSageMakerや機械学習モデルのデプロイメントを含むLambda関数を実装します。