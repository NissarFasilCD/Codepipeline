#!/bin/bash

ROLE_ARN=$1
AWS_PROFILE=$2
IMAGE_PATH=$3
ROLE_SESSION_NAME=montu-backend

# this assumes that the ecr_login has been done before which gives the docker container access to the production server deployment role
CREDENTIALS=`aws sts assume-role --role-arn $ROLE_ARN --role-session-name $ROLE_SESSION_NAME --profile $2`
export AWS_ACCESS_KEY_ID=`echo $CREDENTIALS | jq -r .Credentials.AccessKeyId`
export AWS_SECRET_ACCESS_KEY=`echo $CREDENTIALS | jq -r .Credentials.SecretAccessKey`
export AWS_SESSION_TOKEN=`echo $CREDENTIALS | jq -r .Credentials.SessionToken`
export AWS_DEFAULT_REGION='ap-southeast-2'

echo $AWS_ACCESS_KEY_ID
echo $AWS_SECRET_ACCESS_KEY
echo $AWS_SESSION_TOKEN

# now do the login
# eval sudo su -
#login_string=`aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin $IMAGE_PATH`;
#$(aws ecr get-login --region ap-southeast-2| sed -e "s/-e none//g")
aws ecr get-login-password | docker login --username AWS --password-stdin "$(aws sts get-caller-identity --query Account --output text).dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
