FROM cheshire-base
LABEL authors="ilanuzan"

COPY pubspec.lock ./
RUN flutter pub get
COPY . .