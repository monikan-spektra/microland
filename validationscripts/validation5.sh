#!/bin/bash

# -----------------------------------------------
# Validate Scenario 3 - Task 1
# Checks: S3 trigger configured on 'ServerlessWebApp' for lab-bucket-<DeploymentID>
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

FUNCTION_NAME="ServerlessWebApp"

# Auto-detect bucket name starting with 'lab-bucket-'
BUCKET_NAME=$(aws s3api list-buckets \
    --query "Buckets[?starts_with(Name, 'lab-bucket-')].Name" \
    --output text 2>&1)

if [ -z "$BUCKET_NAME" ] || [ "$BUCKET_NAME" == "None" ]; then
    echo "FAIL - Could not find a bucket starting with 'lab-bucket-'. Make sure the environment is provisioned."
    exit 1
fi

echo "Detected bucket: $BUCKET_NAME"

POLICY=$(aws lambda get-policy \
    --function-name "$FUNCTION_NAME" \
    --query "Policy" \
    --output text 2>&1)

if echo "$POLICY" | grep -q "ResourceNotFoundException"; then
    echo "FAIL - No resource-based policy found on '$FUNCTION_NAME'. S3 trigger may not be set."
    exit 1
fi

if ! echo "$POLICY" | grep -q "s3.amazonaws.com"; then
    echo "FAIL - S3 trigger is not configured on '$FUNCTION_NAME'."
    exit 1
fi

if ! echo "$POLICY" | grep -q "$BUCKET_NAME"; then
    echo "FAIL - S3 trigger exists but is not linked to bucket '$BUCKET_NAME'."
    exit 1
fi

echo "PASS - S3 trigger for bucket '$BUCKET_NAME' is configured on '$FUNCTION_NAME'."
exit 0