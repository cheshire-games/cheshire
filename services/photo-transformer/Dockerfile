FROM cheshire-base
LABEL authors="ilanuzan"

COPY requirements.txt ./
RUN python -m pip install -r requirements.txt
COPY ../backend .