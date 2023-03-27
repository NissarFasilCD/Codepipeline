# This script assumes the deploy role for an enviornment

# Example usage:
# ./assume_role arn:aws:iam::1231923922:deploy

# Preconditions:
# 1) The correct aws profile or access keys are set
# 2) The base aws envronment is created

ROLE_ARN=$1
SERVICE_NAME=$2
CLUSTER_NAME=$3
IMAGE_NAME=$4
STG_BUILD_ID=$5
AWS_PROFILE=$6

ROLE_SESSION_NAME=montu-backend-deployment

# this assumes that the ecr_login has been done before which gives the docker container access to the production server deployment role
CREDENTIALS=`aws sts assume-role --role-arn $ROLE_ARN --role-session-name $ROLE_SESSION_NAME --profile $AWS_PROFILE`

export AWS_ACCESS_KEY_ID=`echo $CREDENTIALS | jq -r .Credentials.AccessKeyId`
export AWS_SECRET_ACCESS_KEY=`echo $CREDENTIALS | jq -r .Credentials.SecretAccessKey`
export AWS_SESSION_TOKEN=`echo $CREDENTIALS | jq -r .Credentials.SessionToken`

export AWS_DEFAULT_REGION='ap-southeast-2'
echo $AWS_ACCESS_KEY_ID
echo $AWS_SECRET_ACCESS_KEY
echo $AWS_SESSION_TOKEN

ecs-deploy -c $3 -n $2 -i $4:$5  --timeout 600 --enable-rollback --max-definitions 3
