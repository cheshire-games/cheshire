from fastapi import FastAPI

from routers.routers import get_included_routers, ROUTERS

app = FastAPI()


@app.get("/status")
def root():
    return {"message": "Healthy"}


if __name__ == "__main__":
    included_routers = get_included_routers()
    for router_name, router_api in ROUTERS:
        if router_name in included_routers:
            app.include_router(router_api)
