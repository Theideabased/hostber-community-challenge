# Use a lightweight base image
FROM node:14 AS build

# Set a working directory in the container
WORKDIR /app

# Copy and install the Vue.js application dependencies
COPY client/package.json client/package-lock.json ./
RUN npm install

# Copy the Vue.js application source code
COPY client/ .

# Build the Vue.js application
RUN npm run build

# Use a Python base image
FROM python:3.9

# Set a working directory for the Flask proxy
WORKDIR /app

# Copy and install Python Flask dependencies
COPY server/requirements.txt ./
RUN pip install -r requirements.txt

# Copy the Flask proxy source code
COPY server/ .

# Copy the Nginx configuration
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Copy the Vue.js application build from the previous build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Copy the index.html file from the public directory
COPY client/public/index.html /usr/share/nginx/html/index.html

# Expose the port the Flask proxy will run on
EXPOSE 5000

# Start the Flask proxy
CMD ["python", "main.py"]
