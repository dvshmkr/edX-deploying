# Copyright 2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except
# in compliance with the License. A copy of the License is located at
#
# https://aws.amazon.com/apache-2-0/
#
# or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
"Central configuration"
import os
import boto3

ssm_client = boto3.client('ssm')

DATABASE_HOST = os.environ['DATABASE_HOST']
DATABASE_DB_NAME = os.environ['DATABASE_DB_NAME']
DATABASE_USER = os.environ['DATABASE_USER']
if 'DATABASE_PASSWORD' in os.environ:
    DATABASE_PASSWORD = os.environ['DATABASE_PASSWORD']
else:
    ps_key = os.environ['ENV_PREFIX'] + 'DATABASE-WEB-USER-PASSWORD'
    ps_values = ssm_client.get_parameters(
        Names=[ps_key],
        WithDecryption=True
    )
    db_param = next((parameter for parameter in ps_values['Parameters']
                     if parameter['Name'] == ps_key), None)
    DATABASE_PASSWORD = db_param['Value']
