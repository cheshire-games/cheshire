# Cheshire Games
 Pets Community Games - TBD

## Project layout
/applications   =>  contains the different applications (e.g. Mahjong, Tetris)
/services       =>  contains the different backend services (e.g. Community API, photo transformations)
/packages       =>  the packages that are needed across the repo (e.g. DynamoDB table API)

TBD - directory structure should be language agnostic?

## CI/CD
Using Github Actions as CI/CD runner, and Please for monorepo tooling.

## Flows

```mermaid
flowchart TB
    CLIENTS[Clients] --> |Upload photos - 1| PHOTO_BUCKET[(Photo Upload S3 Bucket)]
    CLIENTS --> |Async API request - 2| PHOTO_TRANSFORMER[Photo Transformation API]
    PHOTO_TRANSFORMER --> |Fetch raw photos - 1| PHOTO_BUCKET
    PHOTO_TRANSFORMER --> |Upload raw & transformed photos - 2| USER_BUCKET[User S3 Bucket]
    CLIENTS --> |Check upload status - 3| PHOTO_TRANSFORMER
```
