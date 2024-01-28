# Cheshire Games
 Pets Community Games - TBD
 
## Flows

```mermaid
flowchart TB
    CLIENTS[Clients] --> |Upload photos - 1| PHOTO_BUCKET[(Photo Upload S3 Bucket)]
    CLIENTS --> |Async API request - 2| PHOTO_TRANSFORMER[Photo Transformation API]
    PHOTO_TRANSFORMER --> |Fetch raw photos - 1| PHOTO_BUCKET
    PHOTO_TRANSFORMER --> |Upload raw & transformed photos - 2| USER_BUCKET[User S3 Bucket]
    CLIENTS --> |Check upload status - 3| PHOTO_TRANSFORMER
```
