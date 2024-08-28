import json

import requests
from datetime import datetime

def lambda_handler(event, context):
    """Sample pure Lambda function

    Parameters
    ----------
    event: dict, required
        API Gateway Lambda Proxy Input Format

        Event doc: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-input-format

    context: object, required
        Lambda Context runtime methods and attributes

        Context doc: https://docs.aws.amazon.com/lambda/latest/dg/python-context-object.html

    Returns
    ------
    API Gateway Lambda Proxy Output Format: dict

        Return doc: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html
    """

    # try:
    #     ip = requests.get("http://checkip.amazonaws.com/")
    # except requests.RequestException as e:
    #     # Send some context about this error to Lambda Logs
    #     print(e)

    #     raise e
    # current_time = datetime.now()
    # str_current_time = current_time.strftime('%H:%M:%S')
    response = requests.get("https://www.google.com/")
    headers = event.get('headers', {})
    # response_body = {
    #     "message": "hello world. ",
    #     "time": str_current_time,
    #     "headers": headers
    # }

    return {
            "statusCode": response.status_code,
            "body": response.text
    }
