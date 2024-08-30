## S3バケットポリシーに明示的な拒否ルールを追加する
* S3のバケットポリシーの評価ロジックは以下の通り
  * IAM ポリシー、バケットポリシーのどちらかが許可しているとアクセスに成功する。
  * どちらかの許可があっても、明示的な拒否をあれば失敗する。
* 厳格なセキュリティ要件がある想定で特定のIAMロール以外は明示的に拒否するユースケースを考える。
* 以下のように指定するとできるらしい
  * 参考：https://repost.aws/ja/knowledge-center/explicit-deny-principal-elements-s3
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::444455556666:role/s3-access-role"
        ]
      },
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": "arn:aws:s3:::awsexamplebucket1"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::444455556666:role/s3-access-role"
        ]
      },
      "Action": [
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::awsexamplebucket1/*"
    },
    {
      "Sid": "",
      "Effect": "Deny",
      "Principal": "*",
      "Action": [
        "s3:ListBucket",
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::awsexamplebucket1/*",
        "arn:aws:s3:::awsexamplebucket1"
      ],
      "Condition": {
        "StringNotLike": {
          "aws:userid": [
            "AROAID2GEXAMPLEROLEID:*", # IAMRoleのID
            "444455556666"
          ]
        }
      }
    }
  ]
}
```
* さらに参考：https://dev.classmethod.jp/articles/s3-bucket-acces-to-a-specific-role/


### 環境構築 
```
$ docker compose run --rm terraform init
$ docker compose run --rm terraform plan
$ docker compose run --rm terraform apply
$ docker compose run --rm terraform destroy
$ docker-compose down --rmi all --volumes --remove-orphans
```

### テスト
* DenyされているIAMユーザーでアクセス
```
account=$(aws sts get-caller-identity --query 'Account' --output text) && echo $account
aws s3 ls ${account}-test-bucket
An error occurred (AccessDenied) when calling the ListObjectsV2 operation: User: arn:aws:iam::xxxxxxxxxxxx:user/Teruaki_Nambara is not 
authorized to perform: s3:ListBucket on resource: "arn:aws:s3:::xxxxxxxxxxxx-test-bucket" with an explicit deny in a resource-based policy

```

* AllowされているIAMロールをAssume Role
```
eval $(aws sts assume-role --role-arn "arn:aws:iam::${account}:role/admin-role" --role-session-name "testsession" --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' --output text | awk '{print "export AWS_ACCESS_KEY_ID="$1"\nexport AWS_SECRET_ACCESS_KEY="$2"\nexport AWS_SESSION_TOKEN="$3}')

printenv | grep AWS_

```

* 再び、AllowされているIAMロールでアクセス
```
aws s3 ls ${account}-test-bucket
2024-08-30 23:56:30          4 test.txt
```