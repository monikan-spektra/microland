# Assessment Objectives

This lab environment is designed to evaluate your practical skills in configuring AWS Identity and Access Management (IAM). As part of this assessment, you will create an IAM role that grants an EC2 instance secure, credential-free access to S3.

You are expected to follow AWS IAM best practices and use the specified resource names to ensure successful validation.

---

## Scenario 2: Create IAM Role for EC2 to Access S3 Securely

This scenario evaluates your ability to create and assign an IAM role that grants an EC2 instance secure access to S3 — without using access keys.

You are expected to follow AWS IAM best practices and use the specified resource names to ensure successful validation.

---

### Task 1: Create the IAM Role

> **Note:** Follow the specified naming conventions exactly to ensure validation works properly.

1. Navigate to the **IAM** service in the AWS Management Console.
2. Create a new IAM role named **lam-lab-role**.
3. Attach the following managed policy to the role:

   | Policy | Purpose |
   |---|---|
   | `AmazonS3ReadOnlyAccess` | Grants EC2 read access to S3 |


> **Hint:** The trusted entity defines which service can assume this role. Make sure you select **EC2**, not Lambda or another service.

**Success Criteria:**
> - IAM role **lam-lab-role** is created
> - Trusted entity is set to **EC2**
> - **AmazonS3ReadOnlyAccess** policy is attached


<validation step="e2aa55a5-9126-4e42-b58a-c7bdba7e716c" />

---

### Task 2: Attach the IAM Role to the EC2 Instance

> **Note:** Your EC2 instance is pre-provisioned. Do not modify any other instance settings.

1. Navigate to the **EC2** service and locate the instance named **lab-vm-<inject key="DeploymentID"/>**.
2. Attach the IAM role **lam-lab-role** to the instance.
3. Verify the role is successfully associated with the instance.

**Success Criteria:**
> - IAM role **lam-lab-role** is attached to **lab-vm-<inject key="DeploymentID"/>**
> - The instance profile is visible under the instance's **Security** tab

<validation step="51d9cd69-c1c6-48a3-a907-551f6146be09" />

## You have successfully completed the scenario-2
