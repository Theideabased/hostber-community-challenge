#!/bin/bash

# Create the main project directory
mkdir project
cd project

# Create subdirectories
mkdir client server nginx ci-cd iac monitoring

# Copy template files to appropriate directories
cp -r path/to/vue-app-files/* client/
cp -r path/to/flask-app-files/* server/
cp -r path/to/nginx-config-files/* nginx/
cp -r path/to/ci-cd-files/github-actions.yml ci-cd/
cp -r path/to/iac-files/* iac/
cp -r path/to/monitoring-configs/* monitoring/
cp path/to/README.md .  # Include your own README

# Initialize a Git repository
git init
git add .
git commit -m "Initial project setup"

# Function to check if a command is installed
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if Python 3.9+ is installed
if ! command_exists python3; then
  echo "Python 3.9+ is required but not found. Please install it."
  exit 1
fi

# Check if Flask is installed
if ! command_exists flask; then
  echo "Flask is not installed. Installing Flask..."
  pip3 install Flask
fi

# Check if Node.js and npm are installed
if ! command_exists node; then
  echo "Node.js 14+ is required but not found. Installing it..."
  curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
  sudo apt-get update
  sudo apt-get install -y nodejs
fi

# nginx Setup
echo "nginx setup"
cd nginx

# Install nginx if not yet installed
if ! command_exists nginx; then
  echo "Downloading Nginx..."
  curl -o nginx.tar.gz "http://nginx.org/download/nginx-1.21.0.tar.gz"
  tar -zxvf nginx.tar.gz -C /tmp
  rm nginx.tar.gz

  echo "Configuring and building Nginx..."
  cd /tmp/nginx-1.21.0
  ./configure
  make
  sudo make install

  echo "Nginx installation completed."
fi

# Copy nginx.conf
sudo cp nginx.conf /etc/nginx/conf.d/

# Backend Setup
echo "Backend Setup..."
cd ../server

# Install backend dependencies if not already installed
pip3 install -q -r requirements.txt

# Replace placeholders in .env
cp .env.sample .env

# Start Flask development server
export FLASK_APP=main.py
export FLASK_ENV=development
flask run &

echo "Backend development server started on http://localhost:5000."

# Frontend Setup
echo "Frontend Setup..."
cd ../client

# Install frontend dependencies if not already installed
npm install

# Replace placeholders in .env
cp .env.sample .env

# Start the Vue.js development server
# npm run serve &

echo "Frontend development server started on http://localhost:8080."

# Additional setup steps for CI/CD, IaC, and Monitoring can be added here

echo -e "\e[1;97m"
echo "   ____                 _       _     _ _      "
echo "  / ___| ___   ___   __| | ___ | |__ (_) | ___ "
echo " | |  _ / _ \\ / _ \\ / _  |/ _ \\|  _ \\| | |/ _ \\"
echo " | |_| | (_) | (_) | (_| | (_) | | | | | |  __/"
echo "  \\____|\\___/ \\___/ \\__,_|\\___/|_| |_|_|_|\\___|"
echo -e "\e[0m"
echo "Setup Complete"
