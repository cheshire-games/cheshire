ARG ubuntu_version
FROM ubuntu:$ubuntu_version
LABEL authors="ilanuzan"

WORKDIR /app
ENV PATH="$PATH:/app"

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

ARG python_version
RUN set -x \
    && apt-get update -y \
    && apt-get install software-properties-common -y \
    && add-apt-repository ppa:deadsnakes/ppa -y \
    && apt-get install -y python${python_version}

COPY requirements.txt ./
RUN pip install --upgrade pip \
    && pip install -r requirements.txt
COPY . .

ENTRYPOINT ["/bin/bash", "-c"]