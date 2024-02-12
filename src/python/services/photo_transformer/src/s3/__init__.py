import boto3

client = boto3.client("s3")

BUCKET_NAME = "my-test-bucket"  # TODO change
MAX_PHOTOS_TO_HANDLE = 50
