FROM elixir:1.15.4-slim

WORKDIR /app

COPY . .

RUN apt-get update && apt-get install -y make gcc inotify-tools && \
    mix local.hex --force && \
    mix archive.install hex phx_new 1.7.7 --force && \
    mix deps.get && mix deps.compile

