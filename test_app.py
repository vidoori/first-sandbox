from app import app


def test_index():
    client = app.test_client()
    response = client.get("/")
    assert response.status_code == 200
    assert response.get_json() == {"status": "ok"}


def test_intentional_failure():
    client = app.test_client()
    response = client.get("/")
    assert response.get_json() == {"status": "broken"}
