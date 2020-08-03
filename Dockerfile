# syntax=docker/dockerfile:experimental
FROM rust:slim AS builder

WORKDIR /zola

COPY zola ./

RUN apt-get update && apt-get install -y build-essential libsass-dev

RUN \
    --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/zola/target \
    cargo build --release && \
    mv /zola/target/release/zola /bin


FROM debian:buster-slim

COPY --from=builder /bin/zola /usr/local/bin

USER 1000

CMD [ "zola", "build" ]
