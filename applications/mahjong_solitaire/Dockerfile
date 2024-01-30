FROM cheshire-base
LABEL authors="ilanuzan"

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get
COPY . .