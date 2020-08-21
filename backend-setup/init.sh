#!/bin/bash

# source ./init.sh "maikel-backend-bucket" "us-east-1" "maikel_cli"

BUCKET=$1
AWS_REGION=$2
AWS_PROFILE=$3

aws s3api create-bucket \
  --bucket ${BUCKET} \
  --region ${AWS_REGION} \
  --profile ${AWS_PROFILE}