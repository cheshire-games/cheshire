# Photo Uploader Lambda

## Upload photos to S3
TBD - mermaid diagram

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