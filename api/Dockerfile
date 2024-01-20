ARG alpine_version
ARG python_version
FROM python:${python_version}-alpine${alpine_version}
LABEL authors="ilanuzan"

WORKDIR /app
ENV PATH="$PATH:/app"

COPY . .
RUN pip install --upgrade pip && pip install -r requirements.txt

ENTRYPOINT ["/bin/bash", "-c"]