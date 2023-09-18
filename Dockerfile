FROM rust:1.72-bookworm as builder

WORKDIR /app/rinha-luajit-rs
COPY . .
RUN cargo install --path .


FROM debian:bookworm-slim

COPY --from=builder /usr/local/cargo/bin/rinha-luajit-rs /usr/local/bin/rinha-luajit-rs

ENTRYPOINT ["rinha-luajit-rs", "/var/rinha/source.rinha.json"]
