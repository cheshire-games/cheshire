# Flows
There are several flows in the system that involve backend work:
1. Uploading photos to S3 (+ necessary transformations)
2. Loading transformed photos from S3

## Upload photos to S3
1. Does photo adhere to standards?
2. Does photo contain an animal?
3. Remove background from image
4. Save transformed photo in S3
5. Save metadata in a DynamoDB table

### Example Request
```json
{
  "user_id": "ilan9uzan@gmail.com",
  "community_id": 345
}
```

### SUCCESS Response:
```json
{
    "status_code": 200,
    "body": {
        "photos": {
            "<photo-id-1>": "s3://<bucket-name>/<photo-id-1>_transformed.png",
            "<photo-id-2>": "s3://<bucket-name>/<photo-id-2>_transformed.png"
        }
    }
}
```

### Other responses
TBD

## Load photos from S3
TBD