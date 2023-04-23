IMAGE_PATH=$1
ROLE_SESSION_NAME=code-pipeline
# this assumes that the ecr_login has been done before which gives the docker container access to the production server deployment role
CREDENTIALS=`aws sts assume-role --role-arn $ROLE_ARN --role-session-name $ROLE_SESSION_NAME`

export AWS_ACCESS_KEY_ID=`echo $CREDENTIALS | jq -r .Credentials.AccessKeyId`
export AWS_SECRET_ACCESS_KEY=`echo $CREDENTIALS | jq -r .Credentials.SecretAccessKey`
export AWS_SESSION_TOKEN=`echo $CREDENTIALS | jq -r .Credentials.SessionToken`

export AWS_DEFAULT_REGION='ap-southeast-2'
echo $AWS_ACCESS_KEY_ID
echo $AWS_SECRET_ACCESS_KEY
echo $AWS_SESSION_TOKEN

# now do the login
# eval sudo su -
login_string=`aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin $IMAGE_PATH`;