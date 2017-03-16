#!/usr/bin/env bash
docker build -t ex-test:latest .
docker run -it --rm --name ex-test -p 8080:8080 ex-test:latest