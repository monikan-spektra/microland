#!/bin/bash

# -----------------------------------------------
# Validate Scenario 3 - Task 2
# Checks: CloudWatch log group exists with log streams for 'ServerlessWebApp'
# -----------------------------------------------

# Check AWS CLI version and upgrade to v2 if needed
AWS_VERSION=$(aws --version 2>&1 | awk '{print $1}' | cut -d'/' -f2 | cut -d'.' -f1)

if [ "$AWS_VERSION" != "2" ]; then
    echo "AWS CLI v1 detected. Upgrading to v2..."
    curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    sudo ./aws/install --update
    rm -rf awscliv2.zip aws
    export PATH="/usr/local/bin:$PATH"
    echo "AWS CLI v2 installed."
fi

LOG_GROUP="/aws/lambda/ServerlessWebApp"

LOG_GROUP_CHECK=$(aws logs describe-log-groups \
    --log-group-name-prefix "$LOG_GROUP" \
    --query "logGroups[?logGroupName=='$LOG_GROUP'].logGroupName" \
    --output text 2>&1)

if [ -z "$LOG_GROUP_CHECK" ] || [ "$LOG_GROUP_CHECK" == "None" ]; then
    echo "FAIL - CloudWatch log group '$LOG_GROUP' not found."
    echo "       Make sure you have uploaded a file to the S3 bucket to trigger the function."
    exit 1
fi

LATEST_STREAM=$(aws logs describe-log-streams \
    --log-group-name "$LOG_GROUP" \
    --order-by LastEventTime \
    --descending \
    --max-items 1 \
    --query "logStreams[0].logStreamName" \
    --output text 2>&1)

if [ -z "$LATEST_STREAM" ] || [ "$LATEST_STREAM" == "None" ]; then
    echo "FAIL - Log group exists but no log streams found. Try uploading a file to S3."
    exit 1
fi

echo "PASS - CloudWatch log group '$LOG_GROUP' exists with log streams."
echo "       Latest stream: $LATEST_STREAM"
exit 0