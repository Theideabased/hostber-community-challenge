#!/bin/bash

# Build my docker image
docker build -t your-image-name .

# Run my docker image
docker run -p 80:80 your-image-name
