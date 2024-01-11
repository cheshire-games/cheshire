# Photo Uploader Lambda

## Upload photos to S3
1. For each photo received:
   1. Does photo contain an animal?
   2. Remove background from image
   3. Save transformed photo in S3
   4. Remove original photo from S3
2. Save metadata in a DynamoDB table

TODO - move above to diagram

### Example Request
```json
{
    "user_id": "randomail@gmail.com",
    "upload_id": 3
}
```

### Example Response
Success status code: 201 (CREATED)

```json
{
   "stats": {
      "uploaded": 18,
      "errors": 5
   }
}
```