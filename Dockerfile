FROM dart:stable AS build

# Setup dependencies
WORKDIR /app
COPY . ./
RUN dart pub get

# Build backend
RUN dart run build_runner build
RUN cat .env && dart compile exe bin/backend.dart -o bin/backend
RUN dart compile exe bin/tools/migrator.dart -o bin/tools/migrator


# Re-package executables into alpine image
FROM alpine:3.14
RUN apk --no-cache add sqlite sqlite-dev
COPY --from=build /runtime/ /
COPY --from=build /app/bin/backend /app/bin/
COPY --from=build /app/bin/tools/migrator /app/bin/tools/migrator
COPY --from=build /app/public/ /app/public/

ENV PORT 3000
EXPOSE $PORT

WORKDIR /app

CMD ["/app/bin/backend"]