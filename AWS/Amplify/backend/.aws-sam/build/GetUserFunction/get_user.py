import json

def lambda_handler(event, context):
    try:

        result = [
            {
                'age_group': '20-29',
                'count': 10,
            },
            {
                'age_group': '30-39',
                'count': 20,
            },
            {
                'age_group': '40-49',
                'count': 30,
            },
            {
                'age_group': '50-59',
                'count': 40,
            },
        ]
        
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Credentials': True
            },
            'body': json.dumps(result)
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': f'Error retrieving user data: {str(e)}'
            })
        } 