#!/bin/bash

# This script runs on the REMOTE server
# Variables passed via SSH: IMAGE

echo "Starting deployment of $IMAGE on $(hostname)"

# Pull the latest image from Harbor
# Note: The remote system is assumed to be already logged into Harbor
echo "Pulling image: $IMAGE"
docker pull $IMAGE

# Extract container name from image path (or use a fixed name)
CONTAINER_NAME="my-web-app"

# Stop and remove existing container if it exists
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Stopping and removing existing container: $CONTAINER_NAME"
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi

# Run the new container
echo "Starting new container: $CONTAINER_NAME"
docker run -d \
    --name $CONTAINER_NAME \
    --restart always \
    -p 80:80 \
    $IMAGE

echo "Deployment completed successfully!"
