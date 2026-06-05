#!/bin/bash

# -----------------------------------------------
# Validate Scenario 1 - Task 2
# Checks: Function URL is enabled with Auth type NONE
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

URL_CONFIG=$(aws lambda get-function-url-config \
    --function-name "$FUNCTION_NAME" 2>&1)

if echo "$URL_CONFIG" | grep -q "ResourceNotFoundException\|does not exist\|Invalid choice"; then
    echo "FAIL - Function URL is not configured on '$FUNCTION_NAME'."
    exit 1
fi

AUTH_TYPE=$(aws lambda get-function-url-config \
    --function-name "$FUNCTION_NAME" \
    --query "AuthType" \
    --output text 2>&1)

FUNCTION_URL=$(aws lambda get-function-url-config \
    --function-name "$FUNCTION_NAME" \
    --query "FunctionUrl" \
    --output text 2>&1)

if [ "$AUTH_TYPE" != "NONE" ]; then
    echo "FAIL - Function URL exists but Auth type is '$AUTH_TYPE', expected 'NONE'."
    exit 1
fi

echo "PASS - Function URL is enabled with Auth type NONE."
echo "       URL: $FUNCTION_URL"
exit 0