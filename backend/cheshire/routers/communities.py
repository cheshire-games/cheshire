from fastapi import APIRouter
from pydantic import BaseModel

import cheshire.photos.upload.runner as photo_uploader

community_router = APIRouter()  # GPU intensive


class CreateCommunityInfo(BaseModel):
    user_id: str
    community_name: str


@community_router.post("/communities/create")
def create(create_community_info: CreateCommunityInfo):
    return {}
