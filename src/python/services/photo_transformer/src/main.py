import argparse

from src.runner import run


def _parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument('--user-id', dest='user_id', type=str, required=True)
    parser.add_argument('--upload-id', dest='upload_id', type=str, required=True)
    return parser.parse_args()


def _save(result: dict):
    pass


if __name__ == "__main__":
    args = _parse_args()
    result = run(user_id=args.user_id, upload_id=args.upload_id)
    _save(result)
