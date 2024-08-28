import json

def lambda_handler(event, context):
    # リクエストボディを取得し、JSONから辞書に変換
    try:
        request_data = json.loads(event['body'])
    except (json.JSONDecodeError, TypeError) as e:
        return {
            'statusCode': 400,
            'body': json.dumps({'message': 'Invalid JSON format', 'error': str(e)})
        }
    
    # 変換された辞書をそのままレスポンスとして返す
    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'Request received successfully',
            'data': request_data
        })
    }
