# rinha-luajit-rs

Compilador em Rust de `rinha` para Lua 5.1, executado com `luajit`.

## Clone

The project uses git sub-modules, so don't forget to clone accordingly.

```
git clone --recurse-submodules git@github.com:GCdePaula/rinha-luajit-rs.git
```

## Docker Build and Run `rinha-luajit-rs`

In the project's root directory, run the following:

```
docker build -t rinha-luajit-rs:latest .
```

```
docker run -v ./source.rinha.json:/var/rinha/source.rinha.json rinha-luajit-rs:latest
```

## Docker Build and Run `meta-rinha` compiler

In the project's root directory, run the following:

```
docker build -f Dockerfile-meta -t meta-rinha:latest .
```

```
docker run -v ./source.rinha.json:/var/rinha/source.rinha.json meta-rinha:latest
```


## Run rinha through `meta-rinha`

In the project's root directory, run the following:

```
docker build -t rinha-luajit-rs:latest . && docker build -f Dockerfile-meta -t meta-rinha:latest . && docker build -f Dockerfile-rinha -t rinha:latest .
```

```
docker run -v ./source.rinha:/var/rinha/source.rinha rinha:latest > source.rinha.json && \
docker run -v ./source.rinha.json:/var/rinha/source.rinha.json meta-rinha:latest > temp.rinha && \
docker run -v ./temp.rinha:/var/rinha/source.rinha rinha:latest > temp.rinha.json && \
docker run -v ./temp.rinha.json:/var/rinha/source.rinha.json rinha-luajit-rs:latest
```

Change the last line to use your own rinha interpreter/compiler.
