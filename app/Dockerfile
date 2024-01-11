ARG ubuntu_version
FROM ubuntu:$ubuntu_version
LABEL authors="ilanuzan"

WORKDIR /app
ENV PATH="$PATH:/app"

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN set -x \
    && apt-get update -y \
    && apt-get install -y wget xz-utils git locales curl unzip \
    && locale-gen en_US.UTF-8  \
    && dpkg-reconfigure locales \
    && git config --global user.email "ilan9uzan@gmail.com" \
    && git config --global user.name "Ilan Uzan" \
    && git config --global http.postBuffer 52428800 \
    && git config --global core.compression 0

################################################### FLUTTER INSTALL ###################################################
### Installing Flutter directly from github repository due to missing arm64 support in Flutter SDK archive -        ###
###                         https://docs.flutter.dev/release/archive?tab=linux                                      ###
#######################################################################################################################
ARG flutter_version
RUN git clone --depth 1 --branch $flutter_version https://github.com/flutter/flutter.git
ENV PATH="$PATH:/app/flutter/bin"
RUN flutter doctor --verbose && flutter precache

COPY . .
RUN flutter pub get

ENTRYPOINT ["/bin/bash", "-c"]