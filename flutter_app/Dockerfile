# Build stage
FROM ghcr.io/cirruslabs/flutter:3.44.0 AS build

WORKDIR /app
COPY . .

RUN flutter pub get
RUN flutter build web --release --dart-define-from-file=env.json

# Serve stage
FROM nginx:1.31.1-alpine-slim

# RUN adduser -S -h /home/ngx ngx
# USER ngx

RUN apk add bash vim net-tools

WORKDIR /home

COPY --from=build /app/build/web /usr/share/nginx/html
COPY ./nginx/api.conf /etc/nginx/conf.d/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
