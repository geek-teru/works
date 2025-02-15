## CloudTrailイベントを監視する
* S3のGetObjectを監視して、Slackに通知する


### 環境構築 


```
$ docker compose run --rm terraform init
$ docker compose run --rm terraform plan
$ docker compose run --rm terraform apply -auto-approve
$ docker compose run --rm terraform destroy -auto-approve
```