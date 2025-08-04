#!/bin/bash

set -ex
docker build --platform=linux/amd64 --tag kraken_gcc12 .

