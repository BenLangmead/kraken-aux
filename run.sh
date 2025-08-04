#!/bin/bash

set -ex
docker run --platform=linux/amd64 -it -v `pwd`:/code kraken_gcc12 /bin/bash
