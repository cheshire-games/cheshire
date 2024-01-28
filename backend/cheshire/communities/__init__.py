import boto3
import boto3.dynamodb as dynamodb

boto3.setup_default_session(profile_name="communities-api")
dynamodb_client: dynamodb = boto3.client("dynamodb")
