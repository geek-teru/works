## CloudTrailイベントを監視する
* S3のGetObjectを監視して、Slackに通知する


### 環境構築 


```
$ docker compose run --rm terraform init
$ docker compose run --rm terraform plan
$ docker compose run --rm terraform apply
$ docker compose run --rm terraform destroy
```