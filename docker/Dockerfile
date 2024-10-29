FROM ghcr.io/cirruslabs/flutter:3.24.1

# China's domestic mirror
# ENV DART_PUB_HOSTED_URL=https://pub.flutter-io.cn
# ENV FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

WORKDIR /app

COPY . /app

RUN flutter doctor -v

RUN flutter pub get
