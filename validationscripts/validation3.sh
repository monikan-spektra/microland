#!/bin/bash

# -----------------------------------------------
# Validate Scenario 2 - Task 1
# Checks: IAM role 'lam-lab-role' exists with EC2 trust and AmazonS3ReadOnlyAccess
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

ROLE_NAME="lam-lab-role"

ROLE_CHECK=$(aws iam get-role --role-name "$ROLE_NAME" 2>&1)

if echo "$ROLE_CHECK" | grep -q "NoSuchEntity\|cannot be found"; then
    echo "FAIL - IAM role '$ROLE_NAME' not found."
    exit 1
fi

TRUST=$(aws iam get-role \
    --role-name "$ROLE_NAME" \
    --query "Role.AssumeRolePolicyDocument.Statement[0].Principal.Service" \
    --output text 2>&1)

if ! echo "$TRUST" | grep -q "ec2.amazonaws.com"; then
    echo "FAIL - Role '$ROLE_NAME' exists but trusted entity is not EC2."
    echo "       Found: $TRUST"
    exit 1
fi

POLICIES=$(aws iam list-attached-role-policies \
    --role-name "$ROLE_NAME" \
    --query "AttachedPolicies[*].PolicyName" \
    --output text 2>&1)

if ! echo "$POLICIES" | grep -q "AmazonS3ReadOnlyAccess"; then
    echo "FAIL - Role '$ROLE_NAME' found but 'AmazonS3ReadOnlyAccess' policy is not attached."
    echo "       Attached policies: $POLICIES"
    exit 1
fi

echo "PASS - IAM role '$ROLE_NAME' exists with EC2 trust and AmazonS3ReadOnlyAccess policy."
exit 0