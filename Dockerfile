FROM dart:stable AS build

# Setup dependencies
WORKDIR /app
COPY . ./
RUN dart pub get

# Build backend
RUN dart run build_runner build --delete-conflicting-outputs
RUN dart compile exe bin/backend.dart -o bin/backend
RUN dart compile exe bin/tools/migrator.dart -o bin/tools/migrator


# Re-package executables into alpine image
FROM alpine:3.14
COPY --from=build /runtime/ /
COPY --from=build /app/bin/backend /app/bin/
COPY --from=build /app/bin/tools/migrator /app/bin/tools/migrator
COPY --from=build /app/public/ /app/public/

ENV PORT 3000
EXPOSE $PORT

WORKDIR /app

# Nasty hack to get-around not being able to access Render.com's shell. 
# No money for subscription.
RUN bin/tools/migrator migrate

CMD ["/app/bin/backend"]