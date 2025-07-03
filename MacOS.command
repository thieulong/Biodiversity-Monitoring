#!/bin/bash
echo "==============================="
echo "  BIODIVERSITY DASHBOARD SETUP"
echo "==============================="
echo ""

# Function to check if Docker is ready
is_docker_ready() {
    docker info > /dev/null 2>&1
    return $?
}

# Check if docker command is available
if ! command -v docker &> /dev/null
then
    echo "Docker Desktop is not installed."
    echo "Downloading Docker Desktop installer to your Downloads folder..."
    curl -L -o "$HOME/Downloads/Docker.dmg" "https://desktop.docker.com/mac/main/amd64/Docker.dmg"
    echo "Docker Desktop installer has been downloaded to your Downloads folder."
    echo "Please open 'Docker.dmg', install Docker Desktop, then re-run this script."
    echo "Or download manually: https://www.docker.com/products/docker-desktop/"
    read -p "Press enter to exit."
    exit
fi

# Try to start Docker Desktop if it's not running
if ! is_docker_ready; then
    echo "Docker Desktop is installed but not running."
    echo "Starting Docker Desktop..."
    open -a Docker
    echo "Waiting 10 seconds for Docker Desktop to start..."
    sleep 10
    # Then check in a loop until Docker is ready
    until is_docker_ready; do
        echo "Still waiting for Docker Desktop..."
        sleep 5
    done
fi

# Final check
if ! is_docker_ready; then
    echo "Docker Desktop did not start successfully. Please start it manually, then rerun this script."
    read -p "Press enter to exit."
    exit
fi

echo "Starting dashboard services..."
docker compose up -d

echo ""
echo "Dashboard services are starting!"
echo "Opening dashboard homepage..."
open "index.html"
echo ""
echo "If the dashboard doesn't open automatically:"
echo "- Open 'index.html' in this folder"
echo "- Or open http://localhost:1880/ui/  (CSV upload)"
echo "- Or open http://localhost:3000/     (Grafana dashboard)"
echo ""

read -p "Press enter to exit."
