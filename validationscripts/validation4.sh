#!/bin/bash

# -----------------------------------------------
# Validate Scenario 2 - Task 2
# Checks: IAM role 'lam-lab-role' is attached to current EC2 instance
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

# Get current instance ID from metadata service
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

if [ -z "$INSTANCE_ID" ]; then
    echo "FAIL - Could not retrieve instance ID from metadata service."
    exit 1
fi

echo "Detected instance: $INSTANCE_ID"

PROFILE=$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --query "Reservations[0].Instances[0].IamInstanceProfile.Arn" \
    --output text 2>&1)

if [ -z "$PROFILE" ] || [ "$PROFILE" == "None" ]; then
    echo "FAIL - No IAM role is attached to this instance."
    exit 1
fi

if ! echo "$PROFILE" | grep -q "$ROLE_NAME"; then
    echo "FAIL - A different IAM role is attached to this instance."
    echo "       Attached profile: $PROFILE"
    exit 1
fi

echo "PASS - IAM role '$ROLE_NAME' is attached to instance '$INSTANCE_ID'."
exit 0