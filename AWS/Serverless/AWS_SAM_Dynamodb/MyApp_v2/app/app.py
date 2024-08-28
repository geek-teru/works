import json
import boto3
import os
import datetime

def lambda_handler(event, context):
    # DynamoDBリソースの初期化
    dynamodb = boto3.resource('dynamodb', endpoint_url='http://dynamodb.local:8000')
    table = dynamodb.Table(os.environ['TABLE_NAME'])

    # リクエストボディを取得し、JSONから辞書に変換
    try:
        request_data = json.loads(event['body'])
    except (json.JSONDecodeError, TypeError) as e:
        return {
            'statusCode': 400,
            'body': json.dumps({'message': 'Invalid JSON format', 'error': str(e)})
        }
    
    timestamp =  int(datetime.datetime.now().timestamp())
    # DynamoDBに保存するためのデータを準備
    item = {
        'Category': request_data['Category'],
        'Timestamp': timestamp,
        'Amount': request_data['Amount']
    }
    print(item)
    
    # DynamoDBにデータを保存
    try:
        table.put_item(Item=item)
        
        # 保存したデータを取得
        response = table.get_item(
            Key={
                'Category': request_data['Category'],
                'Timestamp': timestamp
            }
        )
        
        # 取得したデータ
        saved_item = response.get('Item', {})
        print(saved_item)

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Error storing data', 'error': str(e)})
        }

    return {
        'statusCode': 200,
        'body': {}
    }
