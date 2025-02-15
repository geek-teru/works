import json
import boto3
import os

def lambda_handler(event, context):
    sns = boto3.client('sns')
    
    # EventBridgeから受け取ったイベントデータをJSON文字列に変換
    event_json = json.dumps(event, indent=2)
    
    # メッセージを作成
    message = f"AWS Config変更が検出されました:\n{event_json}"
    
    try:
        # SNSトピックにメッセージを発行
        response = sns.publish(
            TopicArn=os.environ['SNS_TOPIC_ARN'],
            Message=message,
            Subject='AWS Config変更通知'
        )
        print(f"SNS通知が正常に送信されました: {response['MessageId']}")
    except Exception as e:
        print(f"SNSへの発行中にエラーが発生しました: {e}")
        raise
    
    return {
        'statusCode': 200,
        'body': json.dumps('通知が正常に送信されました')
    }
