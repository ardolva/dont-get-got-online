FROM rust:1.57-bullseye AS builder

WORKDIR /usr/src/app
COPY Cargo.toml Cargo.lock ./
COPY src/ ./src/
RUN cargo install --path .

RUN ls

# Runtime image
FROM debian:11-slim

# Run as "app" user
RUN useradd -ms /bin/bash app

USER app
WORKDIR /app

COPY --from=builder /usr/local/cargo/bin/dont-get-got-online /app/
COPY static/ /app/static/
COPY templates/ /app/templates/
COPY challenges.txt Rocket.toml /app/
# No CMD or ENTRYPOINT, see fly.toml with `cmd` override.
