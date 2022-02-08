from pprint import pprint
import json
import os
import test

import boto3
from botocore.exceptions import ClientError

ddb = boto3.resource('dynamodb')

def update_counts_table(table_name, key_name, path_value):
    table=ddb.Table(table_name)

    ConditionStatement='attribute_not_exists(' +str(key_name)+ ')'
    try:
        table.put_item(
            Item={key_name:path_value, 'counts': 0, },
            ConditionExpression=ConditionStatement
            )
    except ClientError as e:

        if e.response['Error']['Code'] != 'ConditionalCheckFailedException': 
            raise
    table.update_item(
        Key={key_name:path_value,}, 
        UpdateExpression='ADD counts :incr', 
        ExpressionAttributeValues={':incr': 1})

def get_latest_count(table_name, key_name, path_value):
    table=ddb.Table(table_name)
    try:
        count_item=table.get_item (
        Key={key_name:path_value,}, 
        )
    except ClientError as e:
        raise
    return(count_item['Item']['counts'])
def lambda_handler(event, context):
    
    #setup for unit_test
    #test.test_get_visitors_counter()
    
    update_counts_table('mitchellprivettresume.com-counterdb', 'URL_path', '/')
    
    return {
    'statusCode': 200,
    'headers': {
            'Content-Type': 'text/plain',
            'Access-Control-Allow-Headers': '*',
            'Access-Control-Allow-Origin': 'https://www.mitchellprivettresume.com',
            'Access-Control-Allow-Methods': '*'
        },

        'body': get_latest_count(os.environ['main_table'], os.environ['main_table_key'], '/')
    }