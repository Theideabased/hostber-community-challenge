#!/bin/bash

# Build my docker image
docker build -t my_app:v1 .

# Run my docker image
docker run -e FLASK_APP=main.py -e FLASK_ENV=development -p 5000:5000 my_app

