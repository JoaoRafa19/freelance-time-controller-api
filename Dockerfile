FROM dart
# uncomment next line to ensure latest Dart and root CA bundle
#RUN apt -y update && apt -y upgrade
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get
COPY ./ ./
RUN pub get --offline
RUN dart pub run build_runner build --delete-conflicting-outputs
COPY ./ ./
RUN dart compile exe /app/bin/server.dart -o /app/bin/server
FROM subfuzion/dart-scratch
COPY --from=0 /app/bin/server /app/bin/server
# COPY any other directories or files you may require at runtime, ex:
#COPY --from=0 /app/static/ /app/static/
EXPOSE 8000
ENTRYPOINT ["/app/bin/server"]