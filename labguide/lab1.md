# Assessment Objectives

This lab environment is designed to evaluate your practical skills in building and deploying a serverless web application on AWS. As part of this assessment, you will create an HTTP-triggered Lambda function that serves HTML content directly through a Function URL — without using API Gateway.

You are expected to follow AWS serverless best practices and use the specified resource names to ensure successful validation.


## Scenario 1: Create HTTP-triggered Serverless Function

### Task 1: Create and Deploy the Lambda Function

> **Note:** Follow the specified naming conventions exactly to ensure validation works properly.

1. Create a Lambda function named **ServerlessWebApp**.

   > **Note:** Use the name exactly as specified above to ensure successful validation.
2. Configure the function with the **Python 3.12** runtime.
3. In the code editor, replace the default code with the following:

```python
import json

def lambda_handler(event, context):
    print(json.dumps(event))   # ✅ ADD THIS LINE

    path = event.get("rawPath") or event.get("path") or "/"

    if path == "/" or path == "/index.html":
        return {
            "statusCode": 200,
            "headers": {"Content-Type": "text/html"},
            "body": get_index(),
            "isBase64Encoded": False
        }
    else:
        return {
            "statusCode": 404,
            "headers": {"Content-Type": "text/html"},
            "body": get_error(),
            "isBase64Encoded": False
        }

def get_index():
    return """<!DOCTYPE html>
<html>
<head>
    <title>Lambda Web App</title>
</head>
<body>
    <h1>Welcome to Serverless Web App</h1>
    <p>This page is served from AWS Lambda Function URL.</p>
</body>
</html>"""

def get_error():
    return """<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
</head>
<body>
    <h1>404 - Page Not Found</h1>
    <p>The page you requested does not exist.</p>
</body>
</html>"""

4. Deploy the function code.

> **Hint:** The `rawPath` field in the event object contains the incoming URL path. Clicking **Save** alone is not enough — make sure you click **Deploy**.

**Success Criteria:**
> - Lambda function **ServerlessWebApp** is created
> - Runtime is set to **Python 3.12**
> - Code is successfully deployed

<validation step="8e733187-46df-4139-b57f-5ddeb4948a8a" />



### Task 2: Configure Function URL and Test

> **Note:** Use Auth type **NONE** to allow public HTTP access to your function.

1. Enable a **Function URL** on the **ServerlessWebApp** function.
2. Set the Auth type to **NONE**.
3. Save the configuration and copy the generated Function URL.

   > **Note:** Once saved, navigate to **Configuration → Function URL** to find your generated URL. Click the copy icon next to the URL and paste it directly into your browser address bar to access the web app.

4. Validate the following behaviour using a browser:

| Path | Expected Status | Expected Response |
|---|---|---|
| `/` | 200 | Welcome to Serverless Web App |
| `/index.html` | 200 | Welcome to Serverless Web App |
| `/anything-else` | 404 | 404 - Page Not Found |

> **Hint:** Function URL is configured under **Configuration → Function URL**, not under Triggers. To verify status codes, use your browser's Developer Tools (F12 → Network tab).

 **Success Criteria:**
> - Function URL is enabled on **ServerlessWebApp**
> - Auth type is set to **NONE**
> - Browser returns the welcome page on `/` and `/index.html`
> - Browser returns a 404 page on an unknown path

<validation step="29e38797-ef36-4be6-8a35-731e1f3d07f9" />



## You have successfully completed the Assessment.
