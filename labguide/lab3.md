# Assessment Objectives

This lab environment is designed to evaluate your practical skills in building event-driven serverless architectures on AWS. As part of this assessment, you will add an S3 trigger to the existing Lambda function so it automatically logs a notification to CloudWatch Logs on every file upload.

You are expected to follow AWS serverless best practices and use the specified resource names to ensure successful validation.


## Scenario 3: Create Lambda Function Triggered by S3 Upload

This scenario evaluates your ability to configure an S3 event trigger on the **ServerlessWebApp** Lambda function created in Scenario 1 and validate it logs notifications to CloudWatch Logs.


### Task 1: Add the S3 Trigger to the Existing Lambda Function

> **Note:** Your S3 bucket is pre-provisioned. Do not create a new Lambda function — use the **ServerlessWebApp** function from Scenario 1.

1. Navigate to the **Lambda** service and open the **ServerlessWebApp** function.
2. Go to the **Configuration** tab and select **Triggers**.
3. Click **Add trigger** and select **S3** as the source.
4. Select the pre-provisioned bucket named **lab-bucket-<inject key="DeploymentID"/>**.
5. Set the **Event type** to **PUT** (triggered on object uploads).
6. Acknowledge the recursive invocation warning and click **Add**.


 **Success Criteria:**
> - S3 trigger is added to **ServerlessWebApp**
> - Trigger source is **lab-bucket-<inject key="DeploymentID"/>**
> - Event type is set to **PUT**

<validation step="UUID" />


### Task 2: Validate the S3 Trigger via CloudWatch Logs

> **Note:** Do not modify the existing function code — the trigger will log events automatically.

1. Navigate to the **S3** bucket named **lab-bucket-<inject key="DeploymentID"/>** and upload any file.
2. Open **CloudWatch → Log groups → /aws/lambda/ServerlessWebApp**.
3. Confirm that a new log stream was created for the S3 upload event.
4. Verify the log entry contains the bucket name and uploaded file key.


 **Success Criteria:**
> - A file is uploaded to **lab-bucket-<inject key="DeploymentID"/>**
> - CloudWatch log group **/aws/lambda/ServerlessWebApp** exists
> - A new log stream is created after the upload

<validation step="UUID" />


## You have successfully completed assessment