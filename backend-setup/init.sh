#!/bin/bash

# parameters
BUCKET=$1
AWS_REGION=$2
AWS_PROFILE=$3

if ! [[ -z $(aws s3api head-bucket --bucket ${BUCKET} --profile ${AWS_PROFILE}) ]]; then
  # create S3 bucket for terraform backend
  aws s3api create-bucket \
    --bucket ${BUCKET} \
    --region ${AWS_REGION} \
    --profile ${AWS_PROFILE}

  # set encryption
  aws s3api put-bucket-encryption \
    --bucket ${BUCKET} \
    --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}' \
    --profile ${AWS_PROFILE}

  # create dynamo state lock
  aws dynamodb create-table \
    --table-name terraform-lock \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
    --profile ${AWS_PROFILE}
fi