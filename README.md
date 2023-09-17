# rinha-luajit-rs

Compilador em Rust de `rinha` para Lua 5.1, executado com `luajit`.

## Clone

The project uses git sub-modules, so don't forget to clone accordingly.

```
git clone --recurse-submodules git@github.com:GCdePaula/rinha-luajit-rs.git
```

## Docker Build and Run

In the project's root directory, run the following:

```
docker build -t rinha-luajit-rs:latest .
```

```
docker run -v ./source.rinha.json:/var/rinha/source.rinha.json rinha-luajit-rs:latest
```
