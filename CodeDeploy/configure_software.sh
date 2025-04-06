#!/bin/bash

echo "check 0" >> /webapps/test.log

# install python requirements
# pip-3.6 install -r /webapps/app/FlaskApp/requirements.txt
pip3 install -r /webapps/app/FlaskApp/requirements.txt



# get/set vars
export DATABASE_ROOT_USER=root
export DATABASE_ROOT_PASSWORD=$(aws ssm get-parameter --name TEST-DATABASE-MASTER-PASSWORD --with-decryption --query 'Parameter.Value' --output text)
export DATABASE_PASSWORD=$(aws ssm get-parameter --name TEST-DATABASE-WEB-USER-PASSWORD --with-decryption --query 'Parameter.Value' --output text)
export DATABASE_HOST=$(aws cloudformation describe-stacks --query 'Stacks[?contains(StackId,`TEST-Stack`)]|[0].Outputs[?contains(OutputKey,`RDSAddress`)]|[].OutputValue' --output text)
export DATABASE_DB_NAME=TEST-routes
export DATABASE_USER=web_user

echo "check 2: " >> /webapps/test.log
echo "DATABASE_ROOT_PASSWORD: $DATABASE_ROOT_PASSWORD" >> /webapps/test.log
echo "DATABASE_HOST: $DATABASE_HOST" >> /webapps/test.log

# setup sql database
cat /webapps/app/CodeDeploy/TEST-CreateDrop.sql | mysql -h $DATABASE_HOST -u $DATABASE_ROOT_USER -p$DATABASE_ROOT_PASSWORD
sed "s/SED_REPLACE_PASS/$DATABASE_PASSWORD/g" < /webapps/app/CodeDeploy/create_schema.sql | mysql -h $DATABASE_HOST -u $DATABASE_ROOT_USER -p$DATABASE_ROOT_PASSWORD $DATABASE_DB_NAME
/webapps/app/CodeDeploy/database_populate.py

# push configuration into app.ini
sed -i s/SED_REPLACE_DATABASE_HOST/$DATABASE_HOST/g /webapps/app/CodeDeploy/app.ini
sed -i s/SED_REPLACE_DATABASE_DB_NAME/$DATABASE_DB_NAME/g /webapps/app/CodeDeploy/app.ini
echo "env = ENV_PREFIX=TEST-" >> /webapps/app/CodeDeploy/app.ini

# configure region for the app
#EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 60")
EC2_AVAIL_ZONE=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"
echo "env = AWS_DEFAULT_REGION=$EC2_REGION" >> /webapps/app/CodeDeploy/app.ini

echo "check 3: " >> /webapps/test.log

# set file permissions

chown -R nginx:root /webapps/app/FlaskApp
chown -R nginx:root /webapps/app/CodeDeploy


# copy in the nginx config
mv -f /webapps/app/CodeDeploy/nginx.conf /etc/nginx/nginx.conf
systemctl restart nginx

# configure log file for uwsgi
mkdir /var/log/uwsgi
chown nginx:nginx /var/log/uwsgi
systemctl restart uwsgi

echo "check 4: " >> /webapps/test.log

# display the deployment group in the footer
echo $DEPLOYMENT_GROUP_NAME > /webapps/app/FlaskApp/templates/buildinfo.html

echo "check 5: " >> /webapps/test.log

# configure upstart to run uwsgi
#mv -f /webapps/app/CodeDeploy/uwsgi.conf /etc/init/uwsgi.conf
#mv -f /webapps/app/CodeDeploy/app.ini /webapps/app/FlaskApp/

echo "check 6: " >> /webapps/test.log
