from cheshire.communities import dynamodb_client
from boto3.dynamodb.table import TableResource, BatchWriter
from botocore.exceptions import ClientError

from cheshire.logger import logger


class Users:
    """Encapsulates an Amazon DynamoDB table of users data."""

    def __init__(self, table_name: str):
        """
        :param table_name: A Boto3 DynamoDB.Table resource.
        """
        self.table_name = table_name
        self.table: TableResource = dynamodb_client.Table(self.table_name)
        self.table_writer: BatchWriter = self.table.batch_writer()

    def create_user(self, user_id: str, nickname: str):
        dynamodb_client
        self.table_writer.put_item(
            Item={
                user_id: {

                }
            }
        )

    def create_community(self, user_id: str, name: str, description: str, included_users: list[str]):
        """Adds a community to the table"""
        try:
            self.table_writer.put_item(
                Item={
                    user_id: {
                        "communities": {

                        }
                    }
                }
            )
        except ClientError as err:
            logger.error(
                f"Couldn't add community {name} to table {self.table_name}. "
                f"Here's why: {err.response['Error']['Code']}: {err.response['Error']['Message']}"
            )
            raise

    def add_photos(self, user_id: str, community_name: str, included_users: list[str]):
        """
        """
        try:
            self.table_writer.put_item(
                Item=dict(
                    user_id=user_id,
                    community_name=community_name,
                    included_users=included_users,
                )
            )
        except ClientError as err:
            logger.error(
                f"Couldn't add community {community_name} to table {self.table_name}. "
                f"Here's why: {err.response['Error']['Code']}: {err.response['Error']['Message']}"
            )
            raise