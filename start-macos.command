#!/bin/bash
echo "================================"
echo "  BIODIVERSITY DASHBOARD SETUP  "
echo "================================"
echo

# Check if Docker is running
docker info > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Docker Desktop is not running!"
  echo "Please install and start Docker Desktop before continuing."
  echo "Download here: https://www.docker.com/products/docker-desktop/"
  open "https://www.docker.com/products/docker-desktop/"
  open -a Docker
  echo "Waiting for Docker Desktop to start..."
  while ! docker info > /dev/null 2>&1; do sleep 1; done
fi

echo "Starting dashboard services..."
docker compose up -d

echo
echo "Dashboard services are starting!"
echo "Your browser will open the Dashboard Start Page."
open "$(pwd)/index.html"
echo
echo "If the dashboard doesn't open automatically, open 'index.html' in this folder."
echo

# Optional: pause until Enter is pressed
read -p "Press [Enter] to finish..."
