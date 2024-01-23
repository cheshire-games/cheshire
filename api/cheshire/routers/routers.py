import os

from fastapi import APIRouter

from cheshire.routers.upload_route import photo_uploader_router

ROUTERS: dict[str, APIRouter] = {"photo_uploader": photo_uploader_router}


def get_included_routers() -> list[str]:
    env = os.environ.get("INCLUDED_ROUTERS")
    if env is None:
        return list(ROUTERS.keys())
    return env.split(",")
