from cheshire.app import app
from fastapi.testclient import TestClient

client = TestClient(app)


def _test_upload_photos():
    response = client.post("/photos")
    assert response.status_code == 200
    assert response.json() == {"msg": "Hello World"}
