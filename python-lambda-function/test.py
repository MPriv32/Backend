import boto3
import unittest
import os
import random 
import main 


def test_get_visitors_counter():

    counter_table = os.environ['main_table']
    dynamodb = boto3.resource('dynamodb', 'us-west-1')
    counter_key = os.environ['main_table_key']
    

    random_path = str(random.randint(1, 1000))

    main.update_counts_table(counter_table, counter_key, random_path)
    print('Random Path Value: {}'.format(random_path))

    response = main.get_latest_count(counter_table, counter_key, random_path)
    print('Retreived value of {} from table'.format(response))
    assert response == 1

    main.update_counts_table(counter_table, counter_key, random_path)
    update_response = main.get_latest_count(counter_table, counter_key, random_path)
    print('Retreived udpated value of {} from table'.format(update_response))
    assert update_response == response + 1 