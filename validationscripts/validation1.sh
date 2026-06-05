#!/bin/bash

# -----------------------------------------------
# Validate Scenario 1 - Task 1
# Checks: Lambda function 'ServerlessWebApp' exists with Python 3.12 runtime
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

FUNCTION_CHECK=$(aws lambda get-function --function-name "$FUNCTION_NAME" 2>&1)

if echo "$FUNCTION_CHECK" | grep -q "ResourceNotFoundException\|Function not found"; then
    echo "FAIL - Lambda function '$FUNCTION_NAME' not found."
    exit 1
fi

RUNTIME=$(aws lambda get-function-configuration \
    --function-name "$FUNCTION_NAME" \
    --query "Runtime" \
    --output text 2>&1)

STATE=$(aws lambda get-function-configuration \
    --function-name "$FUNCTION_NAME" \
    --query "State" \
    --output text 2>&1)

if [ "$RUNTIME" != "python3.12" ]; then
    echo "FAIL - Lambda function found but runtime is '$RUNTIME', expected 'python3.12'."
    exit 1
fi

if [ "$STATE" != "Active" ]; then
    echo "FAIL - Lambda function exists but state is '$STATE', expected 'Active'."
    exit 1
fi

echo "PASS - Lambda function '$FUNCTION_NAME' exists with Python 3.12 runtime."
exit 0