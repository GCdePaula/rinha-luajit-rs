#!/bin/bash

/usr/bin/time -l -h -p docker run -v ./source.rinha.json:/var/rinha/source.rinha.json rinha:latest
