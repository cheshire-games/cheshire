from fastapi import APIRouter
from pydantic import BaseModel

import photo_uploader.runner as photo_uploader

photo_uploader_router = APIRouter()  # GPU intensive


class PhotoUploadInfo(BaseModel):
    user_id: str
    upload_id: str


@photo_uploader_router.post("/photos")
async def upload_photos(photo_upload_info: PhotoUploadInfo):
    return photo_uploader.run(
        user_id=photo_upload_info.user_id,
        upload_id=photo_upload_info.upload_id,
    )
