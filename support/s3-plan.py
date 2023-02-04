"""
A wrapper script around AWS S3 file transfers.
It is supposed to be used as a helper script in a GitHub Action job.

The script accepts a string ("upload", "download", or "remove") and an integer that is a pull request number.
It needs it because the terraform plan output is saved in a file <PR number>.plan.
The script gets a state bucket from terraform.tf.

Then the plan output is uploaded to s3://<state bucket>/pending/<PR number>.plan
and downloaded into the current directory.
"""
import os
import sys
from textwrap import dedent

import boto3
import hcl


def usage():
    print(
        dedent(
            """
            Usage:
                
                python support/s3-plan.py upload|download|remove pull_request_number
            """
        )
    )


try:
    action = sys.argv[1]
    pull_request_number = sys.argv[2]
except IndexError:
    usage()
    sys.exit(1)


def get_bucket_name():
    """
    Find Terraform state bucket in terraform.tf.

    :return: Bucket name.
    :rtype: str
    """
    with open("terraform.tf") as fp:
        obj = hcl.load(fp)
        return obj["terraform"]["backend"]["s3"]["bucket"]


def upload(pr):
    """Upload plan output file."""
    s3_client = boto3.client("s3")
    bucket = get_bucket_name()
    plan_file = f"{pr}.plan"
    key_name = os.path.join("pending", plan_file)
    s3_client.upload_file(plan_file, bucket, key_name)
    print(f"Successfully uploaded s3://{bucket}/{key_name}.")


def download(pr):
    """Download plan output file."""
    s3_client = boto3.client("s3")
    bucket = get_bucket_name()
    plan_file = f"{pr}.plan"
    key_name = os.path.join("pending", plan_file)
    with open(plan_file, "wb") as f:
        s3_client.download_fileobj(bucket, key_name, f)
    print(f"Successfully downloaded s3://{bucket}/{key_name} and saved in {plan_file}.")


def remove(pr):
    """Remove the plan file from S3."""
    s3_client = boto3.client("s3")
    bucket = get_bucket_name()
    plan_file = f"{pr}.plan"
    key_name = os.path.join("pending", plan_file)
    s3_client.delete_object(Bucket=bucket, Key=key_name)
    print(f"Successfully removed s3://{bucket}/{key_name}.")


if action == "upload":
    upload(pull_request_number)
elif action == "download":
    download(pull_request_number)
elif action == "remove":
    remove(pull_request_number)
else:
    usage()
    sys.exit(1)
